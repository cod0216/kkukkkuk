package com.be.KKUKKKUK.domain.auth.service;

import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.service.RedisService;
import com.be.KKUKKKUK.global.util.JwtUtility;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Objects;
import java.util.Set;
import java.util.UUID;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.service<br>
 * fileName       : TokenService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : JWT 토큰에 대한 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.14          haelim           토큰 생성, 삭제 시 type 정보 추가<br>
 * 25.03.15          haelim           예외처리 및 주석 추가 <br>
 * 25.03.15          haelim           RedisService 분리 <br>
 * 25.03.20          haelim           액세스 토큰 블랙리스트 추가, 리프레시 토큰 한번만 사용하도록 수정 <br>
 * 25.03.26          haelim           토큰에 이름 저장하도록 수정  <br>
 * 25.03.30          haelim           리프레시 토큰 블랙리스트 추가, 동시 로그인 처리(UUID) <br>
 *
 */
@Service
@Transactional
@RequiredArgsConstructor
public class TokenService {

    private final JwtUtility jwtUtility;
    private final RedisService redisService;

    @Value("${jwt.refresh-token-validity}")
    private long refreshTokenValidity;

    private static final String BLACKLIST_ACCESS_PREFIX = "BLACKLIST:ACCESS:";
    private static final String BLACKLIST_REFRESH_PREFIX = "BLACKLIST:REFRESH:";

    /**
     * 주어진 사용자 id 와 name, 사용자 타입을 기반으로 새로운 액세스 토큰과 리프레시 토큰을 생성합니다.
     * 생성된 리프레시 토큰은 별도로 저장합니다.
     *
     * @param userId 사용자 ID
     * @param userName 사용자 Name
     * @param type   관련 타입 (예: HOSPITAL, OWNER)
     * @return 생성된 JWT 토큰 페어 (액세스 토큰, 리프레시 토큰)
     */
    public JwtTokenPairResponse generateTokens(Integer userId, String userName, RelatedType type) {
        // 1. UUID를 포함하여 액세스 토큰과 리프레시 토큰 생성
        String tokenUUID = UUID.randomUUID().toString();

        // 2. 같은 UUID 를 공유하는 token pair 생성
        String accessToken = jwtUtility.createAccessToken(userId, userName, type, tokenUUID);
        String refreshToken = jwtUtility.createRefreshToken(userId, userName, type, tokenUUID);

        // 3. 리프레시 토큰 저장
        saveRefreshToken(getTokenKey(userId, type, tokenUUID), refreshToken);
        return new JwtTokenPairResponse(accessToken, refreshToken);
    }


    /**
     * 리프레시 토큰으로 액세스 토큰, 리프레시 토큰을 재발급합니다.
     * 한 번 사용한 리프레시 트큰은 블랙리스트에 등록합니다.
     * @param request 토큰 재발급 요청
     * @return 새로운 JWT token pair
     */
    public JwtTokenPairResponse refreshAccessToken(HttpServletRequest request) {
        // 1. 요청에서 리프레시 토큰 확인
        String refreshToken = resolveToken(request);
        if (!jwtUtility.validateToken(refreshToken) || checkBlacklisted(refreshToken, true)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        // 2. 토큰에서 유저 정보 확인
        Integer userId = jwtUtility.getUserId(refreshToken);
        RelatedType type = jwtUtility.getUserType(refreshToken);
        String userName = jwtUtility.getUserName(refreshToken);

        // 3. 기존 리프레시 토큰 무효화
        blacklistToken(refreshToken, true);

        return generateTokens(userId, userName, type);
    }

    /**
     * 로그아웃 시 해당 액세스 토큰에 맵핑된 리프레시 토큰만 블랙리스트에 추가하고 삭제합니다.
     * @param request 사용자의 요청
     */
    public void logout(HttpServletRequest request) {
        // 1. 액세스 토큰 확인
        String accessToken = resolveToken(request);
        if (!jwtUtility.validateToken(accessToken) || checkBlacklisted(accessToken, false)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        // 2. 액세스 토큰에 맵핑된 리프레시 토큰 찾기
        Integer userId = jwtUtility.getUserId(accessToken);
        RelatedType userType = jwtUtility.getUserType(accessToken);
        String tokenUUID = jwtUtility.getUUID(accessToken);

        String storedRefreshToken = redisService.getValues(getTokenKey(userId, userType, tokenUUID));

        // 3. 해당 리프레시 토큰을 블랙리스트에 추가
        blacklistToken(storedRefreshToken, true);

        // 4. 사용한 액세스 토큰도 블랙리스트에 추가
        blacklistToken(accessToken, false);
    }

    /**
     * 사용자의 모든 리프레시 토큰을 블랙리스트에 추가하고 삭제합니다.
     * @param request 사용자의 요청
     */
    public void logoutAll(HttpServletRequest request) {
        // 1. 액세스 토큰 확인
        String accessToken = resolveToken(request);
        if (!jwtUtility.validateToken(accessToken) || checkBlacklisted(accessToken, false)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        Integer userId = jwtUtility.getUserId(accessToken);
        RelatedType type = jwtUtility.getUserType(accessToken);

        // 2. 사용자 userID, type 에 해당하는 모든 리프레시 토큰 무효화
        Set<String> refreshTokenKeys = redisService.getKeys(getTokenFormat(userId, type));

        refreshTokenKeys.forEach(tokenKey -> {
            String refreshToken = redisService.getValues(tokenKey);
            blacklistToken(refreshToken, true);
        });

        // 3. 사용한 액세스 토큰도 블랙리스트에 추가
        blacklistToken(accessToken, false);
    }

    /**
     * 액세스 토큰 또는 리프레시 토큰이 블랙리스트에 있는지 확인합니다.
     * @param token 확인할 토큰
     * @param flagRefreshToken 리프레시 토큰 여부 (true: 리프레시, false: 액세스)
     * @return 블랙리스트에 있는 경우 TRUE, 아닌 경우 FALSE
     */
    public boolean checkBlacklisted(String token, boolean flagRefreshToken) {
        String key = (flagRefreshToken ? BLACKLIST_REFRESH_PREFIX : BLACKLIST_ACCESS_PREFIX) + token;
        return !Objects.isNull(redisService.getValues(key));
    }

    /**
     * 액세스 토큰 또는 리프레시 토큰을 블랙리스트에 추가합니다.
     * @param token 토큰
     * @param flagRefreshToken 리프레시 토큰 여부 (true: 리프레시, false: 액세스)
     */
    private void blacklistToken(String token, boolean flagRefreshToken) {
        long remainingTime = jwtUtility.getRemainingExpiration(token);
        String key = (flagRefreshToken ? BLACKLIST_REFRESH_PREFIX : BLACKLIST_ACCESS_PREFIX) + token;
        redisService.setValues(key, "", Duration.ofMillis(remainingTime));
    }

    /**
     * HTTP 요청에서 토큰을 추출합니다.
     * @param request HTTP 요청
     * @return 추출된 토큰
     */
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (bearerToken != null && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        throw new ApiException(ErrorCode.NO_AUTH_TOKEN);
    }

    /**
     * 리프레시 토큰을 Redis 에 저장합니다.
     */
    private void saveRefreshToken(String key, String refreshToken) {
        redisService.setValues(key, refreshToken, Duration.ofMillis(refreshTokenValidity));
    }

    /**
     * Redis 에서 사용할 key 값을 반환합니다.
     * 사용자 ID, 유형, UUID 값을 기반으로 key 값을 생성합니다.
     * @param userId 사용자 ID
     * @param type 사용자 유형 (Hospital, Owner)
     * @param tokenUUID 토큰의 UUID
     * @return Redis 에서 사용할 key 값
     */
    private String getTokenKey(Integer userId, RelatedType type, String tokenUUID) {
        return "%d:%s:%s".formatted(userId, type.name(), tokenUUID);
    }

    /**
     * Redis 에서 조회할 사용자의 format 을 생성합니다.
     * @param userId 사용자 ID
     * @param type 사용자 유형 (Hospital, Owner)
     * @return Redis 에서 조회할 Format
     */
    private String getTokenFormat(Integer userId, RelatedType type) {
        return "%d:%s:*".formatted(userId, type.name());
    }

}


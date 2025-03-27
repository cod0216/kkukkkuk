package com.be.KKUKKKUK.domain.auth.service;

import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.service.RedisService;
import com.be.KKUKKKUK.global.util.JwtUtility;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.util.Objects;

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
 * 25.03.17          haelim           토큰에 이름 저장하도록 수정  <br>
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

    private final String BLACKLIST_PREFIX = "BLACKLIST:";

    /**
     * 주어진 사용자 id 와 name, 사용자 타입을 기반으로 새로운 액세스 토큰과 리프레시 토큰을 생성합니다.
     * 생성된 리프레시 토큰은 별도로 저장합니다.
     *
     * @param userId 사용자 ID
     * @param userName 사용자 Name
     * @param type   관련 타입 (예: ADMIN, USER)
     * @return 생성된 JWT 토큰 페어 (액세스 토큰, 리프레시 토큰)
     */
    public JwtTokenPairResponse generateTokens(Integer userId, String userName, RelatedType type) {
        String accessToken = jwtUtility.createAccessToken(userId, userName, type);
        String refreshToken = jwtUtility.createRefreshToken(userId, userName, type);

        saveRefreshToken(userId, type, refreshToken);
        return new JwtTokenPairResponse(accessToken, refreshToken);
    }

     /**
     * 주어진 사용자 ID와 관련 타입에 해당하는 리프레시 토큰을 Redis 에서 삭제합니다.
     *
     * @param userId 사용자 ID
     * @param type   사용자 타입
     */
    public void deleteRefreshToken(Integer userId, RelatedType type) {
        String tokenKey = getRefreshTokenKey(userId, type);
        redisService.deleteValues(tokenKey);
    }

    /**
     * 리프레시 토큰을 Redis 에 저장합니다.
     * @param userId       사용자 ID
     * @param type         관련 타입
     * @param refreshToken 저장할 리프레시 토큰
     * @throws ApiException 토큰 저장에 실패한 경우 발생합니다.
     */
    public void saveRefreshToken(Integer userId, RelatedType type, String refreshToken) {
        String key = getRefreshTokenKey(userId, type);
        try {
            redisService.setValues(key, refreshToken, Duration.ofMillis(refreshTokenValidity));
        } catch (Exception e) {
            throw new ApiException(ErrorCode.TOKEN_STORAGE_FAILED);
        }
    }


    /**
     * 사용자 ID와 관련 타입을 기반으로 Redis 에서 저장된 리프레시 토큰을 가져옵니다.
     *
     * @param userId 사용자 ID
     * @param type   관련 타입
     * @return 저장된 리프레시 토큰 (없으면 null 반환)
     */
    public String getRefreshToken(Integer userId, RelatedType type) {
        return redisService.getValues(getRefreshTokenKey(userId, type));
    }

    /**
     * 리프레시 토큰을 검증한 후, 새로운 액세스 토큰을 생성합니다.
     * 한 번 사용한 리프레시 토큰은 삭제하고 재발급합니다.
     * @param request 리프레시 토큰 요청 객체
     * @return 새로운 액세스 토큰과 기존 리프레시 토큰을 포함하는 응답 객체
     * @throws ApiException 유효하지 않은 토큰이 제공된 경우 발생합니다.
     */
    public JwtTokenPairResponse refreshAccessToken(HttpServletRequest request) {
        // 1. 리프레시 토큰 파싱
        String refreshToken = resolveToken(request);

        // 2. 리프레시 토큰 유효성 검사
        if (!jwtUtility.validateToken(refreshToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        // 3. 토큰에서 사용자 ID, 타입 (동물병원 회원, 보호자 회원) 확인
        RelatedType type = jwtUtility.getUserType(refreshToken);
        Integer userId = jwtUtility.getUserId(refreshToken);
        String userName = jwtUtility.getUserName(refreshToken);

        // 4. 저장된 리프레시 토큰 비교
        String storedRefreshToken = getRefreshToken(userId, type);
        if (!refreshToken.equals(storedRefreshToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        // 5. 기존 리프레시 토큰 1회만 사용 가능하도록 즉시 삭제
        deleteRefreshToken(userId, type);

        // 6. 새로운 토큰 생성
        String newAccessToken = jwtUtility.createAccessToken(userId, userName, type);
        String newRefreshToken = jwtUtility.createRefreshToken(userId, userName, type);
        saveRefreshToken(userId, type, newRefreshToken);

        return new JwtTokenPairResponse(newAccessToken, newRefreshToken);
    }

    /**
     * 액세스 토큰을 블랙리스트에 추가하여 무효화합니다.
     * @param request 사용자의 요청
     */
    public void blacklistAccessToken(HttpServletRequest request) {
        String accessToken = resolveToken(request);

        if (!jwtUtility.validateToken(accessToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        long remainingTime = jwtUtility.getRemainingExpiration(accessToken);
        redisService.setValues(BLACKLIST_PREFIX + accessToken, "logout", Duration.ofMillis(remainingTime));
    }

    /**
     * 액세스 토큰이 블랙리스트에 있는지 확인합니다.
     * @param accessToken 확인할 액세스 토큰
     * @return 블랙리스트인 경우 TRUE, 블랙리스트가 아닌 경우(유효한 토큰) FALSE
     */
    public boolean checkBlacklisted(String accessToken) {
        String key = BLACKLIST_PREFIX + accessToken;
        return !Objects.isNull(redisService.getValues(key));
    }


    /**
     * 사용자 요청에서 Token 을 파싱합니다.
     * @param request 사용자가 보낸 토큰 재발급 요청
     * @return 사용자가 보낸 리프레시 토큰
     * @throws ApiException 요청 헤더에 리프레시 토큰이 없는 경우 예외처리
     */
    private String resolveToken(HttpServletRequest request) {
        String bearerToken = request.getHeader("Authorization");
        if (!Objects.isNull(bearerToken) && bearerToken.startsWith("Bearer ")) {
            return bearerToken.substring(7);
        }
        throw new ApiException(ErrorCode.NO_REFRESH_TOKEN);
    }

    /**
     * 사용자 ID와 타입을 기반으로 Redis 에서 사용할 키를 생성합니다.
     *
     * @param userId 사용자 ID
     * @param type   관련 타입
     * @return Redis 키 (예: "123:OWNER")
     */
    public String getRefreshTokenKey(Integer userId, RelatedType type) {
        return "%d:%s".formatted(userId, type.name());
    }
}

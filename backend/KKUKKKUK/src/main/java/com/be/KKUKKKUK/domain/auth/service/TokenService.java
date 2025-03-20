package com.be.KKUKKKUK.domain.auth.service;

import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.service.RedisService;
import com.be.KKUKKKUK.global.util.JwtUtility;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
 *
 */
@Service
@RequiredArgsConstructor
public class TokenService {
    private final JwtUtility jwtUtility;
    private final RedisService redisService;

    /**
     * 주어진 사용자 ID와 관련 타입을 기반으로 새로운 액세스 토큰과 리프레시 토큰을 생성합니다.
     * 생성된 리프레시 토큰은 별도로 저장합니다.
     *
     * @param userId 사용자 ID
     * @param type   관련 타입 (예: ADMIN, USER)
     * @return 생성된 JWT 토큰 페어 (액세스 토큰, 리프레시 토큰)
     */
    public JwtTokenPairResponse generateTokens(Integer userId, RelatedType type) {
        String accessToken = jwtUtility.createAccessToken(userId, type);
        String refreshToken = jwtUtility.createRefreshToken(userId, type);

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
        if (Objects.isNull(redisService.getValues(tokenKey))) throw new ApiException(ErrorCode.INVALID_TOKEN);
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
            redisService.setValues(key, refreshToken, Duration.ofDays(30));
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
     *
     * @param request 리프레시 토큰 요청 객체
     * @return 새로운 액세스 토큰과 기존 리프레시 토큰을 포함하는 응답 객체
     * @throws ApiException 유효하지 않은 토큰이 제공된 경우 발생합니다.
     */
    public JwtTokenPairResponse refreshAccessToken(HttpServletRequest request) {
        String refreshToken = resolveToken(request);

        if (!jwtUtility.validateToken(refreshToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        RelatedType type = jwtUtility.getUserType(refreshToken);
        Integer userId = jwtUtility.getUserId(refreshToken);

        String storedRefreshToken = getRefreshToken(userId, type);
        if (!refreshToken.equals(storedRefreshToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        String newAccessToken = jwtUtility.createAccessToken(userId, type);
        return new JwtTokenPairResponse(newAccessToken, refreshToken);
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
    private String getRefreshTokenKey(Integer userId, RelatedType type) {
        return "%d:%s".formatted(userId, type.name());
    }
}

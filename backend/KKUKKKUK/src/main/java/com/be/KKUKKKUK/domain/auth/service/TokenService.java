package com.be.KKUKKKUK.domain.auth.service;

import com.be.KKUKKKUK.domain.auth.dto.JwtTokenPair;
import com.be.KKUKKKUK.domain.auth.dto.request.RefreshTokenRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.RefreshTokenResponse;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.util.JwtUtility;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.concurrent.TimeUnit;

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
 *
 */
@RequiredArgsConstructor
@Service
@Slf4j
public class TokenService {
    private final RedisTemplate<String, String> redisTemplate;
    private final JwtUtility jwtUtility;

    public JwtTokenPair generateTokens(Integer userId, RelatedType type) {
        String accessToken = jwtUtility.createAccessToken(userId, type);
        String refreshToken = jwtUtility.createRefreshToken(userId, type);

        saveRefreshToken(userId, type, refreshToken);
        return new JwtTokenPair(accessToken, refreshToken);
    }

    public void deleteRefreshToken(Integer userId, RelatedType type) {
        redisTemplate.delete(getRefreshTokenKey(userId, type));
    }


    public void saveRefreshToken(Integer userId, RelatedType type, String refreshToken) {
        String key = getRefreshTokenKey(userId, type);
        try {
            redisTemplate.opsForValue().set(key, refreshToken, 30, TimeUnit.DAYS);
        } catch (Exception e) {
            throw new ApiException(ErrorCode.TOKEN_STORAGE_FAILED);
        }
    }

    private String getRefreshTokenKey(Integer userId, RelatedType type) {
        return userId + ":" + type.name(); // e.g., "123:ADMIN"
    }

    public RefreshTokenResponse refreshAccessToken(RefreshTokenRequest request) {
        String refreshToken = request.getRefreshToken();

        if (!jwtUtility.validateToken(refreshToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        RelatedType type = jwtUtility.getUserType(refreshToken);
        Integer userId = jwtUtility.getUserId(refreshToken);

        String storedRefreshToken = getRefreshToken(userId, type); // 변경된 부분
        if (!refreshToken.equals(storedRefreshToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        String newAccessToken = jwtUtility.createAccessToken(userId, type);
        return new RefreshTokenResponse(newAccessToken, refreshToken);
    }

    public String getRefreshToken(Integer userId, RelatedType type) {
        return redisTemplate.opsForValue().get(getRefreshTokenKey(userId, type));
    }
}

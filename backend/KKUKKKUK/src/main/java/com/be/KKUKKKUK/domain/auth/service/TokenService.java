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

        saveRefreshToken(userId, refreshToken);
        return new JwtTokenPair(accessToken, refreshToken);
    }

    public void saveRefreshToken(Integer userId, String refreshToken) {
        try {
            redisTemplate.opsForValue().set(String.valueOf(userId), refreshToken, 30, TimeUnit.DAYS);
        } catch (Exception e) {
            throw new RuntimeException("Failed to save refresh token for user: " + userId, e);
        }
    }

    public String getRefreshToken(Integer userId) {
        return redisTemplate.opsForValue().get(userId);
    }


    public void deleteRefreshToken(Integer userId) {
        redisTemplate.delete(String.valueOf(userId));
    }


    public RefreshTokenResponse refreshAccessToken(RefreshTokenRequest request) {
        String refreshToken = request.getRefreshToken();

        if (!jwtUtility.validateToken(refreshToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        RelatedType type = jwtUtility.getUserType(refreshToken);

        Integer userId = jwtUtility.getUserId(refreshToken);

        String storedRefreshToken = getRefreshToken(userId);
        if (!refreshToken.equals(storedRefreshToken)) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        String newAccessToken = jwtUtility.createAccessToken(userId, type);

        return new RefreshTokenResponse(newAccessToken, refreshToken);
    }


}

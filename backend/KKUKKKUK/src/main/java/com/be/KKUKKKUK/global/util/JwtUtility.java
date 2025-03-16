package com.be.KKUKKKUK.global.util;

import com.be.KKUKKKUK.global.enumeration.RelatedType;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Base64;
import java.util.Date;

import java.nio.charset.StandardCharsets;

/**
 * packageName    : com.be.KKUKKKUK.global.util<br>
 * fileName       : JwtUtility.java<br>
 * author         : haelim <br>
 * date           : 2025-03-13<br>
 * description    :  JWT 토큰 관련 유틸 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 2025-03-13          haelim          최초생성<br>
 * 2025-03-16          haelim          하드코딩 수정<br>
 */

@Component
public class JwtUtility {

    private static final String CLAIM_USER_ID = "userId";
    private static final String CLAIM_TYPE = "type";

    @Value("${jwt.secret}")
    private String secretKey;

    @Value("${jwt.access-token-validity}")
    private long accessTokenValidity;

    @Value("${jwt.refresh-token-validity}")
    private long refreshTokenValidity;

    private Key signingKey;

    /**
     * JWT 서명 키를 초기화합니다.
     */
    @PostConstruct
    protected void init() {
        byte[] keyBytes = secretKey.getBytes(StandardCharsets.UTF_8);
        signingKey = Keys.hmacShaKeyFor(Base64.getEncoder().encodeToString(keyBytes).getBytes(StandardCharsets.UTF_8));
    }

    /**
     * 사용자 ID와 타입을 기반으로 Access Token을 생성합니다.
     *
     * @param userId 사용자 ID
     * @param relatedType 사용자 타입
     * @return 생성된 Access Token
     */
    public String createAccessToken(Integer userId, RelatedType relatedType) {
        return createToken(userId, relatedType, accessTokenValidity);
    }

    /**
     * 사용자 ID와 타입을 기반으로 Refresh Token을 생성합니다.
     *
     * @param userId 사용자 ID
     * @param relatedType 사용자 타입
     * @return 생성된 Refresh Token
     */
    public String createRefreshToken(Integer userId, RelatedType relatedType) {
        return createToken(userId, relatedType, refreshTokenValidity);
    }

    /**
     * JWT 토큰을 생성합니다.
     *
     * @param userId 사용자 ID
     * @param relatedType 사용자 타입
     * @param validity 토큰 유효시간
     * @return 생성된 JWT 토큰
     */
    private String createToken(Integer userId, RelatedType relatedType, long validity) {
        Date now = new Date();
        Date expiration = new Date(now.getTime() + validity);

        return Jwts.builder()
                .claim(CLAIM_USER_ID, userId)
                .claim(CLAIM_TYPE, relatedType.name())
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(signingKey)
                .compact();
    }

    /**
     * JWT 토큰에서 사용자 ID를 추출합니다.
     *
     * @param token JWT 토큰
     * @return 사용자 ID
     */
    public Integer getUserId(String token) {
        return getClaim(token, CLAIM_USER_ID, Integer.class);
    }

    /**
     * JWT 토큰에서 사용자 타입(RelatedType)을 추출합니다.
     *
     * @param token JWT 토큰
     * @return 사용자 타입(RelatedType)
     */
    public RelatedType getUserType(String token) {
        return RelatedType.valueOf(getClaim(token, CLAIM_TYPE, String.class));
    }

    /**
     * JWT 토큰의 유효성을 검증합니다.
     *
     * @param token JWT 토큰
     * @return 유효한 경우 true, 그렇지 않으면 false
     */
    public boolean validateToken(String token) {
        try {
            parseClaims(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * JWT 토큰에서 특정 클레임을 가져옵니다.
     *
     * @param token JWT 토큰
     * @param claimKey 클레임 키
     * @param clazz 반환할 타입
     * @return 해당 클레임 값
     */
    private <T> T getClaim(String token, String claimKey, Class<T> clazz) {
        try {
            return parseClaims(token).get(claimKey, clazz);
        } catch (ExpiredJwtException e) {
            return e.getClaims().get(claimKey, clazz);
        }
    }

    /**
     * JWT 토큰에서 클레임(Claims)을 파싱합니다.
     *
     * @param token JWT 토큰
     * @return 클레임 객체
     */
    private Claims parseClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(signingKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}

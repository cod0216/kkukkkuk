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
import org.springframework.stereotype.Service;

import java.security.Key;
import java.util.Base64;
import java.util.Date;

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
 */
@Service
@RequiredArgsConstructor
public class JwtUtility {

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
        secretKey = Base64.getEncoder().encodeToString(secretKey.getBytes());
        signingKey = Keys.hmacShaKeyFor(secretKey.getBytes());
    }

    /**
     * 사용자 ID와 타입을 기반으로 Access Token을 생성합니다.
     */
    public String createAccessToken(Integer userId, RelatedType relatedType) {
        return createToken(userId, relatedType, accessTokenValidity);
    }

    /**
     * 사용자 ID와 타입을 기반으로 Refresh Token을 생성합니다.
     */
    public String createRefreshToken(Integer userId, RelatedType relatedType) {
        return createToken(userId, relatedType, refreshTokenValidity);
    }

    /**
     * JWT 토큰을 생성합니다.
     */
    private String createToken(Integer userId, RelatedType relatedType, long validity) {
        Claims claims = Jwts.claims();
        claims.put("userId", userId);
        claims.put("type", relatedType.name());

        Date now = new Date();
        Date expiration = new Date(now.getTime() + validity);

        return Jwts.builder()
                .setClaims(claims)
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(signingKey)
                .compact();
    }

    /**
     * JWT 토큰에서 사용자 ID를 추출합니다.
     */
    public Integer getUserId(String token) {
        try {
            return parseClaims(token).get("userId", Integer.class);
        } catch (ExpiredJwtException e) {
            return e.getClaims().get("userId", Integer.class);
        }
    }

    /**
     * JWT 토큰에서 사용자 타입(RelatedType)을 추출합니다.
     */
    public RelatedType getUserType(String token) {
        try {
            return RelatedType.valueOf(parseClaims(token).get("type", String.class));
        } catch (ExpiredJwtException e) {
            return RelatedType.valueOf(e.getClaims().get("type", String.class));
        }
    }

    /**
     * JWT 토큰의 유효성을 검증합니다.
     */
    public boolean validateToken(String token) {
        try {
            Jwts.parserBuilder()
                    .setSigningKey(signingKey)
                    .build()
                    .parseClaimsJws(token);
            return true;
        } catch (JwtException | IllegalArgumentException e) {
            return false;
        }
    }

    /**
     * JWT 토큰에서 클레임(Claims)을 파싱합니다.
     */
    private Claims parseClaims(String token) {
        return Jwts.parserBuilder()
                .setSigningKey(signingKey)
                .build()
                .parseClaimsJws(token)
                .getBody();
    }
}

package com.be.KKUKKKUK.global.util;

import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.security.Keys;
import io.jsonwebtoken.Claims;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import jakarta.annotation.PostConstruct;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;

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
 * 2025-03-20          haelim          토큰의 남은 시간 확인 메서드 (getRemainingExpiration) 추가 <br>
 * 2025-03-27          haelim          토큰에 사용자 이름 정보 추가 <br>
 * 2025-03-31          haelim          토큰에 UUID 추가 <br>
 */

@Component
public class JwtUtility {

    private static final String CLAIM_USER_ID = "id";
    private static final String CLAIM_TYPE = "type";
    private static final String CLAIM_USER_NAME = "name";
    private static final String CLAIM_UUID = "uuid";

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
     * @param userId 사용자 ID
     * @param relatedType 사용자 타입
     * @return 생성된 Access Token
     */
    public String createAccessToken(Integer userId, String userName, RelatedType relatedType, String uuid) {
        return createToken(userId, userName, relatedType, uuid, accessTokenValidity);
    }

    /**
     * 사용자 ID와 타입을 기반으로 Refresh Token을 생성합니다.
     * @param userId 사용자 ID
     * @param relatedType 사용자 타입
     * @return 생성된 Refresh Token
     */
    public String createRefreshToken(Integer userId, String userName, RelatedType relatedType, String uuid) {
        return createToken(userId, userName, relatedType, uuid, refreshTokenValidity);
    }

    /**
     * JWT 토큰을 생성합니다.
     * @param userId 사용자 ID
     * @param relatedType 사용자 타입
     * @param validity 토큰 유효시간
     * @return 생성된 JWT 토큰
     */
    private String createToken(Integer userId,  String userName, RelatedType relatedType, String uuid, long validity) {
        Date now = new Date();
        Date expiration = new Date(now.getTime() + validity);

        return Jwts.builder()
                .claim(CLAIM_USER_ID, userId)
                .claim(CLAIM_USER_NAME, userName)
                .claim(CLAIM_TYPE, relatedType.name())
                .claim(CLAIM_UUID, uuid)
                .setIssuedAt(now)
                .setExpiration(expiration)
                .signWith(signingKey)
                .compact();
    }

    /**
     * JWT 토큰에서 사용자 ID를 추출합니다.
     * @param token JWT 토큰
     * @return 사용자 ID
     */
    public Integer getUserId(String token) {
        return getClaim(token, CLAIM_USER_ID, Integer.class);
    }

    /**
     * JWT 토큰에서 사용자 NAME 을 추출합니다.
     * @param token JWT 토큰
     * @return 사용자 NAME
     */
    public String getUserName(String token) {
        return getClaim(token, CLAIM_USER_NAME, String.class);
    }

    /**
     * JWT 토큰에서 토큰의 UUID 을 추출합니다.
     * @param token JWT 토큰
     * @return UUID
     */
    public String getUUID(String token) {
        return getClaim(token, CLAIM_UUID, String.class);
    }
    /**
     * JWT 토큰에서 사용자 타입(RelatedType)을 추출합니다.
     * @param token JWT 토큰
     * @return 사용자 타입(RelatedType)
     */
    public RelatedType getUserType(String token) {
        return RelatedType.valueOf(getClaim(token, CLAIM_TYPE, String.class));
    }

    /**
     * JWT 토큰의 유효성을 검증합니다.
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
     * 주어진 토큰의 남은 만료 시간을 반환합니다.
     * @param token 검사할 JWT 토큰
     * @return 남은 만료 시간 (밀리초 단위)
     * @throws ApiException 유효하지 않은 토큰인 경우 예외 발생
     */
    public long getRemainingExpiration(String token) {
        Claims claims = parseClaims(token);
        Date expiration = claims.getExpiration();
        long remainingTime = expiration.getTime() - System.currentTimeMillis();

        if (remainingTime < 0) {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        return remainingTime;
    }

    /**
     * JWT 토큰에서 특정 클레임을 가져옵니다.
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

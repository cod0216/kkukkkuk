package com.be.KKUKKKUK.global.filter;

import com.be.KKUKKKUK.domain.auth.service.TokenService;
import com.be.KKUKKKUK.domain.hospital.service.HospitalDetailService;
import com.be.KKUKKKUK.domain.owner.service.OwnerDetailService;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.util.JwtUtility;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;
import java.util.Objects;

/**
 * packageName    : com.KKUKKKUK.global.filter<br>
 * fileName       : JwtAuthenticationFilter.java<br>
 * author         : haelim <br>
 * date           : 2025-03-13<br>
 * description    :  JWT 인증을 처리하는 필터 클래스입니다.
 *
 *  <p>이 필터는 Spring Security의 필터 체인에서 동작하며,
 *  요청이 들어올 때마다 실행됩니다. JWT 토큰을 검증하여 사용자 인증을 수행하고,
 *  토큰의 클레임을 파싱하여 사용자의 ID 및 타입을 확인합니다.</p>
 *
 *  <p>인증이 성공하면 `SecurityContextHolder`에 인증 정보를 저장하여
 *  이후의 보안 컨텍스트에서 사용할 수 있도록 합니다.</p>
 *
 * </p><br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 2025-03-13          haelim          최초생성<br>
 * 2025-03-20          haelim          액세스 토큰 블랙리스트 추가<br>
 * 2025-04-07          haelim          writeErrorResponse 삭제, ExceptionHandlingFilter 에서 처리 <br>
 */
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private static final AntPathMatcher pathMatcher = new AntPathMatcher();
    private final TokenService tokenService;
    private final JwtUtility jwtUtility;
    private final HospitalDetailService hospitalDetailService;
    private final OwnerDetailService ownerDetailService;

    private static final String HEADER_AUTHORIZATION = "Authorization";
    private static final String HEADER_BEARER = "Bearer ";
    private static final int HEADER_BEARER_LENGTH = HEADER_BEARER.length();

    private static final String[] ALLOWED_URLS = new String[]{
            "/",
            "/error",
            "/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/swagger-resources/**",
            "/api/auths/**",
            "/api/hospitals/authorization-number/**", "/api/hospitals/name/**", "/api/hospitals/account/**",
            "/ws/*", "/kkukkkuk/**"
    };

    /**
     * ALLOWED_URLS 에 포함되지만 예외적으로 인증이 필요한 URL 경로를 설정합니다.
     */
    public static final String[] NOT_ALLOWED_URLS = {
            "/api/auths/logout", "/api/auths/logout/all",
    };


    /**
     * 요청을 필터링하여 인증을 수행합니다.
     * 요청에서 JWT 토큰을 추출하고, 해당 토큰이 유효한지 검증한 후, 인증 정보를 SecurityContext에 설정합니다.
     *
     * @param request 요청 객체
     * @param response 응답 객체
     * @param filterChain 필터 체인
     * @throws ServletException 서블릿 예외
     * @throws IOException I/O 예외
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain ) throws ServletException, IOException {
        String uri = request.getRequestURI();

        // 1. 허용된 URL에 대해서는 인증 필터 통과
        if (checkAllowedUrl(uri)) {
            filterChain.doFilter(request, response);
            return;
        }

        // 2. 헤더에서 access token 확인
        String authHeader = request.getHeader(HEADER_AUTHORIZATION);
        if (Objects.isNull(authHeader) || !authHeader.startsWith(HEADER_BEARER)) {
            throw new ApiException(ErrorCode.NO_ACCESS_TOKEN);
        }

        // 3. access token 유효성 검증
        String accessToken = authHeader.substring(HEADER_BEARER_LENGTH);  // "Bearer "를 제외한 토큰 부분
        if (jwtUtility.validateToken(accessToken)) {
            // 3-1. 액세스 토큰이 유효하면 블랙리스트 검증
            if (checkTokenBlacklisted(accessToken)) {
                throw new ApiException(ErrorCode.INVALID_TOKEN);
            }

            // 3-2. 인증 토큰을 SecurityContext에 설정
            Authentication auth = getAuthentication(accessToken);
            SecurityContextHolder.getContext().setAuthentication(auth);

            // 3-3. 유효한 토큰 처리
            processValidAccessToken(accessToken);

            filterChain.doFilter(request, response);
        } else {
            SecurityContextHolder.clearContext(); // 인증 실패 시 보안 컨텍스트 초기화
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }
    }

    /**
     * 블랙리스트 확인 메서드입니다.
     * 레디스에 저장된 블랙리스트와 대조해서, 블랙리스트 여부를 판단합니다.
     * @param accessToken 엑세스 토큰
     * @return 블랙리스트 여부 true(블랙리스트), false(블랙리스트 아님)
     */
    private boolean checkTokenBlacklisted(String accessToken) {
        return tokenService.checkBlacklisted(accessToken, false);
    }

    /**
     * 유효한 액세스 토큰에 대해 사용자 인증을 처리하는 메서드입니다.
     * 유효한 액세스 토큰을 기반으로 사용자를 인증하고, 인증 정보를 SecurityContext 에 설정합니다.
     *
     * @param accessToken 유효한 액세스 토큰
     */
    protected void processValidAccessToken(String accessToken) {
        RelatedType type = jwtUtility.getUserType(accessToken);
        Integer userId = jwtUtility.getUserId(accessToken);

        UserDetails userDetails;
        if (type.equals(RelatedType.OWNER)) {
            userDetails = ownerDetailService.loadUserByUsername(userId.toString());
        } else if (type.equals(RelatedType.HOSPITAL)) {
            userDetails = hospitalDetailService.loadUserByUsername(userId.toString());
        } else {
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }

        UsernamePasswordAuthenticationToken authentication =
                new UsernamePasswordAuthenticationToken(userDetails, null, userDetails.getAuthorities());

        SecurityContextHolder.getContext().setAuthentication(authentication);
    }

    /**
     * JWT 토큰에서 사용자 인증 정보를 생성하는 메서드입니다.
     * 액세스 토큰을 사용하여 사용자 유형과 ID를 추출하고, 해당 인증 정보를 생성하여 반환합니다.
     *
     * @param token JWT 액세스 토큰
     * @return 생성된 인증 객체
     */
    private Authentication getAuthentication(String token) {
        RelatedType userType = jwtUtility.getUserType(token);
        Integer userId = jwtUtility.getUserId(token);

        List<GrantedAuthority> authorities = List.of(new SimpleGrantedAuthority(userType.name()));

        return new UsernamePasswordAuthenticationToken(userId, null, authorities);
    }

    /**
     * 허용된 URL인지 확인하고, 예외적으로 인증이 필요한 경우 인증을 수행합니다.
     *
     * @param uri 요청된 URI
     * @return 허용된 URL이면 true, 인증이 필요하면 false
     */
    private boolean checkAllowedUrl(String uri) {
        boolean flagAllowed = Arrays.stream(ALLOWED_URLS).anyMatch(pattern -> pathMatcher.match(pattern, uri));
        boolean flagException = Arrays.stream(NOT_ALLOWED_URLS).anyMatch(pattern -> pathMatcher.match(pattern, uri));

        return flagAllowed && !flagException;
    }

}
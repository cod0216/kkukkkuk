package com.be.KKUKKKUK.global.filter;

import com.be.KKUKKKUK.domain.hospital.service.HospitalDetailService;
import com.be.KKUKKKUK.domain.owner.service.OwnerDetailService;
import com.be.KKUKKKUK.global.api.StatusEnum;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.util.JwtUtility;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;
import org.springframework.util.AntPathMatcher;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;
import java.util.Arrays;
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
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class JwtAuthenticationFilter extends OncePerRequestFilter {
    private static final AntPathMatcher pathMatcher = new AntPathMatcher();

    private final JwtUtility jwtUtility;
    private final HospitalDetailService hospitalDetailService;
    private final OwnerDetailService ownerDetailService;


    private static final String[] AllowUrls = new String[]{
            "/",
            "/error",
            "/api/auth/refresh",
            "/api/auth/owners/kakao/login",
            "/api/auth/hospitals/signup",
            "/api/auth/hospitals/login",
            "/api/hospitals/authorization-number/**",
            "/api/hospitals/account/**",
            "/api/hospitals/license/**",
    };


    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {

        String uri = request.getRequestURI();

        if (Arrays.stream(AllowUrls).anyMatch(pattern -> pathMatcher.match(pattern, uri))) {
            filterChain.doFilter(request, response);
            return;
        }

        String authHeader = request.getHeader("Authorization");
        if (Objects.isNull(authHeader) || !authHeader.startsWith("Bearer ")) {
//            throw new ApiException(ErrorCode.NO_ACCESS_TOKEN);
            writeErrorResponse(response, ErrorCode.NO_ACCESS_TOKEN);
            return;
        }

        String accessToken = authHeader.substring(7);
        if (jwtUtility.validateToken(accessToken)) {
            processValidAccessToken(accessToken);
        } else {
            SecurityContextHolder.clearContext(); // 인증 실패 시 보안 컨텍스트 초기화
//            throw new ApiException(ErrorCode.INVALID_TOKEN);
            writeErrorResponse(response, ErrorCode.INVALID_TOKEN);
            return;
        }

        filterChain.doFilter(request, response);
    }


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

    private void writeErrorResponse(HttpServletResponse response, ErrorCode errorCode) throws IOException {
        response.setStatus(errorCode.getHttpStatus().value());
        response.setContentType("application/json;charset=utf-8");
        response.getWriter().write(
                String.format("{\"status\": \"%s\",\"status_code\": \"%s\", \"name\": \"%s\", \"code\": \"%s\", \"message\": \"%s\"}",
                        StatusEnum.FAILURE,
                        errorCode.getHttpStatus().value(),
                        errorCode.name(),
                        errorCode.getCode(),
                        errorCode.getMessage())
        );
    }
}

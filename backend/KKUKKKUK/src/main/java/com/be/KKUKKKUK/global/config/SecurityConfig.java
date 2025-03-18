package com.be.KKUKKKUK.global.config;

import com.be.KKUKKKUK.domain.hospital.service.HospitalDetailService;
import com.be.KKUKKKUK.domain.owner.service.OwnerDetailService;
import com.be.KKUKKKUK.global.filter.JwtAuthenticationFilter;
import com.be.KKUKKKUK.global.util.JwtUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Configurable;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configuration.EnableWebSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.security.config.annotation.web.configurers.CsrfConfigurer;
import org.springframework.security.config.annotation.web.configurers.HttpBasicConfigurer;
import org.springframework.security.config.http.SessionCreationPolicy;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.security.web.SecurityFilterChain;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;
import org.springframework.web.cors.CorsConfiguration;
import org.springframework.web.cors.CorsConfigurationSource;
import org.springframework.web.cors.UrlBasedCorsConfigurationSource;

import java.util.Arrays;

/**
 * packageName    : com.be.KKUKKKUK.global.config<br>
 * fileName       : SecurityConfig.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Spring Security 설정을 담당하는 구성 클래스입니다.
 * <p>이 클래스는 JWT 기반 인증을 사용하여 보안을 구성하며, CORS 정책을 설정하고,
 * 특정 URL 경로에 대한 접근을 허용하는 등의 역할을 합니다.</p><br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 */
@Configurable
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final JwtUtility jwtUtility;
    private final HospitalDetailService hospitalDetailService;
    private final OwnerDetailService ownerDetailService;

    // 인증 없이 접근을 허용할 URL 경로 설정
    public static final String[] allowUrls = {
            "/",
            "/error",
            "/api/auths/refresh",
            "/api/auths/owners/kakao/login",
            "/api/auths/hospitals/signup",
            "/api/auths/hospitals/login",
            "/api/hospitals/authorization-number/**",
            "/api/hospitals/account/**",
            "/api/hospitals/name/**",

    };


    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }

    @Bean
    public JwtAuthenticationFilter jwtAuthenticationFilter() {
        return new JwtAuthenticationFilter(jwtUtility, hospitalDetailService, ownerDetailService);
    }

    @Bean
    protected SecurityFilterChain securityFilterChain(HttpSecurity http, CorsConfigurationSource corsConfigurationSource) throws Exception {
        http
                // 인증 없이 접근 가능한 URL 지정
                .authorizeHttpRequests(request -> request
                        .requestMatchers(allowUrls).permitAll() // allowUrls 배열에 포함된 URL은 모두 인증 없이 접근 가능
                        .anyRequest().authenticated() // 나머지 URL은 인증이 필요
                )
                // CSRF 보호 비활성화
                .csrf(CsrfConfigurer::disable)
                .cors(cors-> cors.configurationSource(corsConfigurationSource()))
                // 폼 로그인 및 기본 HTTP 인증 비활성화
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(HttpBasicConfigurer::disable)
                // 세션을 사용하지 않고, JWT 인증 방식 사용
                .sessionManagement(sessionManagement -> sessionManagement
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                // JWT 인증 필터를 Spring Security 필터 체인에 추가
                .addFilterBefore(jwtAuthenticationFilter(), UsernamePasswordAuthenticationFilter.class);

        return http.build();
    }

    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("http://localhost:3000", "http://localhost:5173", "http://localhost:3001")); // 허용할 도메인 지정
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("Authorization", "Content-Type"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }


}

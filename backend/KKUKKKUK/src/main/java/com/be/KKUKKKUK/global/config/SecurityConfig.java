package com.be.KKUKKKUK.global.config;

import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ExceptionHandlingFilter;
import com.be.KKUKKKUK.global.filter.JwtAuthenticationFilter;
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
 * 25.03.27          haelim           허용 url 추가(auth) <br>
 * 25.03.29          haelim           회원 유형에 따른 허용 URL 설정 <br>
 * 25.04.07          haelim           ExceptionHandlingFilter 추가 <br>
 */
@Configurable
@Configuration
@EnableWebSecurity
@RequiredArgsConstructor
public class SecurityConfig {
    private final JwtAuthenticationFilter jwtAuthenticationFilter;
    private final ExceptionHandlingFilter exceptionHandlingFilter;

    /**
     * 인증 없이 접근을 허용할 URL 경로를 설정합니다.
     */
    public static final String[] ALLOWED_URLS = {
            "/",
            "/error",
            "/v3/api-docs/**", "/swagger-ui/**", "/swagger-ui.html", "/swagger-resources/**",
            "/api/auths/**",
            "/api/hospitals/authorization-number/**", "/api/hospitals/account/**", "/api/hospitals/name/**",
            "/api/breeds/**",
            "/ws/*", "/kkukkkuk/**"

    };

    /**
     * ALLOWED_URLS 에 포함되지만 예외적으로 인증이 필요한 URL 경로를 설정합니다.
     */
    public static final String[] NOT_ALLOWED_URLS = {
            "/api/auths/logout", "/api/auths/logout/all",
    };

    /**
     * OWNER 만 접근 가능한 URL 경로를 설정합니다.
     */
    private static final String[] ROLE_OWNER_URLS = {
            "/api/owners/**", "/api/wallets/**"
    };

    /**
     * HOSPITAL 만 접근 가능한 URL 경로를 설정합니다.
     */
    private static final String[] ROLE_HOSPITAL_URLS = {
            "/api/hospitals/**", "/api/doctors/**", "/api/drugs/**", "/api/chats/**", "/api/diagnoses/**", "/api/vaccinations/**"
    };

    /**
     * OWNER, HOSPITAL 모두 접근 가능한 URL 경로를 설정합니다.
     */
    private static final String[] ROLE_ALL_URLS = {
            "/api/hospitals"
    };


    /**
     * 비밀번호 암호화 방식으로 BCryptPasswordEncoder를 사용하여 PasswordEncoder 빈을 설정합니다.
     * @return BCryptPasswordEncoder 객체
     */
    @Bean
    public PasswordEncoder passwordEncoder() {
        return new BCryptPasswordEncoder();
    }


    /**
     *
     * HTTP 보안 설정을 정의하는 메서드입니다.
     * 이 메서드는 URL에 대한 인증 규칙을 설정하고, JWT 인증 필터를 추가합니다.
     *
     * @param http HTTP 보안 설정 객체
     * @param corsConfigurationSource CORS 설정 객체
     * @return SecurityFilterChain 객체
     * @throws Exception 설정 중 발생할 수 있는 예외
     */
    @Bean
    protected SecurityFilterChain securityFilterChain(HttpSecurity http, CorsConfigurationSource corsConfigurationSource) throws Exception {
        http
                .csrf(CsrfConfigurer::disable)
                .cors(cors -> cors.configurationSource(corsConfigurationSource()))
                .formLogin(AbstractHttpConfigurer::disable)
                .httpBasic(HttpBasicConfigurer::disable)
                .sessionManagement(sessionManagement -> sessionManagement
                        .sessionCreationPolicy(SessionCreationPolicy.STATELESS)
                )
                .authorizeHttpRequests(auth -> auth
                        .requestMatchers(NOT_ALLOWED_URLS).authenticated() // 인증 필요

                        .requestMatchers(ALLOWED_URLS).permitAll() // 인증 없이 접근 가능

                        .requestMatchers(ROLE_ALL_URLS).hasAnyRole(RelatedType.OWNER.name(), RelatedType.HOSPITAL.name()) // OWNER와 HOSPITAL 모두 접근 가능
                        .requestMatchers(ROLE_OWNER_URLS).hasRole(RelatedType.OWNER.name()) // OWNER 접근 가능
                        .requestMatchers(ROLE_HOSPITAL_URLS).hasRole(RelatedType.HOSPITAL.name())// HOSPITAL 접근 가능
                        .anyRequest().authenticated()
                )
                .addFilterBefore(jwtAuthenticationFilter, UsernamePasswordAuthenticationFilter.class)
                .addFilterBefore(exceptionHandlingFilter, JwtAuthenticationFilter.class);
        ;


        return http.build();
    }

    /**
     * CORS(Cross-Origin Resource Sharing) 정책을 설정하여 특정 도메인에서 API 요청을 허용합니다.
     * @return CorsConfigurationSource 객체
     */
    @Bean
    public CorsConfigurationSource corsConfigurationSource() {
        CorsConfiguration configuration = new CorsConfiguration();
        configuration.setAllowedOrigins(Arrays.asList("http://localhost:3000", "http://localhost:8080", "http://localhost:5174", "https://kukkkukk.duckdns.org")); // 허용할 도메인 지정
        configuration.setAllowedMethods(Arrays.asList("GET", "POST", "PUT", "PATCH", "DELETE", "OPTIONS"));
        configuration.setAllowedHeaders(Arrays.asList("Authorization", "Content-Type"));
        configuration.setAllowCredentials(true);

        UrlBasedCorsConfigurationSource source = new UrlBasedCorsConfigurationSource();
        source.registerCorsConfiguration("/**", configuration);
        return source;
    }


}

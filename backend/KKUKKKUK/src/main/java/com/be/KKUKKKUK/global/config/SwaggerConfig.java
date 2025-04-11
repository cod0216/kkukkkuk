package com.be.KKUKKKUK.global.config;

import io.swagger.v3.oas.annotations.OpenAPIDefinition;
import io.swagger.v3.oas.annotations.info.Info;
import io.swagger.v3.oas.annotations.servers.Server;
import io.swagger.v3.oas.models.Components;
import io.swagger.v3.oas.models.OpenAPI;
import io.swagger.v3.oas.models.security.SecurityRequirement;
import io.swagger.v3.oas.models.security.SecurityScheme;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
@OpenAPIDefinition(
        info = @Info(
                title = "KKUK KKUK API",
                description = "꾹꾹 API 서버입니다."
        ),
        servers = {
                @Server(url = "https://kukkkukk.duckdns.org", description = "KKUK KKUK"),
                @Server(url = "http://localhost:8080", description = "KKUK KKUK TEST"),
        }
)
public class SwaggerConfig {

    @Bean
    public OpenAPI openAPI() {
        return new OpenAPI()
                .components(new Components()
                        .addSecuritySchemes("Bearer Auth", apiKey())
                )
                .addSecurityItem(new SecurityRequirement().addList("Bearer Auth"));
    }

    private SecurityScheme apiKey() {
        return new SecurityScheme()
                .type(SecurityScheme.Type.APIKEY) // API Key 방식 사용
                .in(SecurityScheme.In.HEADER) // Header에 전달
                .name("Authorization") // 'Authorization' 헤더에 토큰을 담아 전달
                .scheme("bearer")
                .bearerFormat("JWT"); // JWT 형식 명시
    }
}
package com.be.KKUKKKUK.global.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.web.client.RestTemplate;
/**
 * packageName    : com.be.KKUKKKUK.global.config<br>
 * fileName       : SecurityConfig.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-02<br>
 * description    : RestTemplate 관련 설정을 위한 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          eunchang           최초생성<br>
 */


@Configuration
public class RestTemplateConfig {

    /**
     * RestTemplate를 통해 외부 서버와 HTTP 통신을 수행합니다.
     *
     * @return RestTemplate 인스턴스
     */
    @Bean
    public RestTemplate restTemplate() {
        return new RestTemplate();
    }
}

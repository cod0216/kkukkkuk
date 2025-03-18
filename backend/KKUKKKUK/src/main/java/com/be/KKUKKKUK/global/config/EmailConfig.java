package com.be.KKUKKKUK.global.config;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.JavaMailSenderImpl;

import java.util.Properties;

/**
 * packageName    : com.be.KKUKKKUK.global.config<br>
 * fileName       : EmailConfig.java<br>
 * author         : haelim<br>
 * date           : 2025-03-18<br>
 * description    : 이메일 관련 설정을 위한 클래스입니다. <br>
 *                  이메일 전송을 위한 JavaMailSender 를 설정하고 반환하는 Bean을 제공합니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.18          haelim           최초생성<br>
 */
@Configuration
public class EmailConfig {

    @Value("${spring.mail.host}")
    private String host; // 이메일 서버 호스트 주소

    @Value("${spring.mail.port}")
    private int port; // 이메일 서버 포트 번호

    @Value("${spring.mail.username}")
    private String username; // 이메일 서버 사용자 이름

    @Value("${spring.mail.password}")
    private String password; // 이메일 서버 비밀번호

    @Value("${spring.mail.properties.mail.smtp.auth}")
    private boolean auth; // SMTP 인증 여부

    @Value("${spring.mail.properties.mail.smtp.starttls.enable}")
    private boolean starttlsEnable; // STARTTLS 암호화 사용 여부

    @Value("${spring.mail.properties.mail.smtp.starttls.required}")
    private boolean starttlsRequired; // STARTTLS 암호화 필수 여부

    @Value("${spring.mail.properties.mail.smtp.connectiontimeout}")
    private int connectionTimeout; // SMTP 연결 타임아웃 시간 (밀리초)

    @Value("${spring.mail.properties.mail.smtp.timeout}")
    private int timeout; // SMTP 전송 타임아웃 시간 (밀리초)

    @Value("${spring.mail.properties.mail.smtp.writetimeout}")
    private int writeTimeout; // SMTP 전송 대기 시간 (밀리초)

    /**
     * 이메일 전송을 위한 JavaMailSender Bean을 설정합니다.
     * @return 설정된 JavaMailSender 객체
     */
    @Bean
    public JavaMailSender javaMailSender() {
        JavaMailSenderImpl mailSender = new JavaMailSenderImpl();
        mailSender.setHost(host);
        mailSender.setPort(port);
        mailSender.setUsername(username);
        mailSender.setPassword(password);
        mailSender.setDefaultEncoding("UTF-8");
        mailSender.setJavaMailProperties(getMailProperties());

        return mailSender;
    }

    /**
     * 이메일 전송에 필요한 SMTP 관련 속성을 Properties 객체로 반환합니다.
     * SMTP 인증, STARTTLS 설정 등 이메일 서버와의 연결 및 통신에 필요한 속성들을 설정합니다.
     * @return 설정된 SMTP 속성을 포함한 Properties 객체
     */
    private Properties getMailProperties() {
        Properties properties = new Properties();
        properties.put("mail.smtp.auth", auth); // SMTP 인증 여부
        properties.put("mail.smtp.starttls.enable", starttlsEnable); // STARTTLS 암호화 사용 여부
        properties.put("mail.smtp.starttls.required", starttlsRequired); // STARTTLS 필수 여부
        properties.put("mail.smtp.connectiontimeout", connectionTimeout); // 연결 타임아웃
        properties.put("mail.smtp.timeout", timeout); // 전송 타임아웃
        properties.put("mail.smtp.writetimeout", writeTimeout); // 전송 대기 시간

        return properties;
    }
}

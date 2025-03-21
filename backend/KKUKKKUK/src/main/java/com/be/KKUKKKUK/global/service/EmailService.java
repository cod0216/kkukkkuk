package com.be.KKUKKKUK.global.service;

import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import jakarta.mail.MessagingException;
import jakarta.mail.internet.MimeMessage;
import lombok.RequiredArgsConstructor;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * packageName    : com.be.KKUKKKUK.global.service<br>
 * fileName       : EmailService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-18<br>
 * description    : Email에 대한 Service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.18          haelim           최초 생성<br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class EmailService {
    // 이메일 전송을 위한 JavaMailSender 의존성 주입
    private final JavaMailSender emailSender;

    // 서비스 이름 정의
    private final String SERVICE_NAME = "KKUKKKUK";

    // 비밀번호 재설정 이메일 관련 제목, 내용 설정
    private final String PASSWORD_RESET_SUBJECT = String.format("[%s] 비밀번호 초기화 안내", SERVICE_NAME);
    private final String PASSWORD_RESET_TITLE = "비밀번호 초기화 안내";
    private final String PASSWORD_RESET_MESSAGE = "비밀번호가 초기화되었습니다.";
    private final String PASSWORD_RESET_FOOTER = "로그인 후 비밀번호를 재설정해주세요.";

    // 이메일 인증 관련 제목, 내용 설정
    private final String EMAIL_VERIFICATION_SUBJECT = String.format("[%s] 이메일 인증 안내", SERVICE_NAME);
    private final String EMAIL_VERIFICATION_TITLE = "이메일 인증 요청";
    private final String EMAIL_VERIFICATION_MESSAGE = "아래의 인증번호를 입력하여 이메일 인증을 완료해 주세요.";
    private final String EMAIL_VERIFICATION_FOOTER = "인증번호는 5분 후에 만료됩니다.";

    // 이메일 디자인에 사용할 기본 색상
    private static final String PRIMARY_COLOR = "#4CAF50";

    /**
     * 비밀번호 재설정 이메일을 전송합니다.
     *
     * @param toEmail 수신자 이메일
     * @param newPassword 새 비밀번호
     */
    public void sendPasswordResetEmail(String toEmail, String newPassword) {
        // 1. 비밀번호 재설정 이메일의 제목과 본문을 설정
        String content = buildHtmlContent(
                PASSWORD_RESET_TITLE,
                PASSWORD_RESET_MESSAGE,
                newPassword,
                PASSWORD_RESET_FOOTER);
        // 2. 이메일 전송
        sendEmail(toEmail, PASSWORD_RESET_SUBJECT, content);
    }

    /**
     * 인증번호를 이메일로 전송합니다.
     *
     * @param toEmail 수신자 이메일
     * @param authCode 새 비밀번호
     */
    public void sendVerificationEmail(String toEmail, String authCode) {
        // 1. 비밀번호 재설정 이메일의 제목과 본문을 설정
        String content = buildHtmlContent(
                EMAIL_VERIFICATION_TITLE,
                EMAIL_VERIFICATION_MESSAGE,
                authCode,
                EMAIL_VERIFICATION_FOOTER);
        // 2. 이메일 전송
        sendEmail(toEmail, EMAIL_VERIFICATION_SUBJECT, content);
    }

    /**
     * 이메일을 전송합니다.
     *
     * @param toEmail 전송 대상 이메일 주소
     * @param subject 이메일 제목
     * @param content 이메일 본문 (HTML)
     * @throws ApiException 이메일 전송에 실패할 경우 예외 발생
     */
    private void sendEmail(String toEmail, String subject, String content) {
        try {
            MimeMessage emailForm = createEmailForm(toEmail, subject, content);
            emailSender.send(emailForm); // 이메일 전송
        } catch (MessagingException e) {
            throw new ApiException(ErrorCode.UNABLE_TO_SEND_EMAIL);
        }
    }

    /**
     * 이메일 메시지를 생성합니다.
     *
     * @param toEmail 수신자 이메일 주소
     * @param subject 이메일 제목
     * @param content 이메일 본문 (HTML)
     * @return 생성된 {@link MimeMessage} 객체
     * @throws MessagingException 이메일 생성 중 오류 발생 시 예외 발생
     */
    private MimeMessage createEmailForm(String toEmail, String subject, String content) throws MessagingException {
        MimeMessage message = emailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");

        helper.setTo(toEmail); // 수신자 설정
        helper.setSubject(subject); // 이메일 제목 설정
        helper.setText(content, true); // 이메일 본문 내용 설정 (HTML 형식)

        return message;
    }

    /**
     * 공통 HTML 템플릿을 생성합니다.
     *
     * @param title 이메일 제목
     * @param message 본문 메시지
     * @param highlight 강조할 텍스트 (예: 인증코드, 비밀번호)
     * @param footer 푸터 메시지
     * @return HTML 형식의 이메일 내용
     */
    private static String buildHtmlContent(String title, String message, String highlight, String footer) {
        return String.format(
                "<div style=\"width: 100%%; max-width: 600px; margin: auto; font-family: Arial, sans-serif; text-align: center; border: 1px solid #ddd; border-radius: 10px; padding: 20px;\">" +
                        "<h2 style=\"color: %s;\">%s</h2>" +
                        "<p style=\"font-size: 16px;\">%s</p>" +
                        "<div style=\"font-size: 24px; font-weight: bold; color: #333; background: #f4f4f4; padding: 10px; border-radius: 5px; display: inline-block;\">" +
                        "%s" +
                        "</div>" +
                        "<p style=\"color: #888; font-size: 12px;\">%s</p>" +
                        "</div>",
                PRIMARY_COLOR, title, message, highlight, footer
        );
    }

}

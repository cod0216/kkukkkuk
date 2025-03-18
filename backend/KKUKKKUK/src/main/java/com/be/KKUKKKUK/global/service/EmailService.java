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
 * description    : Email 에 대한 Service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.18          haelim           최초 생성<br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class EmailService {
    private final JavaMailSender emailSender;

    /**
     * 대상에게 이메일을 전송합니다.
     * @param toEmail 전송할 대상의 메일 주소
     * @param title 이메일 제목
     * @param message 이메일 내용
     * @throws ApiException 이메일 전송에 실패할 경우 예외처리
     */
    public void sendEmail(String toEmail, String title, String message) {
        try {
            MimeMessage emailForm = createEmailForm(toEmail, title, message);
            emailSender.send(emailForm);
        } catch (MessagingException e) {
            throw new ApiException(ErrorCode.UNABLE_TO_SEND_EMAIL);
        }
    }

    /**
     * 발신할 이메일 데이터를 세팅합니다.
     * @param toEmail 전송할 대상의 메일 주소
     * @param title 이메일 제목
     * @param code 이메일 본문에 포함될 인증 코드
     * @return 생성된 {@link MimeMessage} 객체를 반환
     * @throws MessagingException 이메일 생성 중 오류가 발생할 경우 예외처리
     */
    private MimeMessage createEmailForm(String toEmail, String title, String code) throws MessagingException {
        MimeMessage message = emailSender.createMimeMessage();
        MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");

        helper.setTo(toEmail);
        helper.setSubject(title);
        helper.setText(buildHtmlContent(code), true); // HTML 템플릿 적용

        return message;
    }

    /**
     * 이메일 본문에 사용할 HTML 템플릿을 생성합니다.
     *
     * @param code 사용자에게 전송할 인증 코드
     * @return HTML 형식의 이메일 본문을 문자열로 반환
     */
    private String buildHtmlContent(String code) {
        return String.format(
                "<div style=\"width: 100%%; max-width: 600px; margin: auto; font-family: Arial, sans-serif; text-align: center; border: 1px solid #ddd; border-radius: 10px; padding: 20px;\">" +
                        "<h2 style=\"color: #4CAF50;\">KKUKKKUK 이메일 인증</h2>" +
                        "<p style=\"font-size: 16px;\">아래의 인증번호를 입력해 주세요.</p>" +
                        "<div style=\"font-size: 24px; font-weight: bold; color: #333; background: #f4f4f4; padding: 10px; border-radius: 5px; display: inline-block;\">" +
                        "%s" +
                        "</div>" +
                        "<p style=\"color: #888; font-size: 12px;\">인증번호는 5분 후 만료됩니다.</p>" +
                        "</div>",
                code
        );
    }

}

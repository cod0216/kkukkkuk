package com.be.KKUKKKUK.domain.auth.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.request<br>
 * fileName       : EmailVerificationRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-18<br>
 * description    : 이메일 인증 요청을 위한 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.18          haelim           최초 생성<br>
 */
@Getter
@ToString
public class EmailVerificationRequest {
    @Email
    @NotBlank(message = "이메일은 필수로 입력해주세요")
    private String email;

    @NotBlank(message = "필수로 입력해주세요")
    private String code;
}

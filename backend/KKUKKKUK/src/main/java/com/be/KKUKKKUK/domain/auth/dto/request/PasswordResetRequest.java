package com.be.KKUKKKUK.domain.auth.dto.request;

import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.request<br>
 * fileName       : PasswordResetRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-18<br>
 * description    : 비밀번호 재발급 요청을 위한 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.18          haelim           최초 생성<br>
 */
@Getter
@ToString
public class PasswordResetRequest {
    @NotBlank(message = "계정은 필수로 입력해주세요")
    private String account;

    @Email
    @NotBlank(message = "이메일은 필수로 입력해주세요")
    private String email;
}

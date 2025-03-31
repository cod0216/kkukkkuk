package com.be.KKUKKKUK.domain.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
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
 * 25.03.24          haelim           swagger 작성<br>
 */
@Getter
@ToString
public class EmailVerificationRequest {
    @Email
    @NotBlank
    @Schema(description = "이메일 주소", example = "test@example.com")
    private String email;

    @NotBlank
    @Schema(description = "인증 코드", example = "iu9MWx&nan!D305AzPzY")
    private String code;
}

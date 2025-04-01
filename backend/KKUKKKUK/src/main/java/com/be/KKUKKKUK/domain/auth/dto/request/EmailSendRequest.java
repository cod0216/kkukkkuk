package com.be.KKUKKKUK.domain.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.request<br>
 * fileName       : EmailSendRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-18<br>
 * description    : 인증을 위한 이메일 전송 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.18          haelim           최초 생성<br>
 * 25.03.22          haelim           swagger 작성<br>
 */
@Getter
@ToString
public class EmailSendRequest {
    @Email
    @NotBlank(message = "이메일은 필수로 입력해주세요")
    @Schema(description = "이메일 주소", example = "test@example.com")
    private String email;
}

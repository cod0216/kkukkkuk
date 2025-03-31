package com.be.KKUKKKUK.domain.auth.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.request<br>
 * fileName       : AccountFoundRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-27<br>
 * description    : account 찾기를 위한 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.27          haelim           최초 생성<br>
 */
@Getter
public class AccountFindRequest {
    @Email
    @NotBlank(message = "이메일은 필수로 입력해주세요")
    @Schema(description = "이메일 주소", example = "test@example.com")
    private String email;
}

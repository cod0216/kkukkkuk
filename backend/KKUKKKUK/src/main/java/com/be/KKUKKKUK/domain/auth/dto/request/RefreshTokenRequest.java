package com.be.KKUKKKUK.domain.auth.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.controller<br>
 * fileName       : RefreshTokenRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 액세스 토큰 재발급을 위한 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */

@NoArgsConstructor
@AllArgsConstructor
@Getter
@ToString
public class RefreshTokenRequest {
    @NotBlank(message = "refresh_token 는 필수 입력 필드입니다.")
    @JsonProperty("refresh_token")
    private String refreshToken;
}

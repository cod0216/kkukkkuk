package com.be.KKUKKKUK.domain.auth.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;


/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.response<br>
 * fileName       : RefreshTokenResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 액세스 토큰 재발급을 위한 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
public class RefreshTokenResponse {
    @JsonProperty("access_token")
    private String accessToken;

    @JsonProperty("refresh_token")
    private String refreshToken;
}

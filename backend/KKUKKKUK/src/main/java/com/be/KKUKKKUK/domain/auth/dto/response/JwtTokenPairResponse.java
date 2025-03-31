package com.be.KKUKKKUK.domain.auth.dto.response;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AllArgsConstructor;
import lombok.Data;


/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto<br>
 * fileName       : JwtTokenPair.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : JWT 이중 토큰 관련 요청을 처리하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class JwtTokenPairResponse {
    private String accessToken;
    private String refreshToken;
}

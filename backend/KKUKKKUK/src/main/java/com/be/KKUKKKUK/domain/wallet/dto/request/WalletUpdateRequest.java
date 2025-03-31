package com.be.KKUKKKUK.domain.wallet.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.ToString;

/**
 * packageName    :  com.be.KKUKKKUK.domain.wallet.dto.request<br>
 * fileName       :  WalletUpdateRequest.java<br>
 * author         :  haelim<br>
 * date           :  2025-03-17<br>
 * description    :  Wallet 수정 요청을 처리하는 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.17          haelim           최초생성<br>
 * 25.03.24          haelim           swagger 설정<br>
 * 25.03.29          haelim           NotBlank 삭제, address 수정 못하게 변경, name 추가<br>
 */
@Getter
@ToString
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class WalletUpdateRequest {//TODO 각 String 변수들의 길이는 무제한 인가요?, 여기는 null, 빈칸와도 상관이 없는 데이터인가요?
    @Schema(description = "지갑의 암호화된 개인키", example = "exampleprivatekey")
    private String privateKey;

    @Schema(description = "지갑의 공개키", example = "examplepublickey")
    private String publicKey;

    @Schema(description = "지갑 주소", example = "examplewalletdid")
    private String did;

    @Schema(description = "지갑 이름", example = "임보용 지갑")
    private String name;
}

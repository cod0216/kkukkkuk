package com.be.KKUKKKUK.domain.wallet.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
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
public class WalletUpdateRequest {
    @Schema(description = "지갑의 암호화된 개인키", example = "exampleprivatekey")
    private String privateKey;

    @Schema(description = "지갑의 공개키", example = "examplepublickey")
    private String publicKey;

    @Schema(description = "지갑 주소", example = "examplewalletdid")
    private String did;

    @Schema(description = "지갑 이름", example = "임보용 지갑")
    private String name;
}

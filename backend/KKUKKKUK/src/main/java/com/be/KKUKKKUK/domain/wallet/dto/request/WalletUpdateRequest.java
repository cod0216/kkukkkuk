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
 * 25.03.24          haelim           swagger, JsonNaming 설정<br>
 */
@Getter
@ToString
public class WalletUpdateRequest {
    @Schema(description = "지갑의 암호화된 개인키", example = "exampleprivatekey")
    @NotBlank
    private String privateKey;

    @Schema(description = "지갑의 공개키", example = "examplepublickey")
    @NotBlank
    private String publicKey;

    @Schema(description = "지갑 주소", example = "examplewalletaddress")
    @NotBlank
    private String address;

    @Schema(description = "지갑 주소", example = "examplewalletdid")
    @NotBlank
    private String did;
}

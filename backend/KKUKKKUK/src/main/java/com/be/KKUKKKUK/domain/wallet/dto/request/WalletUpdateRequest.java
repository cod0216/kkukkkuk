package com.be.KKUKKKUK.domain.wallet.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
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
 */
@Getter
@ToString
public class WalletUpdateRequest {
    @NotBlank
    @JsonProperty("private_key")
    private String privateKey;

    @NotBlank
    @JsonProperty("public_key")
    private String publicKey;

    @NotBlank
    private String address;

    @NotBlank
    private String did;
}

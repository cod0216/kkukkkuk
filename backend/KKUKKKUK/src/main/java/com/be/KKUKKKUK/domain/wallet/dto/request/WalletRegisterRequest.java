package com.be.KKUKKKUK.domain.wallet.dto.request;

import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.ToString;
import java.time.LocalDateTime;

/**
 * packageName    :  com.be.KKUKKKUK.domain.wallet.dto.request<br>
 * fileName       :  WalletRegisterRequest.java<br>
 * author         :  haelim<br>
 * date           :  2025-03-17<br>
 * description    :  Wallet 등록 요청을 처리하는 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.17          haelim           최초생성<br>
 */
@Getter
@ToString
public class WalletRegisterRequest {
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

    public Wallet toWalletEntity() {
        return Wallet.builder()
                .privateKey(privateKey)
                .publicKey(publicKey)
                .address(address)
                .did(did)
                .createdAt(LocalDateTime.now())
                .build();
    }
}

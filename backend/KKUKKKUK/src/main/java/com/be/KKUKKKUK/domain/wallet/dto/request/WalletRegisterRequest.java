package com.be.KKUKKKUK.domain.wallet.dto.request;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.Data;
import lombok.Getter;
import lombok.ToString;

import java.time.LocalDate;
import java.time.LocalDateTime;

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

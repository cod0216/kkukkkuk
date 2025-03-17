package com.be.KKUKKKUK.domain.wallet.dto.request;

import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.ToString;

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

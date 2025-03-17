package com.be.KKUKKKUK.domain.wallet.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class WalletRecoverResponse {
    @JsonProperty("private_key")
    String privateKey;
}

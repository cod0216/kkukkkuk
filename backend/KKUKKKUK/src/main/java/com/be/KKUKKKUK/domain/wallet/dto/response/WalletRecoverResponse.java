package com.be.KKUKKKUK.domain.wallet.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.dto<br>
 * fileName       : WalletInfo.java<br>
 * author         : haelim<br>
 * date           : 2025-03-17<br>
 * description    : Wallet 사용자의 지갑 복구를 위한 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.17          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
public class WalletRecoverResponse {
    @JsonProperty("private_key")
    String privateKey;
}

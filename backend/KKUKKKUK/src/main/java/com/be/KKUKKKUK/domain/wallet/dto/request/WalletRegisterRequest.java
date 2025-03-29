package com.be.KKUKKKUK.domain.wallet.dto.request;

import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
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
 * 25.03.24          haelim           swagger, JsonNaming 설정<br>
 */
@Getter
@ToString
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class WalletRegisterRequest {
    @Schema(description = "지갑의 암호화된 개인키", example = "exampleprivatekey")
    @NotBlank
    private String privateKey;

    @NotBlank
    @Schema(description = "지갑의 공개키", example = "examplepublickey")
    private String publicKey;

    @NotBlank
    @Schema(description = "지갑 주소", example = "examplewalletaddress")
    private String address;

    @NotBlank
    @Schema(description = "지갑 주소", example = "examplewalletdid")
    private String did;

    @NotBlank
    @Schema(description = "지갑 이름", example = "임보용 지갑")
    private String name;

    public Wallet toWalletEntity() {
        return Wallet.builder()
                .name(name)
                .privateKey(privateKey)
                .publicKey(publicKey)
                .address(address)
                .did(did)
                .createdAt(LocalDateTime.now())
                .build();
    }
}

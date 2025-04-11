package com.be.KKUKKKUK.domain.wallet.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Size;
import lombok.Getter;

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
 * 25.04.01          haelim           did 삭제<br>
 */

@Getter
public class WalletUpdateRequest {
    @Size(max = 30)
    @Schema(description = "지갑 이름", example = "임보용 지갑")
    private String name;
}

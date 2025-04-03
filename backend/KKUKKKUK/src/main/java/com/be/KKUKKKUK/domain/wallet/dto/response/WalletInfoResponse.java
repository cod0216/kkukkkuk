package com.be.KKUKKKUK.domain.wallet.dto.response;

import com.be.KKUKKKUK.domain.owner.dto.response.OwnerShortInfoResponse;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.dto<br>
 * fileName       : WalletInfo.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Wallet 엔터티의 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.29          haelim           name 추가<br>
 */
@Data
@AllArgsConstructor
public class WalletInfoResponse {
    private Integer id;
    private String address;
    private String name;
    private List<OwnerShortInfoResponse> owners;
}

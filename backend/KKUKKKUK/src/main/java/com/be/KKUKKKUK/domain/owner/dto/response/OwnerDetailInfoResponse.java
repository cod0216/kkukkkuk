package com.be.KKUKKKUK.domain.owner.dto.response;

import com.be.KKUKKKUK.domain.wallet.dto.response.WalletShortInfoResponse;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.dto<br>
 * fileName       : OwnerDetailInfoResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-17<br>
 * description    : Owner 엔터티의 상세 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.17          haelim           최초 생성<br>
 * 25.03.28          haelim           지갑 여러 개 조회하도록 수정 <br>
 */
@Data
@AllArgsConstructor
public class OwnerDetailInfoResponse {
    private OwnerInfoResponse owner;
    private List<WalletShortInfoResponse> wallets;
}

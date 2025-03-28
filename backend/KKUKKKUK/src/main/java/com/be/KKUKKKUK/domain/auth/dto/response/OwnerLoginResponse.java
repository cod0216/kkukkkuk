package com.be.KKUKKKUK.domain.auth.dto.response;

import com.be.KKUKKKUK.domain.owner.dto.response.OwnerInfoResponse;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.response<br>
 * fileName       : OwnerLoginResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 보호자 로그인 / 회원가입을 위한 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.28          haelim           지갑 여러 개 조회하도록 수정 <br>
 */
@Data
@AllArgsConstructor
public class OwnerLoginResponse {
    private OwnerInfoResponse owner;
    private JwtTokenPairResponse tokens;
    private List<WalletInfoResponse> wallets;
}

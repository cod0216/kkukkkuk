package com.be.KKUKKKUK.domain.auth.dto.response;

import com.be.KKUKKKUK.domain.auth.dto.JwtTokenPair;
import com.be.KKUKKKUK.domain.owner.dto.OwnerInfo;
import com.be.KKUKKKUK.domain.wallet.dto.WalletInfo;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.util.Optional;

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
 */
@AllArgsConstructor
@Data
public class OwnerLoginResponse {
    private OwnerInfo owner;
    private JwtTokenPair tokens;
    private WalletInfo wallet;
}

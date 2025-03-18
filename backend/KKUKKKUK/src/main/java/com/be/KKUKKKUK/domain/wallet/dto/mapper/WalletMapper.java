package com.be.KKUKKKUK.domain.wallet.dto.mapper;

import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import org.mapstruct.Mapper;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.dto.mapper<br>
 * fileName       : WalletMapper.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    :  Wallet entity 의 Map struct 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 */
@Mapper(componentModel = "spring")
public interface WalletMapper {
    WalletInfoResponse mapWalletToWalletInfo(Wallet wallet);
}

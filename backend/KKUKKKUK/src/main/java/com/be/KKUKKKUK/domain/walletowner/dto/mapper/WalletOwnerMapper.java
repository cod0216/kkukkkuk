package com.be.KKUKKKUK.domain.walletowner.dto.mapper;

import com.be.KKUKKKUK.domain.wallet.dto.response.WalletShortInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.walletowner.dto.mapper<br>
 * fileName       : WalletOwnerMapper.java<br>
 * author         : haelim<br>
 * date           : 2025-03-28<br>
 * description    : WalletOwner entity 의 Map struct 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.28          haelim           최초생성<br>
 */
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface WalletOwnerMapper {
    List<WalletShortInfoResponse> mapToWalletInfos(List<Wallet> wallets);

}

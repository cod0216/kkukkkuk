package com.be.KKUKKKUK.domain.walletowner.dto.mapper;

import com.be.KKUKKKUK.domain.wallet.dto.response.WalletShortInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface WalletOwnerMapper {
    List<WalletShortInfoResponse> mapToWalletInfos(List<Wallet> wallets);

}

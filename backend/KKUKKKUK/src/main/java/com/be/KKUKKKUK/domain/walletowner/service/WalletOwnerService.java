package com.be.KKUKKKUK.domain.walletowner.service;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.walletowner.entity.WalletOwner;
import com.be.KKUKKKUK.domain.walletowner.repository.WalletOwnerRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class WalletOwnerService {
    private final WalletOwnerRepository walletOwnerRepository;



    public WalletOwner connectWalletAndOwner(Owner owner, Wallet wallet) {
        WalletOwner walletOwner = new WalletOwner(owner, wallet);
        return walletOwnerRepository.save(walletOwner);
    }

    public void disConnectWalletAndOwner(Integer ownerId, Integer walletId) {
        WalletOwner walletOwner = checkConnection(ownerId, walletId);
        walletOwnerRepository.delete(walletOwner);
    }

    public WalletOwner checkConnection(Integer ownerId, Integer walletId) {
        return findByOwnerIdAndWalletIdOptional(ownerId, walletId)
                .orElseThrow(() -> new ApiException(ErrorCode.WALLET_NOT_ALLOWED));
    }

    private Optional<WalletOwner> findByOwnerIdAndWalletIdOptional(Integer ownerId, Integer walletId) {
        return walletOwnerRepository.findByOwnerIdAndWalletId(ownerId, walletId);
    }

    public List<WalletOwner> getWalletsByOwnerId(Integer ownerId) {
        return walletOwnerRepository.findByOwnerId(ownerId);
    }
}

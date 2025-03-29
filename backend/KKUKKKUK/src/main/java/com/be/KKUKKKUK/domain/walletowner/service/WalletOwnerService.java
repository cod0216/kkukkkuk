package com.be.KKUKKKUK.domain.walletowner.service;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletShortInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.walletowner.dto.mapper.WalletOwnerMapper;
import com.be.KKUKKKUK.domain.walletowner.entity.WalletOwner;
import com.be.KKUKKKUK.domain.walletowner.repository.WalletOwnerRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Service
@Transactional
@RequiredArgsConstructor
public class WalletOwnerService {
    private final WalletOwnerRepository walletOwnerRepository;
    private final WalletOwnerMapper walletOwnerMapper;


    public WalletOwner connectWalletAndOwner(Owner owner, Wallet wallet) {
        if(findByOwnerIdAndWalletIdOptional(owner.getId(), wallet.getId()).isPresent()) {
            // TODO :
            throw new ApiException(ErrorCode.WALLET_ALREADY_EXIST);
        }
        WalletOwner walletOwner = new WalletOwner(owner, wallet, LocalDateTime.now());
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

    public List<Wallet> getWalletsByOwnerId(Integer ownerId) {
        return walletOwnerRepository.findByOwnerId(ownerId)
                .stream()
                .map(WalletOwner::getWallet)
                .collect(Collectors.toList());
    }

    public List<Owner> getOwnersByWalletId(Integer walletId) {
        return walletOwnerRepository.findByWalletId(walletId)
                .stream()
                .map(WalletOwner::getOwner)
                .collect(Collectors.toList());
    }

    public List<WalletShortInfoResponse> getWalletShortInfoByOwnerId(Integer ownerId) {
        return  walletOwnerMapper.mapToWalletInfos(getWalletsByOwnerId(ownerId));
    }
}

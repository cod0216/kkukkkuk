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
import java.util.stream.Collectors;

/**
 * packageName    : com.be.KKUKKKUK.domain.walletowner.service<br>
 * fileName       : WalletOwnerService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-29<br>
 * description    : Owner, Wallet 을 연결하는 WalletOwner entity에 대한 service 클래스입니다.<br>
 *                  지갑 소유자 관계를 관리하고, 관련 정보를 조회할 수 있는 기능을 제공합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.29          haelim           최초 생성<br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class WalletOwnerService {
    private final WalletOwnerRepository walletOwnerRepository;
    private final WalletOwnerMapper walletOwnerMapper;

    /**
     * 특정 보호자와 지갑을 연결합니다.
     *
     * @param owner  보호자
     * @param wallet 지갑
     * @throws ApiException 이미 연결된 지갑인 경우 예외 발생
     */
    public void connectWalletAndOwner(Owner owner, Wallet wallet) {
        if (checkWalletConnected(owner.getId(), wallet.getId())) {
            throw new ApiException(ErrorCode.WALLET_ALREADY_EXIST);
        }
        walletOwnerRepository.save(new WalletOwner(owner, wallet, LocalDateTime.now()));
    }

    /**
     * 특정 보호자와 지갑 간의 연결을 해제합니다.
     *
     * @param ownerId  보호자 ID
     * @param walletId 지갑 ID
     */
    public void disconnectWalletAndOwner(Integer ownerId, Integer walletId) {
        WalletOwner walletOwner = findWalletOwner(ownerId, walletId);
        walletOwnerRepository.delete(walletOwner);
    }

    /**
     * 특정 보호자와 지갑이 연결되어 있는지 확인합니다.
     *
     * @param ownerId  보호자 ID
     * @param walletId 지갑 ID
     * @return 연결된 WalletOwner 엔티티 객체
     * @throws ApiException 연결이 존재하지 않을 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public WalletOwner findWalletOwner(Integer ownerId, Integer walletId) {
        return walletOwnerRepository.findByOwnerIdAndWalletId(ownerId, walletId)
                .orElseThrow(() -> new ApiException(ErrorCode.WALLET_NOT_ALLOWED));
    }

    /**
     * 특정 보호자의 지갑 목록을 반환합니다.
     *
     * @param ownerId 보호자 ID
     * @return 해당 보호자의 지갑 목록
     */
    @Transactional(readOnly = true)
    public List<Wallet> getWalletsByOwnerId(Integer ownerId) {
        return walletOwnerRepository.findByOwnerId(ownerId)
                .stream()
                .map(WalletOwner::getWallet)
                .collect(Collectors.toList());
    }

    /**
     * 특정 지갑에 연결된 보호자 목록을 반환합니다.
     *
     * @param walletId 지갑 ID
     * @return 해당 지갑의 보호자 목록
     */
    @Transactional(readOnly = true)
    public List<Owner> getOwnersByWalletId(Integer walletId) {
        return walletOwnerRepository.findByWalletId(walletId)
                .stream()
                .map(WalletOwner::getOwner)
                .collect(Collectors.toList());
    }

    /**
     * 특정 보호자의 지갑 목록을 요약 정보로 변환하여 반환합니다.
     *
     * @param ownerId 보호자 ID
     * @return 지갑 요약 정보 목록
     */
    public List<WalletShortInfoResponse> getWalletShortInfoByOwnerId(Integer ownerId) {
        return walletOwnerMapper.mapToWalletInfos(getWalletsByOwnerId(ownerId));
    }

    /**
     * 특정 보호자의 지갑이 연결되어 있는지 확인합니다.
     *
     * @param ownerId  보호자 ID
     * @param walletId 지갑 ID
     * @return 연결 여부 (true: 연결됨, false: 연결되지 않음)
     */
    private boolean checkWalletConnected(Integer ownerId, Integer walletId) {
        return walletOwnerRepository.findByOwnerIdAndWalletId(ownerId, walletId).isPresent();
    }
}

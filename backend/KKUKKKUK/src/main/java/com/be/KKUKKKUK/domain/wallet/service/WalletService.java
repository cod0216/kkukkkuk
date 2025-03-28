package com.be.KKUKKKUK.domain.wallet.service;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.wallet.dto.mapper.WalletMapper;
import com.be.KKUKKKUK.domain.wallet.repository.WalletRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.service<br>
 * fileName       : WalletService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Wallet entity 에 대한 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.20          haelim           지갑에 대한 CRUD api OwnerController -> WalletController 변경 <br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class WalletService {
    private final WalletRepository walletRepository;
    private final WalletMapper walletMapper;



    Optional<Wallet> getWalletOptionalByWalletAddress(String address) {
        return walletRepository.findByAddress(address);
    }

    /**
     * 보호자 회원의 ID 를 통해 디지털 지갑을 찾고, 지갑 정보를 반환합니다.
     * 지갑이 없다면 null 을 반환합니다.
     *
     * @param ownerId 보호자 회원의 ID
     * @return 디지털 지갑 정보
     */
    @Transactional(readOnly = true)
    public List<WalletInfoResponse> getWalletInfoByOwnerId(Integer ownerId) {
        List<Wallet> wallets = walletRepository.findByOwnerId(ownerId);
        return walletMapper.mapWalletsToWalletInfo(wallets);
    }

//

    /**
     * 지갑을 삭제합니다.
     * @param ownerId 삭제 요청한 보호자 ID
     */
//    @Transactional
//    public void deleteWalletByOwnerId(Integer ownerId) {
//        Wallet wallet = getWalletByOwnerId(ownerId);
//        walletRepository.delete(wallet);
//    }
//
//    /**
//     * 디지털 지갑 복구를 위해 지갑의 개인키를 조회합니다.
//     * @param ownerId 지갑 주인 ID
//     * @return  조회된 지갑의 암호화된 개인키
//     */
//    @Transactional(readOnly = true)
//    public WalletRecoverResponse recoverWallet(Integer ownerId){
//        Wallet wallet = getWalletByOwnerId(ownerId);
//        return new WalletRecoverResponse(wallet.getPrivateKey());
//    }


    /**
     * 보호자 ID로 보호자의 지갑을 조회합니다.
     * @param ownerId 지갑 주인 ID
     * @return 조회된 지갑 entity
     */
    private List<Wallet> getWalletOptionalByOwnerId(Integer ownerId) {
        return walletRepository.findByOwnerId(ownerId);
    }

    //TODO
    public void deleteWalletByWalletId(Integer ownerId) {
    }




    /**
     * 지갑 ID 정보로 지갑을 찾습니다.
     *
     * @param walletId 찾을 지갑 ID
     * @return 지갑 entity
     * @throws ApiException 지갑을 찾지 못한 경우
     */
    public Wallet getWalletById(Integer walletId) {
        return walletRepository.findById(walletId)
                .orElseThrow(() -> new ApiException(ErrorCode.WALLET_NOT_FOUND));
    }
    /**
     * 지갑에 대한 권한을 확인합니다.
     *
     * @param owner 지갑의 실제 주인
     * @param ownerId 요청한 사용자 ID
     */
    private void checkPermissionToWallet(Owner owner, Integer ownerId) {
        if (owner.getId().equals(ownerId)) {
            throw new ApiException(ErrorCode.WALLET_NOT_ALLOWED);
        }
    }


    public Wallet saveWallet(Wallet wallet) {
        return walletRepository.save(wallet);
    }
}

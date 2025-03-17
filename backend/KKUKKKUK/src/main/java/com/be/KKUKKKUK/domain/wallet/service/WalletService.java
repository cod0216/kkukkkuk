package com.be.KKUKKKUK.domain.wallet.service;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletRecoverResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.wallet.dto.mapper.WalletMapper;
import com.be.KKUKKKUK.domain.wallet.repository.WalletRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;
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
 */
@Slf4j
@Service
@RequiredArgsConstructor
public class WalletService {
    private final WalletRepository walletRepository;
    private final WalletMapper walletMapper;

    /**
     * 지갑을 신규 등록합니다.
     *
     * @param owner 등록할 지갑 주인
     * @param request 등록 요청
     * @return 등록된 지갑 정보
     */
    @Transactional
    public WalletInfoResponse registerWallet(Owner owner, WalletRegisterRequest request) throws ApiException {
        log.info("register wallet : {}", request);
        // 1. 이미 지갑이 존재하는지 확인
        if(getWalletOptionalByOwnerId(owner.getId()).isPresent()) throw new ApiException(ErrorCode.WALLET_ALREADY_EXIST);

        // 2. 지갑 생성
        Wallet wallet = request.toWalletEntity();
        wallet.setOwner(owner);

        return walletMapper.mapWalletToWalletInfo(walletRepository.save(wallet));
    }

    /**
     * 보호자 회원의 ID 를 통해 디지털 지갑을 찾고, 지갑 정보를 반환합니다.
     * 지갑이 없다면 null 을 반환합니다.
     *
     * @param ownerId 보호자 회원의 ID
     * @return 디지털 지갑 정보
     */
    @Transactional(readOnly = true)
    public WalletInfoResponse getWalletInfoByOwnerId(Integer ownerId) {
        Wallet wallet = walletRepository.findByOwnerId(ownerId).orElse(null);
        return walletMapper.mapWalletToWalletInfo(wallet);
    }

    /**
     * 지갑 정보를 업데이트합니다.
     *
     * @param ownerId 업데이트 요청한 보호자 ID
     * @param request 업데이트 요청
     * @return 업데이트된 결과
     */
    @Transactional
    public WalletInfoResponse updateWallet(Integer ownerId, WalletUpdateRequest request) {
        Wallet wallet = getWalletByOwnerId(ownerId);

        if(!Objects.isNull(request.getDid())) wallet.setDid(request.getDid());
        if(!Objects.isNull(request.getPrivateKey())) wallet.setPrivateKey(request.getPrivateKey());
        if(!Objects.isNull(request.getPublicKey())) wallet.setPublicKey(request.getPublicKey());
        if(!Objects.isNull(request.getAddress())) wallet.setAddress(request.getAddress());

        return walletMapper.mapWalletToWalletInfo(walletRepository.save(wallet));
    }

    /**
     * 지갑을 삭제합니다.
     * @param ownerId 삭제 요청한 보호자 ID
     */
    @Transactional
    public void deleteWalletByOwnerId(Integer ownerId) {
        Wallet wallet = getWalletByOwnerId(ownerId);
        walletRepository.delete(wallet);
    }

    /**
     * 디지털 지갑 복구를 위해 지갑의 개인키를 조회합니다.
     * @param ownerId 지갑 주인 ID
     * @return  조회된 지갑의 암호화된 개인키
     */
    @Transactional(readOnly = true)
    public WalletRecoverResponse recoverWallet(Integer ownerId){
        Wallet wallet = getWalletByOwnerId(ownerId);
        return new WalletRecoverResponse(wallet.getPrivateKey());
    }


    /**
     * 보호자 ID로 보호자의 지갑을 조회합니다.
     * @param ownerId 지갑 주인 ID
     * @return 조회된 지갑 entity
     */
    private Optional<Wallet> getWalletOptionalByOwnerId(Integer ownerId) {
        return walletRepository.findByOwnerId(ownerId);
    }

    /**
     * 보호자 ID로 보호자의 지갑을 조회합니다.
     * @param ownerId 지갑 주인 ID
     * @return 조회된 지갑 entity
     */
    private Wallet getWalletByOwnerId(Integer ownerId) {
        return getWalletOptionalByOwnerId(ownerId)
                .orElseThrow(() -> new ApiException(ErrorCode.WALLET_NOT_FOUND));
    }


//    /**
//     * 지갑 ID 정보로 지갑을 찾습니다.
//     *
//     * @param walletId 찾을 지갑 ID
//     * @return 지갑 entity
//     * @throws ApiException 지갑을 찾지 못한 경우
//     */
//    private Wallet getWalletById(Integer walletId) {
//        return walletRepository.findById(walletId)
//                .orElseThrow(() -> new ApiException(ErrorCode.WALLET_NOT_FOUND));
//    }
//    /**
//     * 지갑에 대한 권한을 확인합니다.
//     *
//     * @param owner 지갑의 실제 주인
//     * @param ownerId 요청한 사용자 ID
//     */
//    private void checkPermissionToWallet(Owner owner, Integer ownerId) {
//        if (owner.getId().equals(ownerId)) {
//            throw new ApiException(ErrorCode.WALLET_NOT_ALLOWED);
//        }
//    }

}

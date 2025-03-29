package com.be.KKUKKKUK.domain.wallet.service;

import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.wallet.repository.WalletRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
 * 25.03.28          haelim           지갑 - 보호자 N : M 으로 변경, 관련 로직 WalletComplexService 로 이동 <br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class WalletService {
    private final WalletRepository walletRepository;

    /**
     * 지갑 주소를 기준으로 지갑(Wallet) entity를 조회합니다.
     *
     * @param address 지갑의 주소
     * @return Wallet entity가 존재하면 Optional<Wallet>을 반환하고, 존재하지 않으면 빈 Optional을 반환합니다.
     */
    @Transactional(readOnly = true)
    Optional<Wallet> getWalletOptionalByWalletAddress(String address) {
        return walletRepository.findByAddress(address);
    }

    /**
     * 새로운 지갑(Wallet) entity를 저장합니다.
     *
     * @param wallet 저장할 Wallet 객체
     * @return 저장된 Wallet entity
     */
    public Wallet saveWallet(Wallet wallet) {
        return walletRepository.save(wallet);
    }

}

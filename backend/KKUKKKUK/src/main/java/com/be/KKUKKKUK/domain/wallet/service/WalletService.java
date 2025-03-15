package com.be.KKUKKKUK.domain.wallet.service;

import com.be.KKUKKKUK.domain.wallet.dto.WalletInfo;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.wallet.dto.mapper.WalletMapper;
import com.be.KKUKKKUK.domain.wallet.repository.WalletRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

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
@RequiredArgsConstructor
@Service
public class WalletService {
    private final WalletRepository walletRepository;
    private final WalletMapper walletMapper;

    /**
     * 보호자 회원의 ID 를 통해 디지털 지갑을 찾고, 지갑 정보를 반환합니다.
     * 지갑이 없다면 null 을 반환합니다.
     *
     * @param ownerId 보호자 회원의 ID
     * @return 디지털 지갑 정보
     */
    public WalletInfo getWalletInfoByOwnerId(Integer ownerId) {
        Wallet wallet = walletRepository.findWalletByOwnerId(ownerId).orElse(null);
        return walletMapper.walletToWalletInfo(wallet);
    }



}

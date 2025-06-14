package com.be.KKUKKKUK.domain.wallet.repository;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.repository<br>
 * fileName       : WalletRepository.java<br>
 * author         : haelim <br>
 * date           : 2025-03-13<br>
 * description    : Wallet entity 의 repository 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 * <br>
 */
public interface WalletRepository extends JpaRepository<Wallet, Integer> {
    Optional<Wallet> findByAddress(String address);
}
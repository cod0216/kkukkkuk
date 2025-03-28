package com.be.KKUKKKUK.domain.walletowner.repository;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.walletowner.entity.WalletOwner;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.ownerwallet.repository<br>
 * fileName       : WalletOwnerRepository.java<br>
 * author         : haelim <br>
 * date           : 2025-03-28<br>
 * description    : WalletOwner entity 의 repository 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.28          haelim           최초생성<br>
 * <br>
 */
public interface WalletOwnerRepository extends JpaRepository<WalletOwner, Integer> {
    Optional<WalletOwner> findByOwnerIdAndWalletId(Integer ownerId, Integer walletId);
}
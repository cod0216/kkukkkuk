package com.be.KKUKKKUK.domain.walletowner.repository;
import com.be.KKUKKKUK.domain.walletowner.entity.WalletOwner;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
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
    /**
     * 특정 보호자와 지갑 간의 관계(WalletOwner)가 존재하는지 조회합니다.
     *
     * @param ownerId  보호자 ID
     * @param walletId 지갑 ID
     * @return 지갑 소유자 관계가 존재하면 Optional<WalletOwner>를 반환하고, 존재하지 않으면 빈 Optional을 반환합니다.
     */
    Optional<WalletOwner> findByOwnerIdAndWalletId(Integer ownerId, Integer walletId);

    /**
     * 특정 지갑에 연결된 모든 보호자-지갑 관계를 조회합니다.
     *
     * @param walletId 지갑 ID
     * @return 해당 지갑에 연결된 WalletOwner 리스트
     */
    List<WalletOwner> findByWalletId(Integer walletId);

    /**
     * 특정 보호자에 연결된 모든 보호자-지갑 관계를 조회합니다.
     *
     * @param ownerId 보호자 ID
     * @return 해당 보호자에 연결된 WalletOwner 리스트
     */
    List<WalletOwner> findByOwnerId(Integer ownerId);
}
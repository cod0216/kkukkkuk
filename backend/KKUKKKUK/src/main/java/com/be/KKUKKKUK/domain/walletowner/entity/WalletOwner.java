package com.be.KKUKKKUK.domain.walletowner.entity;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

/**
 * packageName    : com.be.KKUKKKUK.domain.walletowner.entity<br>
 * fileName       : WalletOwner.java<br>
 * author         : haelim<br>
 * date           : 2025-03-28<br>
 * description    : WalletOwner entity class 입니다.<br>
 *                  Wallet entity, Owner entity 사이의 N : M 관계에 대한 entity 입니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.28          haelim           최초생성<br>
 */
@Entity
@Table(name = "wallet_owner")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class WalletOwner {
    @Id
    @Column(nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "owner_id", nullable = false)
    private Owner owner;

    @ManyToOne(fetch = FetchType.LAZY)
    @JoinColumn(name = "wallet_id", nullable = false)
    private Wallet wallet;

    public WalletOwner(Owner owner, Wallet wallet, LocalDateTime createdAt) {
        this.owner = owner;
        this.wallet = wallet;
        this.createdAt = createdAt;
    }
}

package com.be.KKUKKKUK.domain.wallet.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.annotation.CreatedDate;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDateTime;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.entity<br>
 * fileName       : Wallet.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-13<br>
 * description    :  wallet entity class 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          Fiat_lux           최초생성<br>
 * 25.03.28          haelim             지갑 - 보호자 N:M 으로 변경, owner 삭제, name 추가<br>
 * 25.04.02          haelim             개인키, 공용키, did 삭제 삭제 <br>
 */
@Entity
@Table(name = "wallet")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Wallet {
    @Id
    @Column(nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @CreatedDate
    @Column(name = "created_at", nullable = false, updatable = false)
    private LocalDateTime createdAt;

    @Column(nullable = false)
    private String address;

    @Column(nullable = true)
    private String name;

}

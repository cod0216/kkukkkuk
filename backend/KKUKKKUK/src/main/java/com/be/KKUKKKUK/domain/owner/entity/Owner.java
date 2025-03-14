package com.be.KKUKKKUK.domain.owner.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDate;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.entity<br>
 * fileName       : Owner.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-13<br>
 * description    :  owner entity class 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          Fiat_lux           최초생성<br>
 */
@Entity
@Table(name = "owner")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Owner {
    @Id
    @Column(name = "id")
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 30)
    private String name;

    @Column(nullable = false, length = 50)
    private String email;

    @Column(nullable = false)
    private LocalDate birth;

    @Column(name = "public_key")
    private String publicKey;

    @Column(name = "provider_id")
    private String providerId;
}

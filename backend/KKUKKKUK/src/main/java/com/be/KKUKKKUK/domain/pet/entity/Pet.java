package com.be.KKUKKKUK.domain.pet.entity;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.global.enumeration.Gender;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.time.LocalDate;

/**
 * packageName    : com.be.KKUKKKUK.domain.pet.entity<br>
 * fileName       : Pet.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-13<br>
 * description    :  pet entity class 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          Fiat_lux           최초생성<br>
 * 25.03.14          haelim             중성화 여부(flagNeutering) 컬럼명 추가 <br>
 */
@Entity
@Table(name = "pet")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Pet {
    @Id
    @Column(nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 100)
    private String name;

    @Column(nullable = false, length = 6)
    @Enumerated(EnumType.STRING)
    private Gender gender;

    @Column(nullable = false)
    private LocalDate birth;

    @Column(name = "flag_neutering", nullable = false)
    private Boolean flagNeutering;

    @Column
    private String did;

    @ManyToOne
    @JoinColumn(name = "wallet_id")
    private Wallet wallet;

    @ManyToOne
    @JoinColumn(name = "breed_id", nullable = false)
    private Breed breed;
}

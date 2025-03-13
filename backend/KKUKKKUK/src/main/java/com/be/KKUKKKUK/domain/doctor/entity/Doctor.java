package com.be.KKUKKKUK.domain.doctor.entity;

import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

/**
 * packageName    : com.be.KKUKKKUK.domain.doctor.entity<br>
 * fileName       : Doctor.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-13<br>
 * description    : doctor entity 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          Fiat_lux           최초생성<br>
 */
@Entity
@Table(name = "doctor")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Doctor {
    @Id
    @Column(nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false, length = 30)
    private String name;

    @ManyToOne
    @JoinColumn(name = "hospital_id", nullable = false)
    private Hospital hospital;
}

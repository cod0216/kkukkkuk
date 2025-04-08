package com.be.KKUKKKUK.domain.hospital.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

import java.math.BigDecimal;
import java.time.LocalDate;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.entity<br>
 * fileName       : Hospital.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-13<br>
 * description    : hospital entity 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          Fiat_lux           최초생성<br>
 * 25.03.14          haelim             licenseNumber, doctorName 필드 추가
 * 25.03.14          haelim             licenseNumber, 필드 삭제
 * 25.04.01          haelim             publicKey, 필드 삭제
 */

@Entity
@Table(name = "hospital")
@Getter
@Setter
@Builder
@ToString
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Hospital {
    @Id
    @Column(nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(length = 100, nullable = false)
    private String name;

    @Column(name = "phone_number", length = 14)
    private String phoneNumber;

    @Column
    private String did;

    @Column(length = 100)
    private String account;

    @Column(length = 100)
    private String password;

    @Column(nullable = false)
    private String address;

    @Column(name = "flag_certified", nullable = false)
    private Boolean flagCertified;

    @Column(name = "delete_date")
    private LocalDate deleteDate;

    @Column(name = "authoriazation_number", nullable = false)
    private String authorizationNumber;

    @Column(name = "x_axis", nullable = false)
    private BigDecimal xAxis;

    @Column(name = "y_axis", nullable = false)
    private BigDecimal yAxis;

    @Column(name = "doctor_name")
    private String doctorName;

    @Column(name = "email")
    private String email;

}

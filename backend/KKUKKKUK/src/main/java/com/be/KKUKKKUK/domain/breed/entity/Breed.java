package com.be.KKUKKKUK.domain.breed.entity;

import jakarta.persistence.*;
import lombok.*;
import org.springframework.data.jpa.domain.support.AuditingEntityListener;

/**
 * packageName    : com.be.KKUKKKUK.domain.breed.entity<br>
 * fileName       : Breed.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-13<br>
 * description    :  breed entity 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          Fiat_lux           최초생성<br>
 */
@Entity
@Table(name = "breed")
@Getter
@Setter
@Builder
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@EntityListeners(AuditingEntityListener.class)
public class Breed {
    @Id
    @Column(nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(nullable = false)
    private String name;

    @ManyToOne
    @JoinColumn(name = "parent_id")
    private Breed parentId;
}

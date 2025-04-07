package com.be.KKUKKKUK.domain.diagnosis.entity;

import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.diagnosis.entity<br>
 * fileName       : Diagnosis.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : Diagnosis의 entity 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Entity
@Table(name = "diagnosis")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Diagnosis { //TODO 자동정렬하는 것을 습관을 들였으면 좋겠습니다. 윈도우 : control + alt + L /  mac : option + cmd + L
    @Id
    @Column(nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "hospital_id", nullable = false)
    private Hospital hospital;

    @Column(length = 100, nullable = false)
    private String name;

    @Builder
    public Diagnosis(String name, Hospital hospital) {
        this.name = name;
        this.hospital = hospital;
    }
}

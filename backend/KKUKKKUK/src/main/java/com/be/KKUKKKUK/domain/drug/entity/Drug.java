package com.be.KKUKKKUK.domain.drug.entity;

import jakarta.persistence.*;
import lombok.*;
/**
 * packageName    : com.be.KKUKKKUK.domain.drug.entity<br>
 * fileName       : Drug.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-01<br>
 * description    : Drug의 entity 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.01          eunchang           최초생성<br>
 * <br>
 */

@Entity
@Table(name = "drug")
@Getter
@NoArgsConstructor(access = AccessLevel.PROTECTED)
@AllArgsConstructor
@Builder
public class Drug {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @Column(name = "name_kr") //TODO  해당 칼럼에 대한 조건은 없나요?
    private String nameKr;

    @Column(name = "name_en")
    private String nameEn;

    @Column(name = "apply_animal")
    private String applyAnimal;
}

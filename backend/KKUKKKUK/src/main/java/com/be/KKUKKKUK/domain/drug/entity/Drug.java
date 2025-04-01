package com.be.KKUKKKUK.domain.drug.entity;

import jakarta.persistence.*;
import lombok.*;

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

    @Column(name = "name_kr")
    private String nameKr;

    @Column(name = "name_en")
    private String nameEn;

    @Column(name = "apply_animal")
    private String applyAnimal;
}

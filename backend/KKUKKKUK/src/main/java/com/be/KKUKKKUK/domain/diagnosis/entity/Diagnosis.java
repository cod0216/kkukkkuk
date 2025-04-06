package com.be.KKUKKKUK.domain.diagnosis.entity;

import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import jakarta.annotation.Nullable;
import jakarta.persistence.*;
import lombok.*;

@Entity
@Table(name = "diagnosis")
@Getter
@Setter
@AllArgsConstructor
@NoArgsConstructor(access = AccessLevel.PROTECTED)
public class Diagnosis {
    @Id
    @Column(name="id", nullable = false)
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    @ManyToOne(fetch = FetchType.LAZY, optional = false)
    @JoinColumn(name = "hospital_id", nullable = false )
    private Hospital hospital;

    @Column(name = "name", length = 100, nullable = false)
    private String name;

    @Builder
    public Diagnosis(String name, Hospital hospital){
        this.name = name;
        this.hospital = hospital;
    }
}

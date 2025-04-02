package com.be.KKUKKKUK.domain.ocr.entity;

import jakarta.persistence.*;
import lombok.*;

/**
 * OCR 결과를 기반으로 한 진단 정보를 저장하는 엔티티입니다.
 */

@Entity
@Getter
@Setter
@NoArgsConstructor
@AllArgsConstructor
public class Diagnosis {

    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    private Integer id;

    private String date;
    private String diagnosis;
    private String prescription;
    private String symptoms;
}

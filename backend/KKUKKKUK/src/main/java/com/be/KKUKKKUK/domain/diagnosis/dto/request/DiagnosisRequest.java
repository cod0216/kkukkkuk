package com.be.KKUKKKUK.domain.diagnosis.dto.request;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.NoArgsConstructor;

@Getter
public class DiagnosisRequest {
    private Integer id;
    private String name;
    private String hospitalId;
}

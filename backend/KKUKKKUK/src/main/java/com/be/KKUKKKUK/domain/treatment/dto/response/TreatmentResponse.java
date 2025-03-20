package com.be.KKUKKKUK.domain.treatment.dto.response;

import com.be.KKUKKKUK.domain.treatment.TreatStatus;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;

@Data
@AllArgsConstructor
public class TreatmentResponse {
    private Integer id;

    private Integer petId;

    private Integer hospitalId;

    private LocalDate expireDate;

    private TreatStatus status;
}

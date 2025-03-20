package com.be.KKUKKKUK.domain.hospital.dto.request;

import com.be.KKUKKKUK.domain.treatment.entity.Treatment;
import lombok.Getter;

import java.time.LocalDateTime;

@Getter
public class RegisterTreatmentRequest {
    private Integer petDId;

    public Treatment toTreatmentEntity(){
        return Treatment.builder()
                .createdAt(LocalDateTime.now())
                .build();
    }
}

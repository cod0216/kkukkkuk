package com.be.KKUKKKUK.domain.diagnosis.dto.response;

import com.be.KKUKKKUK.domain.diagnosis.entity.Diagnosis;
import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Getter;
import lombok.Setter;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

@Data
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class DiagnosisResponse {
    private Integer id;
    private String name;
    private String hospitalId;

}

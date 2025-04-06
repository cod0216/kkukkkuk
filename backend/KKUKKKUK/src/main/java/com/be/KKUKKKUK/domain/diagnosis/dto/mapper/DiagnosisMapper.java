package com.be.KKUKKKUK.domain.diagnosis.dto.mapper;

import com.be.KKUKKKUK.domain.diagnosis.dto.response.DiagnosisResponse;
import com.be.KKUKKKUK.domain.diagnosis.entity.Diagnosis;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface DiagnosisMapper {
    @Mapping(target = "hospitalId", source = "hospital.id")
    DiagnosisResponse mapDiagnosisToDiagnosisResponse(Diagnosis diagnosis);
    List<DiagnosisResponse> mapDiagnosisToDiagnosisResponseList(List<Diagnosis> diagnosisResponse);
}

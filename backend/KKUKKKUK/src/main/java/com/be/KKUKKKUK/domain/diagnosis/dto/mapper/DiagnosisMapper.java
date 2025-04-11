package com.be.KKUKKKUK.domain.diagnosis.dto.mapper;

import com.be.KKUKKKUK.domain.diagnosis.dto.response.DiagnosisResponse;
import com.be.KKUKKKUK.domain.diagnosis.entity.Diagnosis;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.diagnosis.dto.mapper<br>
 * fileName       : DiagnosisUpdateRequest.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : Diagnosis의 Mapper 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface DiagnosisMapper {
    @Mapping(target = "hospitalId", source = "hospital.id")
    DiagnosisResponse mapDiagnosisToDiagnosisResponse(Diagnosis diagnosis);

    List<DiagnosisResponse> mapDiagnosisToDiagnosisResponseList(List<Diagnosis> diagnosisResponse);
}

package com.be.KKUKKKUK.domain.diagnosis.service;

import com.be.KKUKKKUK.domain.diagnosis.dto.mapper.DiagnosisMapper;
import com.be.KKUKKKUK.domain.diagnosis.dto.request.DiagnosisUpdateRequest;
import com.be.KKUKKKUK.domain.diagnosis.dto.response.DiagnosisResponse;
import com.be.KKUKKKUK.domain.diagnosis.entity.Diagnosis;
import com.be.KKUKKKUK.domain.diagnosis.repository.DiagnosisRepository;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.global.api.ApiResponse;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.AllArgsConstructor;
import lombok.NoArgsConstructor;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.diagnosis.service<br>
 * fileName       : DiagnosisService.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : 진단에 관한 Service를 제공하는 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Service
@Transactional
@RequiredArgsConstructor
public class DiagnosisService {
    private final DiagnosisRepository diagnosisRepository;
    private final HospitalService hospitalService;
    private final DiagnosisMapper diagnosisMapper;


    public List<DiagnosisResponse> getDiagnoses(Integer HospitalId){
        List<Diagnosis> diagnosisList = diagnosisRepository.getDiagnosesByHospitalId(HospitalId);
        return diagnosisMapper.mapDiagnosisToDiagnosisResponseList(diagnosisList);
    }

    public void deleteDiagnosis(Integer hospitalId, Integer diagnosisId){
        Diagnosis diagnosis = diagnosisRepository.getDiagnosisById(diagnosisId).orElseThrow(
                ()-> new ApiException(ErrorCode.DIA_NOT_FOUND));
        checkPermissionToDiagnosis(diagnosis, hospitalId);
        diagnosisRepository.delete(diagnosis);
    }

    public DiagnosisResponse updateDiagnosis(Integer hospitalId, Integer diagnosisId, DiagnosisUpdateRequest request){
        Diagnosis diagnosis = diagnosisRepository.getDiagnosisById(diagnosisId).orElseThrow(
                ()-> new ApiException(ErrorCode.DIA_NOT_FOUND));
        checkPermissionToDiagnosis(diagnosis, hospitalId);
        diagnosis.setName(request.getName());

        return diagnosisMapper.mapDiagnosisToDiagnosisResponse(diagnosisRepository.save(diagnosis));
    }

    public void checkPermissionToDiagnosis(Diagnosis diagnosis, Integer hospitalId) {
        if(Boolean.FALSE.equals(diagnosis.getHospital().getId().equals(hospitalId)))
            throw new ApiException(ErrorCode.DIA_AUTH_ERROR);
    }

}

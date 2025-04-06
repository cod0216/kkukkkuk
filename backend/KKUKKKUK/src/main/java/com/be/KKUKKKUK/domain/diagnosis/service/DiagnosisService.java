package com.be.KKUKKKUK.domain.diagnosis.service;

import com.be.KKUKKKUK.domain.diagnosis.dto.mapper.DiagnosisMapper;
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

@Service
@Transactional
@RequiredArgsConstructor
public class DiagnosisService {
    private final DiagnosisRepository diagnosisRepository;
    private final HospitalService hospitalService;
    private final DiagnosisMapper diagnosisMapper;


    public List<DiagnosisResponse> getDiagnoses(Integer HospitalId) {
        List<Diagnosis> diagnosisList = diagnosisRepository.getDiagnosesByHospitalId(HospitalId);
        return diagnosisMapper.mapDiagnosisToDiagnosisResponseList(diagnosisList);
    }

    public void deleteDiagnosis(Integer hospitalId, Integer diagnosisId){
        Diagnosis diagnosis = diagnosisRepository.getDiagnosisById(diagnosisId).orElseThrow(
                ()-> new ApiException(ErrorCode.DIA_NOT_FOUND));
        checkPermissionToDiagnosis(diagnosis, hospitalId);
        diagnosisRepository.delete(diagnosis);
    }

    public void checkPermissionToDiagnosis(Diagnosis diagnosis, Integer hospitalId) {
        if(Boolean.FALSE.equals(diagnosis.getHospital().getId().equals(hospitalId)))
            throw new ApiException(ErrorCode.DIA_AUTH_ERROR);
    }

}

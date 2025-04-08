package com.be.KKUKKKUK.domain.diagnosis.service;

import com.be.KKUKKKUK.domain.diagnosis.dto.mapper.DiagnosisMapper;
import com.be.KKUKKKUK.domain.diagnosis.dto.request.DiagnosisRequest;
import com.be.KKUKKKUK.domain.diagnosis.dto.response.DiagnosisResponse;
import com.be.KKUKKKUK.domain.diagnosis.entity.Diagnosis;
import com.be.KKUKKKUK.domain.diagnosis.repository.DiagnosisRepository;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

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
 * 25.04.08          eunchang           수정 및 삭제 관련 Redis 수정<br>
 * <br>
 */

@Service
@Transactional
@RequiredArgsConstructor
public class DiagnosisService {
    private final DiagnosisRepository diagnosisRepository;
    private final HospitalService hospitalService;
    private final DiagnosisMapper diagnosisMapper;
    private final DiagnosisRedisService diagnosisRedisService;

    /**
     * 작성한 검사항목을 모두 조회힙니다.
     *
     * @param HospitalId 동물병원 Id
     * @return 해당 동물 병원에서 작성한 검사 항목 모두 조회
     */
    @Transactional(readOnly = true)
    public List<DiagnosisResponse> getDiagnoses(Integer HospitalId) {
        List<Diagnosis> diagnosisList = diagnosisRepository.getDiagnosesByHospitalId(HospitalId);
        return diagnosisMapper.mapDiagnosisToDiagnosisResponseList(diagnosisList);
    }

    /**
     * 해당 검사항목을 제거합니다.
     *
     * @param hospitalId  동물병원 id
     * @param diagnosisId 삭제할 검사 항목 id
     * @throws ApiException 삭제할 검사 항목을 찾을 수 없을 시
     */
    public void deleteDiagnosis(Integer hospitalId, Integer diagnosisId) {
        Diagnosis diagnosis = diagnosisRepository.getDiagnosisById(diagnosisId).orElseThrow(
                () -> new ApiException(ErrorCode.DIA_NOT_FOUND));
        checkPermissionToDiagnosis(diagnosis, hospitalId);
        diagnosisRepository.delete(diagnosis);
        diagnosisRedisService.removeDiagnosisFromRedis(diagnosis);
    }

    /**
     * 검사 항목을 수정합니다.
     *
     * @param hospitalId  병원 id
     * @param diagnosisId 수정할 검사 항목 id
     * @param request     수정된 검사 항목을 반환합니다.
     * @throws ApiException 수정할 검사 항목을 찾을 수 없을 시
     */
    public DiagnosisResponse updateDiagnosis(Integer hospitalId, Integer diagnosisId, DiagnosisRequest request) {
        Diagnosis diagnosis = diagnosisRepository.getDiagnosisById(diagnosisId).orElseThrow(
                () -> new ApiException(ErrorCode.DIA_NOT_FOUND));
        checkPermissionToDiagnosis(diagnosis, hospitalId);

        diagnosisRedisService.removeDiagnosisFromRedis(diagnosis);

        diagnosis.setName(request.getName());
        Diagnosis updatedDiagnosis = diagnosisRepository.save(diagnosis);

        diagnosisRedisService.addDiagnosisToRedis(updatedDiagnosis);

        return diagnosisMapper.mapDiagnosisToDiagnosisResponse(updatedDiagnosis);
    }

    /**
     * 이름이 포함된 검사 항목을 반환합니다.
     *
     * @param name 조회할 검사 이름
     * @return 조회할 검사 이름이 포함된 검사 항목들을 반환합니다.
     */
    public List<DiagnosisResponse> searchDiagnoses(Integer hospitalId, String name) {
        List<Diagnosis> diagnosisList = diagnosisRepository.findByHospitalIdAndNameContaining(hospitalId, name);
        return diagnosisMapper.mapDiagnosisToDiagnosisResponseList(diagnosisList);
    }

    /**
     * 검사항목을 생성 반환 및 레디스에 추가합니다.
     *
     * @param hospitalId 병원 id
     * @param request    생성할 검사 이름
     * @return 생성된 검사 항목을 반환합니다.
     * @throws ApiException 이미 생성된 이름인 경우
     */
    public DiagnosisResponse createDiagnoses(Integer hospitalId, DiagnosisRequest request) {
        Hospital hospital = hospitalService.findHospitalById(hospitalId);
        if (Boolean.TRUE.equals(diagnosisRepository.existsByName(request.getName())))
            throw new ApiException(ErrorCode.DIA_DUPLICATE_NAME);
        diagnosisRedisService.addDiagnosisToRedis(new Diagnosis(request.getName(), hospital));
        return diagnosisMapper.mapDiagnosisToDiagnosisResponse(diagnosisRepository.save(new Diagnosis(request.getName(), hospital)));
    }

    /**
     * 해당 동물병원과 핸들링할 검사 Entitiy의 hospitalId가 일치한지 확인합니다. //
     *
     * @param diagnosis  검사 항목 Entity
     * @param hospitalId 병원 Id
     * @throws ApiException 해당 병원에서 작성한 검사 목록이 아닐 경우 에러 발생
     */
    private void checkPermissionToDiagnosis(Diagnosis diagnosis, Integer hospitalId) {
        if (Boolean.FALSE.equals(diagnosis.getHospital().getId().equals(hospitalId)))
            throw new ApiException(ErrorCode.DIA_AUTH_ERROR);
    }

}

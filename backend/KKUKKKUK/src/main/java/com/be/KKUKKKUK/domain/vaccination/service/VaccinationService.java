package com.be.KKUKKKUK.domain.vaccination.service;

import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.domain.vaccination.dto.mapper.VaccinationMapper;
import com.be.KKUKKKUK.domain.vaccination.dto.request.VaccinationRequest;
import com.be.KKUKKKUK.domain.vaccination.dto.response.VaccinationResponse;
import com.be.KKUKKKUK.domain.vaccination.entity.Vaccination;
import com.be.KKUKKKUK.domain.vaccination.repository.VaccinationRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

/**
 * packageName    : com.be.KKUKKKUK.domain.vaccination.service<br>
 * fileName       : vaccinationService.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : 접종에 관한 Service를 제공하는 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Service
@Transactional
@RequiredArgsConstructor
public class VaccinationService {
    private final VaccinationRepository vaccinationRepository;
    private final HospitalService hospitalService;
    private final VaccinationMapper vaccinationMapper;
    private final VaccinationAutoCompleteService vaccinationAutoCompleteService;

    /**
     * 작성한 예방 접종항목을 모두 조회힙니다.
     *
     * @param HospitalId 동물병원 Id
     * @return 해당 동물 병원에서 작성한 예방 접종 항목 모두 조회
     */
    public List<VaccinationResponse> getVaccinations(Integer HospitalId){
        List<Vaccination> vaccinationList = vaccinationRepository.getVaccinationByHospitalId(HospitalId);
        return vaccinationMapper.mapVaccinationToVaccinationResponseList(vaccinationList);
    }

    /**
     * 해당 예방 접종 항목을 제거합니다.
     *
     * @param hospitalId 동물병원 id
     * @param vaccinationId 삭제할 예방 접종 항목 id
     * @throws ApiException 삭제할 예방 접종 항목을 찾을 수 없을 시
     */
    public void deleteVaccination(Integer hospitalId, Integer vaccinationId){
        Vaccination vaccination = vaccinationRepository.getVaccinationById(vaccinationId).orElseThrow(
                ()-> new ApiException(ErrorCode.DIA_NOT_FOUND));
        checkPermissionToVaccination(vaccination, hospitalId);
        vaccinationRepository.delete(vaccination);
    }

    /**
     * 예방 접종 항목을 수정합니다.
     *
     * @param hospitalId 병원 id
     * @param vaccinationId 수정할 예방 접종 항목 id
     * @param request 수정된 예방 접종 항목을 반환합니다.
     * @throws ApiException 수정할 예방 접종 항목을 찾을 수 없을 시
     */
    public VaccinationResponse updateVaccination(Integer hospitalId, Integer vaccinationId, VaccinationRequest request){
        Vaccination vaccination = vaccinationRepository.getVaccinationById(vaccinationId).orElseThrow(
                ()-> new ApiException(ErrorCode.DIA_NOT_FOUND));
        checkPermissionToVaccination(vaccination, hospitalId);
        vaccination.setName(request.getName());

        return vaccinationMapper.mapVaccinationToVaccinationResponse(vaccinationRepository.save(vaccination));
    }

    /**
     * 이름이 포함된 예방 접종 항목을 반환합니다.
     * @param name 조회할 예방 접종 이름
     * @return 조회할 예방 접종 이름이 포함된 예방 접종 항목들을 반환합니다.
     */
    public List<VaccinationResponse> searchVaccinations(Integer hospitalId, String name){
        List<Vaccination> vaccinationList = vaccinationRepository.findByHospitalIdAndNameContaining(hospitalId, name);
        return vaccinationMapper.mapVaccinationToVaccinationResponseList(vaccinationList);
    }

    /**
     *  예방 접종 항목을 생성 반환 및 레디스에 추가합니다.
     * @param hospitalId 병원 id
     * @param request 생성할 예방 접종 이름
     * @return 생성된 예방 접종 항목을 반환합니다.
     * @throws ApiException 이미 생성된 이름인 경우
     */
    public VaccinationResponse createVaccinations(Integer hospitalId, VaccinationRequest request){
        Hospital hospital = hospitalService.findHospitalById(hospitalId);
        if(Objects.nonNull(vaccinationRepository.findByName(request.getName()))) throw new ApiException(ErrorCode.DIA_DUPLICATE_NAME);
        vaccinationAutoCompleteService.addvaccinationToRedis(new Vaccination(request.getName(),hospital));
        return vaccinationMapper.mapVaccinationToVaccinationResponse(vaccinationRepository.save(new Vaccination(request.getName(), hospital)));
    }

    /**
     * 해당 동물병원과 핸들링할 예방 접종 Entitiy의 hospitalId가 일치한지 확인합니다.ㄴ
     *
     * @param vaccination 예방 접종 항목 Entity
     * @param hospitalId 병원 Id
     */
    private void checkPermissionToVaccination(Vaccination vaccination, Integer hospitalId) {
        if(Boolean.FALSE.equals(vaccination.getHospital().getId().equals(hospitalId)))
            throw new ApiException(ErrorCode.DIA_AUTH_ERROR);
    }

}

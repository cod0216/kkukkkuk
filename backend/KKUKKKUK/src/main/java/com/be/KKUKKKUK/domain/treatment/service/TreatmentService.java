package com.be.KKUKKKUK.domain.treatment.service;

import com.be.KKUKKKUK.domain.hospital.dto.request.RegisterTreatmentRequest;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.domain.treatment.TreatStatus;
import com.be.KKUKKKUK.domain.treatment.dto.mapper.TreatmentMapper;
import com.be.KKUKKKUK.domain.treatment.dto.response.TreatmentResponse;
import com.be.KKUKKKUK.domain.treatment.entity.Treatment;
import com.be.KKUKKKUK.domain.treatment.repository.TreatmentRepository;
import lombok.AllArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDate;
import java.util.List;
import java.util.Map;
import java.util.Objects;
import java.util.stream.Collectors;

/**
 * packageName    : com.be.KKUKKKUK.domain.pet.service<br>
 * fileName       : TreatmentService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-20<br>
 * description    : Treatment entity 에 대한 하위 레벨의 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.20          haelim           최초 생성, 병원이 진료중인 반려동물 조회 메서드 작성 <br>
 */
@Service
@Transactional
@AllArgsConstructor
public class TreatmentService {
    final private TreatmentRepository treatmentRepository;
    final private TreatmentMapper treatmentMapper;

    /**
     * 특정 반려돔물에 대해 진료 기록을 조회합니다.
     * @param hospitalId 대상이 되는 동물병원 ID
     * @param expired 만료된 기록 필터링 여부, TRUE -> 만료된 기록만, FALSE -> 만료되지 않은 기록만, null -> 필터링하지 않음
     * @param status 기록 상태, 진료전 / 진료중 / 진료완료, null -> 필터링하지 않음
     * @param petId 필터링할 반려동물(pet) ID, null -> 필터링하지 않음
     * @return 조회된 기록 목록
     */
    @Transactional(readOnly = true)
    public Map<Integer, List<TreatmentResponse>> getFilteredTreatmentByHospitalId(
            Integer hospitalId, Boolean expired, TreatStatus status, Integer petId) {

        List<Treatment> treatments;

        if (Boolean.TRUE.equals(expired)) { // 만료된 진료 기록 조회
            if (!Objects.isNull(status) && !Objects.isNull(petId)) {
                treatments = treatmentRepository.findTreatmentByHospitalIdAndStatusAndPetIdAndExpireDateBefore(hospitalId, status, petId, LocalDate.now());
            } else if (!Objects.isNull(status)) {
                treatments = treatmentRepository.findTreatmentByHospitalIdAndStatusAndExpireDateBefore(hospitalId, status, LocalDate.now());
            } else if (!Objects.isNull(petId)) {
                treatments = treatmentRepository.findTreatmentByHospitalIdAndPetIdAndExpireDateBefore(hospitalId, petId, LocalDate.now());
            } else {
                treatments = treatmentRepository.findTreatmentByHospitalIdAndExpireDateBefore(hospitalId, LocalDate.now());
            }
        } else { // 만료되지 않은 진료 기록 조회
            if (!Objects.isNull(status) && !Objects.isNull(petId)) {
                treatments = treatmentRepository.findTreatmentByHospitalIdAndStatusAndPetIdAndExpireDateAfter(hospitalId, status, petId, LocalDate.now());
            } else if (!Objects.isNull(status)) {
                treatments = treatmentRepository.findTreatmentByHospitalIdAndStatusAndExpireDateAfter(hospitalId, status, LocalDate.now());
            } else if (!Objects.isNull(petId)) {
                treatments = treatmentRepository.findTreatmentByHospitalIdAndPetIdAndExpireDateAfter(hospitalId, petId, LocalDate.now());
            } else {
                treatments = treatmentRepository.findTreatmentByHospitalIdAndExpireDateAfter(hospitalId, LocalDate.now());
            }
        }

        List<TreatmentResponse> treatmentResponses = treatmentMapper.mapToTreatmentResponseList(treatments);
        return groupByPetId(treatmentResponses);
    }

    /**
     * TreatmentResponse 리스트를 petId 기준으로 그룹화합니다.
     * @param treatments 진료 기록 목록
     * @return 그룹화된 진료기록
     */
    private Map<Integer, List<TreatmentResponse>> groupByPetId(List<TreatmentResponse> treatments) {
        return treatments.stream()
                .collect(Collectors.groupingBy(TreatmentResponse::getPetId));
    }

    /**
     * 새로운 진료 기록을 등록합니다.
     * @param hospital 대상 병원
     * @param pet 대상 반려동물
     * @param request 새로운 진료 기록 요청
     * @return 새로운 진료 기록
     */
    public TreatmentResponse registerTreatment(Hospital hospital, Pet pet, RegisterTreatmentRequest request) {

        Treatment treatment = request.toTreatmentEntity();
        treatment.setHospital(hospital);
        treatment.setPet(pet);

        return treatmentMapper.mapToTreatmentResponse(treatmentRepository.save(treatment));
    }

}

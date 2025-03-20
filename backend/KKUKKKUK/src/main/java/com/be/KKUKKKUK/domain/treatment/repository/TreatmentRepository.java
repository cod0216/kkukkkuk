package com.be.KKUKKKUK.domain.treatment.repository;

import com.be.KKUKKKUK.domain.treatment.TreatState;
import com.be.KKUKKKUK.domain.treatment.entity.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.treatment.repository<br>
 * fileName       : TreatmentRepository.java<br>
 * author         : haelim<br>
 * date           : 2025-03-20<br>
 * description    : Treatment entity 에 대한 repository 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.20          haelim           최초 생성<br>
 */

public interface TreatmentRepository extends JpaRepository<Treatment, Integer> {

    /**
     * 특정 동물병원의 만료되지 않은 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param now 현재 날짜
     * @return 만료되지 않은 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndExpireDateAfter(Integer hospitalId, LocalDate now);

    /**
     * 특정 동물병원의 만료된 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param now 현재 날짜
     * @return 만료된 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndExpireDateBefore(Integer hospitalId, LocalDate now);

    /**
     * 특정 동물병원의 상태별 만료되지 않은 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param state 진료 상태
     * @param now 현재 날짜
     * @return 해당 상태의 만료되지 않은 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndStateAndExpireDateAfter(Integer hospitalId, TreatState state, LocalDate now);

    /**
     * 특정 동물병원의 특정 반려동물에 대한 상태별 만료되지 않은 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param state 진료 상태
     * @param petId 조회할 반려동물의 ID
     * @param now 현재 날짜
     * @return 해당 반려동물의 상태별 만료되지 않은 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndStateAndPetIdAndExpireDateAfter(Integer hospitalId, TreatState state, Integer petId, LocalDate now);

    /**
     * 특정 동물병원의 특정 반려동물에 대한 만료되지 않은 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param petId 조회할 반려동물의 ID
     * @param now 현재 날짜
     * @return 해당 반려동물의 만료되지 않은 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndPetIdAndExpireDateAfter(Integer hospitalId, Integer petId, LocalDate now);

    /**
     * 특정 동물병원의 특정 반려동물에 대한 만료된 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param petId 조회할 반려동물의 ID
     * @param now 현재 날짜
     * @return 해당 반려동물의 만료된 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndPetIdAndExpireDateBefore(Integer hospitalId, Integer petId, LocalDate now);

    /**
     * 특정 동물병원의 특정 반려동물에 대한 상태별 만료된 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param state 진료 상태
     * @param petId 조회할 반려동물의 ID
     * @param now 현재 날짜
     * @return 해당 반려동물의 상태별 만료된 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndStateAndPetIdAndExpireDateBefore(Integer hospitalId, TreatState state, Integer petId, LocalDate now);

    /**
     * 특정 동물병원의 상태별 만료된 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param state 진료 상태
     * @param now 현재 날짜
     * @return 해당 상태의 만료된 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndStateAndExpireDateBefore(Integer hospitalId, TreatState state, LocalDate now);

    /**
     * 특정 동물병원의 모든 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @return 해당 병원의 모든 진료 기록 목록
     */
    List<Treatment> findTByHospitalId(Integer hospitalId);

    /**
     * 특정 동물병원의 특정 상태의 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param state 조회할 진료 상태
     * @return 해당 상태의 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndState(Integer hospitalId, TreatState state);

    /**
     * 특정 동물병원의 특정 반려동물에 대한 진료 기록을 조회합니다.
     *
     * @param hospitalId 조회할 동물병원의 ID
     * @param petId 조회할 반려동물의 ID
     * @return 해당 반려동물의 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndPetId(Integer hospitalId, Integer petId);

    /**
     * 특정 동물병원의 특정 상태와 반려동물에 대한 진료 기록을 조회합니다.
     * @param hospitalId 조회할 동물병원의 ID
     * @param state 조회할 진료 상태
     * @param petId 조회할 반려동물의 ID
     * @return 해당 반려동물의 해당 상태의 진료 기록 목록
     */
    List<Treatment> findByHospitalIdAndStateAndPetId(Integer hospitalId, TreatState state, Integer petId);

}


package com.be.KKUKKKUK.domain.diagnosis.repository;

import com.be.KKUKKKUK.domain.diagnosis.entity.Diagnosis;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.diagnosis.service<br>
 * fileName       : DiagnosisService.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : Diagnosis entity 의 repository 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * 25.04.07          eunchang           find메서드 제거 및 exist메서드 추가<br>
 * <br>
 */

public interface DiagnosisRepository extends JpaRepository<Diagnosis, Integer> {
    List<Diagnosis> getDiagnosesByHospitalId(Integer hospitalId);

    List<Diagnosis> findByHospitalIdAndNameContaining(Integer HospitalId, String keyword);

    boolean existsByName(String name);

    Optional<Diagnosis> getDiagnosisById(Integer diagnosisId);
}

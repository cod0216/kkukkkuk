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
 * <br>
 */

public interface DiagnosisRepository extends JpaRepository<Diagnosis, Integer> {
    List<Diagnosis> getDiagnosesByHospitalId(Integer hospitalId);
    List<Diagnosis> findByHospitalIdAndNameContaining(Integer HospitalId, String keyword);
    Diagnosis findByName(String name); //TODO 어차피 null 검사를 할거면 Optional 을 사용하는게 더 좋지 않을까요?
    //TODO 그리고 이건 중복 이름이 있는가를 체크하려고 하는 메서드인 것 같은데 그럼 아예 조회 보다는 있는지 확인하는 exitsXXX 이 메서드가 의미적으로 맞지 않을까요?
    // 어차피 존재하는지만 체크하는 용도라 find로 해당 데이터를 조회하는 건 맞지 않다고 생각합니다. 어떻게 생각하시나요?
    Optional<Diagnosis> getDiagnosisById(Integer diagnosisId);
}

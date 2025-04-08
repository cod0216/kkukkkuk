package com.be.KKUKKKUK.domain.vaccination.repository;

import com.be.KKUKKKUK.domain.vaccination.entity.Vaccination;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.vaccination.service<br>
 * fileName       : vaccinationRepository.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : vaccination entity 의 repository 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

public interface VaccinationRepository extends JpaRepository<Vaccination, Integer> {
    List<Vaccination> getVaccinationByHospitalId(Integer hospitalId);
    List<Vaccination> findByHospitalIdAndNameContaining(Integer HospitalId, String keyword);
    Vaccination findByName(String name);
    Optional<Vaccination> getVaccinationById(Integer vaccinationId);
}

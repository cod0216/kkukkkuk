package com.be.KKUKKKUK.domain.hospital.repository;

import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.repository<br>
 * fileName       : HospitalRepository.java<br>
 * author         : haelim <br>
 * date           : 2025-03-13<br>
 * description    : Hospital entity 의 repository 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 * <br>
 */
public interface HospitalRepository extends JpaRepository<Hospital, Integer> {
    Optional<Hospital> findHospitalByAccount(String account);
    Optional<Hospital> findHospitalByAuthorizationNumber(String authorizationNumber);
    Optional<Hospital> findByAccount(String account);
    Optional<Hospital> findByLicenseNumber(String licenseNumber);
}

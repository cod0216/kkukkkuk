package com.be.KKUKKKUK.domain.hospital.repository;

import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.math.BigDecimal;
import java.util.List;
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
    Optional<Hospital> findHospitalByAuthorizationNumber(String authorizationNumber);

    List<Hospital> findHospitalListByNameContaining(String name);

    Optional<Hospital> findByAccount(String account);

    Optional<Hospital> findByEmail(String email);

    @Query(value = """
    SELECT h.*, 
           (6371 * acos(cos(radians(:yAxis)) * cos(radians(h.y_axis)) 
           * cos(radians(h.x_axis) - radians(:xAxis)) 
           + sin(radians(:yAxis)) * sin(radians(h.y_axis)))) AS distance
    FROM hospital h
    WHERE (6371 * acos(cos(radians(:yAxis)) * cos(radians(h.y_axis)) 
           * cos(radians(h.x_axis) - radians(:xAxis)) 
           + sin(radians(:yAxis)) * sin(radians(h.y_axis)))) < :radius
    ORDER BY distance ASC
    LIMIT 50    
    """, nativeQuery = true
    )
    List<Hospital> findHospitalsWithinRadius(BigDecimal xAxis, BigDecimal yAxis, Integer radius);
}

package com.be.KKUKKKUK.domain.doctor.repository;

import com.be.KKUKKKUK.domain.doctor.dto.response.DoctorInfoResponse;
import com.be.KKUKKKUK.domain.doctor.entity.Doctor;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.doctor.repository<br>
 * fileName       : DoctorRepository.java<br>
 * author         : haelim <br>
 * date           : 2025-03-13<br>
 * description    : Doctor entity 의 repository 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 * <br>
 */
public interface DoctorRepository extends JpaRepository<Doctor, Integer> {

    List<DoctorInfoResponse> getDoctorsByHospitalId(Integer hospitalId);

    void deleteByHospitalId(Integer hospitalId);
}

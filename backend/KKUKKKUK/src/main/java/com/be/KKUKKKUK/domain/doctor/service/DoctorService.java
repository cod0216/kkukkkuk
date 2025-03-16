package com.be.KKUKKKUK.domain.doctor.service;

import com.be.KKUKKKUK.domain.doctor.dto.DoctorInfo;
import com.be.KKUKKKUK.domain.doctor.dto.mapper.DoctorMapper;
import com.be.KKUKKKUK.domain.doctor.entity.Doctor;
import com.be.KKUKKKUK.domain.doctor.repository.DoctorRepository;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
@Service
@RequiredArgsConstructor
public class DoctorService {
    private final DoctorRepository doctorRepository;
    private final DoctorMapper doctorMapper;

    @Transactional
    public DoctorInfo registerDoctor(String name, Hospital hospital) { //TODO 반환값이 사용되지 않은데 굳이 반환을 해야하는 이유가 있을까요?
        return doctorMapper.doctorToDoctorInfo(doctorRepository.save(new Doctor(name, hospital)));
    }

    @Transactional(readOnly = true)
    public List<DoctorInfo> getDoctorsByHospitalId(Integer hospitalId) {
        return doctorRepository.getDoctorsByHospitalId(hospitalId);
    }


}

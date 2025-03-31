package com.be.KKUKKKUK.domain.doctor.service;

import com.be.KKUKKKUK.domain.doctor.dto.response.DoctorInfoResponse;
import com.be.KKUKKKUK.domain.doctor.dto.mapper.DoctorMapper;
import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorRegisterRequest;
import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorUpdateRequest;
import com.be.KKUKKKUK.domain.doctor.entity.Doctor;
import com.be.KKUKKKUK.domain.doctor.repository.DoctorRepository;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
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
 * 25.03.16          haelim           수정, 삭제, 전체조회 api 추가 <br>
 * <br>
 */

@Service
@RequiredArgsConstructor
public class DoctorService {
    private final DoctorRepository doctorRepository;
    private final DoctorMapper doctorMapper;

    /**
     * 특정 동물병원에 수의사를 등록합니다.
     *
     * @param hospital 조회 요청한 동물병원
     * @param request 등록할 수의사 정보
     * @return 등록 완료된 수의사 정보
     */
    @Transactional
    public DoctorInfoResponse registerDoctor(Hospital hospital, DoctorRegisterRequest request) { //TODO 파라미터에 null 값이 들어오면 어떻게 될까요?
        return doctorMapper.mapToDoctorInfo(doctorRepository.save(new Doctor(request.getName(), hospital)));
    }

    /**
     * 특정 동물병원에 등록된 수의사 전체 목록을 조회합니다.
     *
     * @param hospitalId 조회 요청한 동물병원 ID
     * @return 조회된 수의사 정보
     */
    @Transactional(readOnly = true)
    public DoctorInfoResponse getDoctorInfoById(Integer hospitalId, Integer doctorId) {
        Doctor doctor = getDoctorById(doctorId);

        // 수의사가 속한 병원이 아니면 조회 불가 //TODO 주석은 지워주세요
        checkPermissionToDoctor(doctor, hospitalId);

        return doctorMapper.mapToDoctorInfo(doctor);
    }

    /**
     * 특정 동물병원에 등록된 수의사 전체 목록을 조회합니다.
     *
     * @param hospitalId 조회 요청한 동물병원 ID
     * @return 동물병원에 등록된 수의사 목록
     */
    @Transactional(readOnly = true)
    public List<DoctorInfoResponse> getDoctorsByHospitalId(Integer hospitalId) {
        return doctorRepository.getDoctorsByHospitalId(hospitalId);
    }

    /**
     * 등록된 수의사 정보를 삭제합니다.
     *
     * @param hospitalId 삭제 요청한 동물병원 ID
     * @param doctorId 삭제할 수의사 ID
     */
    @Transactional
    public void deleteDoctorOnHospital(Integer hospitalId, Integer doctorId) {
        Doctor doctor = getDoctorById(doctorId);

        // 수의사가 속한 병원이 아니면 수정 불가
        checkPermissionToDoctor(doctor, hospitalId);

        doctorRepository.delete(doctor);
    }

    /**
     * 등록된 수의사의 정보를 업데이트합니다.
     *
     * @param hospitalId 수정 요청한 동물병원 ID
     * @param doctorId 수정할 수의사 ID
     * @param request 수정 요청
     * @return 수정 완료된 수의사 정보
     */
    @Transactional
    public DoctorInfoResponse updateDoctorOnHospital(Integer hospitalId, Integer doctorId, DoctorUpdateRequest request) {
        // 1. 수의사 조회
        Doctor doctor = getDoctorById(doctorId);

        // 2. 수의사가 속한 병원이 아니면 수정 불가
        checkPermissionToDoctor(doctor, hospitalId);

        // 3. 수의사 정보 수정
        doctor.setName(request.getName());

        // 4. 저장
        return doctorMapper.mapToDoctorInfo(doctorRepository.save(doctor));
    }

    /**
     *
     * 수의사 ID 로 수의사 정보를 조회합니다.
     *
     * @param doctorId 조회할 수의사 ID
     * @return Doctor entity
     * @throws ApiException 수의사를 찾을 수 없을 시 예외처리
     */
    private Doctor getDoctorById(Integer doctorId) {
        return doctorRepository.findById(doctorId)
                .orElseThrow(() -> new ApiException(ErrorCode.DOCTOR_NOT_FOUND));
    }

    /**
     * 동물병원이 특정 수의사에 대한 권한이 있는지 겁사하는 메소드
     * @param doctor 요청에 대한 수의사 entity
     * @param hospitalId 요청 시도한 동물병원 ID
     */
    private void checkPermissionToDoctor(Doctor doctor, Integer hospitalId) {
        if (!doctor.getHospital().getId().equals(hospitalId)) {
            throw new ApiException(ErrorCode.DOCTOR_NOT_ALLOWED);
        }
    }

}

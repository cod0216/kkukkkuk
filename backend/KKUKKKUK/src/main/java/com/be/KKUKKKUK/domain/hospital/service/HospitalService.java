package com.be.KKUKKKUK.domain.hospital.service;

import com.be.KKUKKKUK.domain.auth.dto.JwtTokenPair;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.auth.service.TokenService;
import com.be.KKUKKKUK.domain.doctor.service.DoctorService;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUpdateRequest;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalAuthorizationResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalUpdateResponse;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.hospital.dto.mapper.HospitalMapper;
import com.be.KKUKKKUK.domain.hospital.repository.HospitalRepository;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Objects;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.service<br>
 * fileName       : HospitalService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Hospital entity 에 대한 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@RequiredArgsConstructor
@Slf4j
@Service
public class HospitalService {
    private final HospitalRepository hospitalRepository;
    private final HospitalMapper hospitalMapper;
    private final TokenService tokenService;
    private final DoctorService doctorService;


    /**
     *
     * @param request
     * @return
     */
    public HospitalLoginResponse login(HospitalLoginRequest request) {
        Hospital hospital = hospitalRepository.findHospitalByAccount(request.getAccount())
                .orElseThrow(() -> new ApiException(ErrorCode.ACCOUNT_NOT_FOUND));

        if (!hospital.getPassword().equals(request.getPassword())) {
            throw new ApiException(ErrorCode.PASSWORD_NOT_MATCH);
        }

        JwtTokenPair tokenPair = tokenService.generateTokens(hospital.getId(), RelatedType.HOSPITAL);

        return new HospitalLoginResponse(hospitalMapper.hospitalToHospitalInfo(hospital), tokenPair);
    }

    /**
     *
     * @param request
     * @return
     */
    public HospitalSignupResponse signup(HospitalSignupRequest request) {
        // 1. id로 동물병원을 찾을 수 없는 경우 예외 발생
        Hospital hospital = hospitalRepository.findById(request.getId())
                .orElseThrow(() -> new ApiException(ErrorCode.HOSPITAL_NOT_FOUND));

        // 2. 이미 해당 병원으로 등록된 계정이 있는 경우 예외 발생
        log.info("flagCertified 확인, 이미 해당 병원으로 등록된 계정이 있는 경우 예외 발생 hospital: {}", hospital);
        if(hospital.getFlagCertified()) throw new ApiException(ErrorCode.HOSPITAL_DUPLICATED);

        // 3. 계정이 유니크하지 않은 경우 예외 발생
        log.info("등록하려는 계정이 유니크하지 않은 경우 예외 발생 hospital: {}", hospital);
        if(!checkAccountAvailable(request.getAccount())) throw new ApiException(ErrorCode.ACCOUNT_NOT_AVAILABLE);
        hospital.setAccount(request.getAccount());

        // 4. 라이센스가 유니크하지 않은 경우 예외 발생
        log.info("라이센스가 유니크하지 않은 경우 예외 발생 hospital: {}", hospital);
        if(!checkLicenseAvailable(request.getLicenseNumber())) throw new ApiException(ErrorCode.LICENSE_NOT_AVAILABLE);
        hospital.setLicenseNumber(request.getLicenseNumber());

        hospital.setPassword(request.getPassword());
        hospital.setDoctorName(request.getDoctorName());
        hospital.setDid(request.getDid());

        hospital.setFlagCertified(true);
        hospitalRepository.save(hospital);
        doctorService.registerDoctor(request.getDoctorName(), hospital);
        return hospitalMapper.hospitalToHospitalSignupRequest(hospital);
    }

    /**
     * 동물병원의 인허가 번호로 동물병원을 조회합니다.
     *
     * @param authorizationNumber 조회할 동물병원의 인허가번호
     * @return 인허가 번호로 조회한 동물병원 정보
     * @throws ApiException 인허가번호로 동물병원을 찾을 수 없는 경우 예외 발생
     */
    public HospitalAuthorizationResponse getHospitalByAuthorizationNumber(String authorizationNumber) {
        Hospital hospital = hospitalRepository.findHospitalByAuthorizationNumber(authorizationNumber)
                .orElseThrow(() -> new ApiException(ErrorCode.HOSPITAL_NOT_FOUND));

        return hospitalMapper.hospitalToHospitalAuthorizationRequest(hospital);
    }

    /**
     * 동물병원용 계정의 사용 가능 여부를 확인합니다.
     * @param account 로그인 시 사용할 동물병원 계정
     * @return 회원가입 시 등록 가능한 계정인지 여부
     */
    public boolean checkAccountAvailable(String account) {
        return hospitalRepository.findByAccount(account).isEmpty();
    }

    /**
     * 수의사 라이센스 사용 가능 여부를 확인합니다.
     * 현재는 중복 여부만 체크하고 있습니다.
     * TODO : 의료인 인증
     * @param licenseNumber 수의사 라이센스 번호
     * @return 회원가입 시 등록 가능한 수의사 라이센스인지 여부
     */
    public Boolean checkLicenseAvailable(String licenseNumber) {
        return hospitalRepository.findByLicenseNumber(licenseNumber).isEmpty();
    }

    /**
     *
     * @param id 동물병원 식별을 위한 id
     * @param request
     * @return
     */
    public HospitalUpdateResponse updateHospital(Integer id, HospitalUpdateRequest request) {
        Hospital hospital = hospitalRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.HOSPITAL_NOT_FOUND));

        hospital.setPassword(request.getPassword());
        hospital.setName(request.getName());
        hospitalRepository.save(hospital);

        return new HospitalUpdateResponse(hospitalMapper.hospitalToHospitalInfo(hospital));
    }

}


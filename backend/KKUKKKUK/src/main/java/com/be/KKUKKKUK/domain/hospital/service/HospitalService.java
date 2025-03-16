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
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalInfoResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalUpdateResponse;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.hospital.dto.mapper.HospitalMapper;
import com.be.KKUKKKUK.domain.hospital.repository.HospitalRepository;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
 * 25.03.15          haelim           비밀번호 encording, 주석 추가
 */

@Transactional(readOnly = true)
@RequiredArgsConstructor
@Slf4j
@Service
public class HospitalService {
    private final HospitalRepository hospitalRepository;
    private final HospitalMapper hospitalMapper;
    private final TokenService tokenService;
    private final DoctorService doctorService;
    private final BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();


    /**
     * 동물병원 로그인 기능.
     *
     * @param request 로그인 요청 정보
     * @return 로그인 성공 시 병원 정보 및 토큰 반환
     * @throws ApiException 계정이 존재하지 않거나 비밀번호가 틀린 경우 예외 발생
     */
    public HospitalLoginResponse login(HospitalLoginRequest request) {
        Hospital hospital = hospitalRepository.findHospitalByAccount(request.getAccount())
                .orElseThrow(() -> new ApiException(ErrorCode.ACCOUNT_NOT_FOUND));

        if (!passwordEncoder.matches(request.getPassword(), hospital.getPassword())) {
            throw new ApiException(ErrorCode.PASSWORD_NOT_MATCH);
        }

        JwtTokenPair tokenPair = tokenService.generateTokens(hospital.getId(), RelatedType.HOSPITAL);

        return new HospitalLoginResponse(hospitalMapper.hospitalToHospitalInfo(hospital), tokenPair);
    }

    /**
     * 동물병원 회원가입 기능.
     *
     * @param request 회원가입 요청 정보
     * @return 회원가입 성공 시 병원 정보 반환
     * @throws ApiException 병원이 존재하지 않거나 중복된 계정 또는 라이센스일 경우 예외 발생
     */
    @Transactional
    public HospitalSignupResponse signup(HospitalSignupRequest request) {
        // 1. id로 동물병원을 찾을 수 없는 경우 예외 발생
        Hospital hospital = findHospitalById(request.getId());

        // 2. 이미 해당 병원으로 등록된 계정이 있는 경우 예외 발생
        if(hospital.getFlagCertified()) throw new ApiException(ErrorCode.HOSPITAL_DUPLICATED); //TODO 취향 차이긴 한데 if 문 한줄로 처리하는 거랑 {, }괄호로 처리하는 거랑 어떤게 가독성 좋을지 고민 해봤으면 좋겠어요

        // 3. 계정이 유니크하지 않은 경우 예외 발생
        if(!checkAccountAvailable(request.getAccount())) throw new ApiException(ErrorCode.ACCOUNT_NOT_AVAILABLE);
        hospital.setAccount(request.getAccount());

        // 4. 라이센스가 유니크하지 않은 경우 예외 발생
        if(!checkLicenseAvailable(request.getLicenseNumber())) throw new ApiException(ErrorCode.LICENSE_NOT_AVAILABLE);
        hospital.setLicenseNumber(request.getLicenseNumber());
        hospital.setPassword(passwordEncoder.encode(request.getPassword()));
        hospital.setDoctorName(request.getDoctorName());
        hospital.setDid(request.getDid());

        hospital.setFlagCertified(true);
        hospitalRepository.save(hospital);
        doctorService.registerDoctor(request.getDoctorName(), hospital);

        return hospitalMapper.hospitalToHospitalSignupRequest(hospital); //TODO save 한 결과 객체를 mapping 하는 건 어떨까요? 만약에 데이터베이스에 반영이 안되는 문제가 발생했을때는 데이터가 다를 것 같아서요
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
     * 동물병원의 정보를 업데이트합니다.
     *
     * @param id 병원 ID
     * @param request 업데이트 요청 정보
     * @return 업데이트된 병원 정보
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    @Transactional
    public HospitalUpdateResponse updateHospital(Integer id, HospitalUpdateRequest request) {
        Hospital hospital = findHospitalById(id);

        if(!Objects.isNull(request.getDid())) hospital.setDid(request.getDid());
        if(!Objects.isNull(request.getPassword())) hospital.setPassword(passwordEncoder.encode(request.getPassword()));
        if(!Objects.isNull(request.getName())) hospital.setName(request.getName());
        if(!Objects.isNull(request.getPhoneNumber())) hospital.setPhoneNumber(request.getPhoneNumber());

        hospitalRepository.save(hospital);

        return new HospitalUpdateResponse(hospitalMapper.hospitalToHospitalInfo(hospital));
    }

    /**
     * ID를 기반으로 병원 정보를 조회합니다.
     *
     * @param id 병원 ID
     * @return 병원 정보
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    public HospitalInfoResponse getHospitalById(Integer id) {
        Hospital hospital = findHospitalById(id);
        return hospitalMapper.hospitalToHospitalInfoResponse(hospital);
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
     * ID를 기반으로 병원 entity 를 조회합니다.
     *
     * @param id 병원 ID
     * @return 병원 entity
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    public Hospital findHospitalById(Integer id) {
        return hospitalRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.HOSPITAL_NOT_FOUND));
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


}


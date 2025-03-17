package com.be.KKUKKKUK.domain.hospital.service;

import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.auth.service.TokenService;
import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorRegisterRequest;
import com.be.KKUKKKUK.domain.doctor.dto.response.DoctorInfoResponse;
import com.be.KKUKKKUK.domain.doctor.service.DoctorService;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUpdateRequest;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalAllResponse;
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

import java.util.List;
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
 * 25.03.15          haelim           비밀번호 encoding, 주석 추가<br>
 * 25.03.16          haelim           병원 소속 수의사 관련 메소드 추가<br>
 *
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

        JwtTokenPairResponse tokenPair = tokenService.generateTokens(hospital.getId(), RelatedType.HOSPITAL);

        return new HospitalLoginResponse(hospitalMapper.hospitalToHospitalInfo(hospital), tokenPair);
    }

    /**
     * 동물병원 회원가입 기능.
     * @param request 회원가입 요청 정보
     * @return 회원가입 성공 시 병원 정보 반환
     * @throws ApiException 병원이 존재하지 않거나 중복된 계정 또는 라이센스일 경우 예외 발생
     */
    @Transactional
    public HospitalSignupResponse signup(HospitalSignupRequest request) {
        // 1. id로 동물병원을 찾을 수 없는 경우 예외 발생
        Hospital hospital = findHospitalById(request.getId());

        // 2. 이미 해당 병원으로 등록된 계정이 있는 경우 예외 발생
        if (hospital.getFlagCertified()) throw new ApiException(ErrorCode.HOSPITAL_DUPLICATED);

        // 3. 계정이 유니크하지 않은 경우 예외 발생
        if (Objects.equals(Boolean.TRUE, checkAccountAvailable(request.getAccount()))) throw new ApiException(ErrorCode.ACCOUNT_NOT_AVAILABLE);
        hospital.setAccount(request.getAccount());

        // 4. 라이센스가 유니크하지 않은 경우 예외 발생
        if (!checkLicenseAvailable(request.getLicenseNumber())) throw new ApiException(ErrorCode.LICENSE_NOT_AVAILABLE);
        hospital.setLicenseNumber(request.getLicenseNumber());
        hospital.setPassword(passwordEncoder.encode(request.getPassword()));
        hospital.setDoctorName(request.getDoctorName());
        hospital.setDid(request.getDid());

        hospital.setFlagCertified(Boolean.TRUE);
        hospitalRepository.save(hospital);

        DoctorRegisterRequest doctorRegisterRequest = new DoctorRegisterRequest(request.getDoctorName());
        doctorService.registerDoctor(hospital, doctorRegisterRequest);

        return hospitalMapper.hospitalToHospitalSignupRequest(hospital);
    }

    /**
     * 동물병원의 인허가 번호로 동물병원을 조회합니다.
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
     * @param id      병원 ID
     * @param request 업데이트 요청 정보
     * @return 업데이트된 병원 정보
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    @Transactional
    public HospitalUpdateResponse updateHospital(Integer id, HospitalUpdateRequest request) {
        Hospital hospital = findHospitalById(id);

        if (!Objects.isNull(request.getDid())) hospital.setDid(request.getDid());
        if (!Objects.isNull(request.getPassword())) hospital.setPassword(passwordEncoder.encode(request.getPassword()));
        if (!Objects.isNull(request.getName())) hospital.setName(request.getName());
        if (!Objects.isNull(request.getPhoneNumber())) hospital.setPhoneNumber(request.getPhoneNumber());

        hospitalRepository.save(hospital);

        return new HospitalUpdateResponse(hospitalMapper.hospitalToHospitalInfo(hospital));
    }

    /**
     * ID를 기반으로 병원 정보를 조회합니다.
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
     * 사용 가능하면 true, 사용 불가능하면(중복) false 를 반환합니다.
     * @param account 로그인 시 사용할 동물병원 계정
     * @return 회원가입 시 등록 가능한 계정인지 여부
     */
    public Boolean checkAccountAvailable(String account) {
        return hospitalRepository.findByAccount(account).isEmpty();
    }


    /**
     * 특정 동물병원에 수의사를 신규 등록합니다.
     * 동물 병원에 대한 요청만 처리하고, doctorService 로 요청을 넘깁니다.
     * @param hospitalId 등록 요청한 병원 ID
     * @param request 등록할 수의사 정보
     * @return 등록된 수의사 정보
     */
    @Transactional
    public DoctorInfoResponse registerDoctor(Integer hospitalId, DoctorRegisterRequest request) {
        Hospital hospital = findHospitalById(hospitalId);
        return doctorService.registerDoctor(hospital, request);
    }

    /**
     * 현재 로그인한 병원의 모든 수의사 목록을 조회합니다.
     * 동물 병원에 대한 요청만 처리하고, doctorService 로 요청을 넘깁니다.
     * @param hospitalId 로그인한 동물병원의 ID
     * @return 수의사 목록
     */
    public List<DoctorInfoResponse> getAllDoctorsOnHospital(Integer hospitalId) {
        return doctorService.getDoctorsByHospitalId(hospitalId);
    }


    /**
     * TODO : 요청된 위치 좌표(xAxis, yAxis) 주변의 동물병원 목록을 조회합니다.
     *
     * @param xAxis 기준 x좌표
     * @param yAxis 기준 y좌표
     * @param radius 조회 반경
     * @return 주변 동물 병원 목록
     */
    public HospitalAllResponse getAllHospital(Double xAxis, Double yAxis, Integer radius) {

        return null;
    }


    /**
     * 동물병원 ID를 기반으로 동물병원 entity 를 조회합니다.
     * @param id 동물병원 ID
     * @return 동물병원 entity
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    private Hospital findHospitalById(Integer id) {
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


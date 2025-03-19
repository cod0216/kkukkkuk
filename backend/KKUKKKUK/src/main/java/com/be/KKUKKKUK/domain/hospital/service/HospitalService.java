package com.be.KKUKKKUK.domain.hospital.service;

import com.be.KKUKKKUK.domain.auth.dto.request.HospitalLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalInfoResponse;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUpdateRequest;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalAllResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalDetailInfoResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalMapInfoResponse;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.hospital.dto.mapper.HospitalMapper;
import com.be.KKUKKKUK.domain.hospital.repository.HospitalRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

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
 * 25.03.18          haelim           수의사 라이센스 삭제, 이메일 추가 <br>
 *
 */

@Service
@RequiredArgsConstructor
public class HospitalService {
    private final HospitalRepository hospitalRepository;
    private final HospitalMapper hospitalMapper;
    private final PasswordEncoder passwordEncoder;

    /**
     *
     * 전체 회원가입 과정 중, Hospital 관련 회원가입 시도를 위한 메소드입니다.
     * 요청의 유효성을 검사하고(계정, 비밀번호) 회원가입된 병원 정보를 조회합니다.
     * @param hospital 회원가입 시도한 hospital
     * @param request 회원가입 시도 요청
     * @return 회원가입된 병원 정보
     */
    @Transactional
    public HospitalSignupResponse trySignUp(Hospital hospital, HospitalSignupRequest request) {
        // 1. 계정, 라이센스 중복 여부 확인
        checkSignUpAvailable(hospital, request);

        // 2. request -> entity 로 맵핑
        mapRequestToEntity(hospital, request);

        // 3. 계정 등록 처리
        hospital.setFlagCertified(Boolean.TRUE);

        // 4. Response 반환
        return hospitalMapper.mapToSignupResponse(saveHospital(hospital));
    }

    /**
     *
     * 전체 로그인 과정 중, Hospital 관련 로그인 시도를 위한 메소드입니다.
     * 요청의 유효성을 검사하고(계정, 비밀번호) 로그인된 병원 정보를 조회합니다.
     * @param request 로그인 시도 요청
     * @return 로그인된 병원 정보
     * @throws ApiException 비밀번호가 일치하지 않는 경우 예외처리
     */
    @Transactional
    public HospitalInfoResponse tryLogin(HospitalLoginRequest request) {
        Hospital hospital = findHospitalByAccount(request.getAccount());

        if (!passwordEncoder.matches(request.getPassword(), hospital.getPassword())) {
            throw new ApiException(ErrorCode.PASSWORD_NOT_MATCH);
        }

        return hospitalMapper.mapToHospitalInfo(hospital);
    }


    /**
     * 동물병원의 인허가 번호로 동물병원을 조회합니다.
     * @param authorizationNumber 조회할 동물병원의 인허가번호
     * @return 인허가 번호로 조회한 동물병원 정보
     * @throws ApiException 인허가번호로 동물병원을 찾을 수 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public HospitalMapInfoResponse getHospitalByAuthorizationNumber(String authorizationNumber) {
        Hospital hospital = hospitalRepository.findHospitalByAuthorizationNumber(authorizationNumber)
                .orElseThrow(() -> new ApiException(ErrorCode.HOSPITAL_NOT_FOUND));

        return hospitalMapper.mapToHospitalMapInfoResponse(hospital);
    }

    /**
     * 동물병원의 이름으로 동물병원 목록을 조회합니다.
     * @param name 조회할 동물병원의 이름
     * @return 병원 이름으로 조회한 동물병원 정보
     */
    @Transactional(readOnly = true)
    public List<HospitalMapInfoResponse> getHospitalListByName(String name) {
        List<Hospital> hospitalList = hospitalRepository.findHospitalListByNameContaining(name);

        return hospitalMapper.mapToHospitalMapInfoList(hospitalList);
    }

    /**
     * 동물병원의 정보를 업데이트합니다.
     * @param id      병원 ID
     * @param request 업데이트 요청 정보
     * @return 업데이트된 병원 정보
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    @Transactional
    public HospitalInfoResponse updateHospital(Integer id, HospitalUpdateRequest request) {
        Hospital hospital = findHospitalById(id);

        if (!Objects.isNull(request.getDid())) hospital.setDid(request.getDid());
        if (!Objects.isNull(request.getName())) hospital.setName(request.getName());
        if (!Objects.isNull(request.getPhoneNumber())) hospital.setPhoneNumber(request.getPhoneNumber());
        if (!Objects.isNull(request.getPassword())) hospital.setPassword(passwordEncoder.encode(request.getPassword()));

        return hospitalMapper.mapToHospitalInfo(saveHospital(hospital));
    }

    /**
     * ID를 기반으로 병원 상세 정보를 조회합니다.
     * @param id 병원 ID
     * @return 병원 정보
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public HospitalDetailInfoResponse getHospitalDetailInfoById(Integer id) {
        Hospital hospital = findHospitalById(id);
        return hospitalMapper.mapToHospitalDetailInfoResponse(hospital);
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
     * 동물병원용 계정의 사용 가능 여부를 확인합니다.
     * 사용 가능하면 true, 사용 불가능하면(중복) false 를 반환합니다.
     * @param account 로그인 시 사용할 동물병원 계정
     * @return 회원가입 시 등록 가능한 계정인지 여부
     */
    @Transactional(readOnly = true)
    public Boolean checkAccountAvailable(String account) {
        return hospitalRepository.findByAccount(account).isEmpty();
    }


    /**
     * 동물병원 account 를 기반으로 동물병원 entity 를 조회합니다.
     * @param account 동물병원 account
     * @return 동물병원 entity
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public Hospital findHospitalByAccount(String account) {
        return hospitalRepository.findByAccount(account)
                .orElseThrow(() -> new ApiException(ErrorCode.ACCOUNT_NOT_FOUND));
    }

    /**
     * 동물병원 ID를 기반으로 동물병원 entity 를 조회합니다.
     * @param id 동물병원 ID
     * @return 동물병원 entity
     * @throws ApiException 병원을 찾을 수 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public Hospital findHospitalById(Integer id) {
        return hospitalRepository.findById(id)
                .orElseThrow(() -> new ApiException(ErrorCode.HOSPITAL_NOT_FOUND));
    }







    /**
     * 해당 이메일로 가입한 동물병원 회원이 있는지 확인합니다.
     * @param email 확인할 이메일 주소
     * @return 사용 가능 여부( 사용 가능하면 TRUE, 중복이면 FALSE )
     */
    @Transactional(readOnly = true)
    public Boolean checkEmailAvailable(String email) {
        return findHospitalByEmailOptional(email).isEmpty();
    }

    /**
     * email 로 동물 병원 회원을 조회합니다.
     * @param email 확인할 email
     * @return email로 조회한 hospital entity
     */
    @Transactional(readOnly = true)
    public Optional<Hospital> findHospitalByEmailOptional(String email) {
        return hospitalRepository.findByEmail(email);
    }

    /**
     * hospital entity 를 데이터베이스에 저장합니다.
     * @param hospital 저장할 entity
     * @return 저장된 entity
     */
    @Transactional
    public Hospital saveHospital(Hospital hospital){
        return hospitalRepository.save(hospital);
    }

    /**
     * 회원가입 요청의 유효성을 검사합니다.
     * 동물병원 회원이 이미 등록되었는지, 사용 가능한 계정인지, 사용 가능한 라이센스인지 검증합니다.
     * @param hospital 가입 요청한 동물병원
     * @param request 가입 요청
     */
    private void checkSignUpAvailable(Hospital hospital, HospitalSignupRequest request) {
        if (Boolean.TRUE.equals(hospital.getFlagCertified())) {
            throw new ApiException(ErrorCode.HOSPITAL_DUPLICATED);
        }
        // 사용가능하지 않으면 예외 처리
        if (Boolean.FALSE.equals(checkAccountAvailable(request.getAccount()))) {
            throw new ApiException(ErrorCode.ACCOUNT_NOT_AVAILABLE);
        }
    }

    /**
     * 회원가입 요청을 entity 로 맵핑시킵니다.
     * @param hospital entity
     * @param request 회원가입 요청
     */
    private void mapRequestToEntity(Hospital hospital, HospitalSignupRequest request) {
        hospital.setAccount(request.getAccount());
        hospital.setPassword(passwordEncoder.encode(request.getPassword()));
        hospital.setDoctorName(request.getDoctorName());
        hospital.setDid(request.getDid());
    }
}


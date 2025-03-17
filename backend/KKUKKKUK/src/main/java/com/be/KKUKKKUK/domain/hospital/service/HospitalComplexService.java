package com.be.KKUKKKUK.domain.hospital.service;

import com.be.KKUKKKUK.domain.auth.dto.request.HospitalLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.domain.auth.service.TokenService;
import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorRegisterRequest;
import com.be.KKUKKKUK.domain.doctor.dto.response.DoctorInfoResponse;
import com.be.KKUKKKUK.domain.doctor.service.DoctorService;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalInfoResponse;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.service<br>
 * fileName       : HospitalComplexService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Hospital entity 에 대한 상위 레벨의 service 클래스입니다.<br>
 *                  HospitalService, TokenService, DoctorService 등 저수준 Service 클래스를 묶어서
 *                  복잡한 비즈니스 로직을 처리합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 *
 */
@Service
@RequiredArgsConstructor
public class HospitalComplexService {
    private final HospitalService hospitalService;
    private final TokenService tokenService;
    private final DoctorService doctorService;

    /**
     * 동물병원 로그인 기능.
     * 요청된 account, password 정보로 Hospital 계정을 조회하고,
     * 일치하는 경우 JWT 토큰과 함께 응답합니다.
     * @param request 로그인 요청 정보
     * @return 로그인 성공 시 병원 정보 및 토큰 반환
     */
    @Transactional
    public HospitalLoginResponse login(HospitalLoginRequest request) {
        // 1. Hospital 관련 요청은 hospitalService 에게 넘김
        // 계정을 찾지 못하거나, 비밀번호 불일치는 모두 hospitalService 가 처리
        HospitalInfoResponse hospitalInfo = hospitalService.tryLogin(request);

        // 2. Token 관련 요청은 tokenService 에게 넘김
        JwtTokenPairResponse tokenPair = tokenService.generateTokens(hospitalInfo.getId(), RelatedType.HOSPITAL);

        return new HospitalLoginResponse(hospitalInfo, tokenPair);
    }

    /**
     * 동물병원 회원가입 기능.
     * @param request 회원가입 요청 정보
     * @return 회원가입 성공 시 병원 정보 반환
     * @throws ApiException 병원이 존재하지 않거나 중복된 계정 또는 라이센스일 경우 예외 발생
     */
    @Transactional
    public HospitalSignupResponse signup(HospitalSignupRequest request) {
        // 1. 동물병원 조회
        Hospital hospital = hospitalService.findHospitalById(request.getId());

        // 2. 동물병원 관련 요청은 hospitalService 에게 넘김
        HospitalSignupResponse signupResponse = hospitalService.trySignUp(hospital, request);

        // 3. 의사 관련 요청은 doctorService 에게 넘김
        DoctorRegisterRequest doctorRegisterRequest = new DoctorRegisterRequest(request.getDoctorName());
        doctorService.registerDoctor(hospital, doctorRegisterRequest);

        return signupResponse;
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
        Hospital hospital = hospitalService.findHospitalById(hospitalId);
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

}

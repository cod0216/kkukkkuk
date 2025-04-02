package com.be.KKUKKKUK.domain.hospital.service;

import com.be.KKUKKKUK.domain.auth.dto.request.*;
import com.be.KKUKKKUK.domain.auth.dto.response.AccountFindResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.domain.auth.service.TokenService;
import com.be.KKUKKKUK.domain.doctor.dto.request.DoctorRegisterRequest;
import com.be.KKUKKKUK.domain.doctor.dto.response.DoctorInfoResponse;
import com.be.KKUKKKUK.domain.doctor.service.DoctorService;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUnsubscribeRequest;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalInfoResponse;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.global.service.EmailService;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.service.RedisService;
import com.be.KKUKKKUK.global.util.RandomCodeUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.Duration;
import java.time.LocalDate;
import java.util.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.service<br>
 * fileName       : HospitalComplexService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Hospital entity 에 대한 상위 레벨의 Service 클래스입니다.<br>
 *                  HospitalService, TokenService, DoctorService 등 저수준 Service 클래스를 묶어서
 *                  복잡한 비즈니스 로직을 처리합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.17          haelim           Service Layer 계층화 <br>
 * 25.03.18          haelim           이메일 인증 관련 api 추가 <br>
 * 25.03.19          haelim           진료기록 관련 api 추가 <br>
 * 25.03.27          haelim           계정 찾기 api 추가 <br>
 * 25.03.28          haelim           진료 기록 관련 api 삭제 <br>
 * 25.04.04          haelim           동물병원 회원 탈퇴 api 추가 <br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class HospitalComplexService {
    /** 이메일 인증코드 Redis 접두어 **/
    private static final String EMAIL_AUTH_CODE_PREFIX = "EMAIL_AUTH_CODE:";
    /** 이메일 인증코드 길이 **/
    private static final Integer EMAIL_AUTH_CODE_LENGTH = 6;
    /** 재발급 비밀번호 길이 **/
    private static final Integer PASSWORD_LENGTH = 20 ;

    @Value("${spring.mail.auth-code-expiration-millis}")
    private Long authCodeExpirationMillis;

    private final EmailService mailService;
    private final TokenService tokenService;
    private final RedisService redisService;
    private final DoctorService doctorService;
    private final HospitalService hospitalService;

    private final PasswordEncoder passwordEncoder;

    /**
     * 동물병원 로그인 기능.
     * 요청된 account, password 정보로 Hospital 계정을 조회하고,
     * 일치하는 경우 JWT 토큰과 함께 응답합니다.
     * @param request 로그인 요청 정보
     * @return 로그인 성공 시 병원 정보 및 토큰 반환
     */
    public HospitalLoginResponse hospitalLogin(HospitalLoginRequest request) {
        HospitalInfoResponse hospitalInfo = hospitalService.tryHospitalLogin(request);

        JwtTokenPairResponse tokenPair = tokenService.generateTokens(hospitalInfo.getId(), hospitalInfo.getName(), RelatedType.HOSPITAL);

        return new HospitalLoginResponse(hospitalInfo, tokenPair);
    }

    /**
     * 동물병원 회원가입 기능.
     * @param request 회원가입 요청 정보
     * @return 회원가입 성공 시 병원 정보 반환
     * @throws ApiException 병원이 존재하지 않거나 중복된 계정 또는 라이센스일 경우 예외 발생
     */
    public HospitalSignupResponse hospitalSignup(HospitalSignupRequest request) {
        Hospital hospital = hospitalService.findHospitalById(request.getId());

        HospitalSignupResponse response = hospitalService.tryHospitalSignUp(hospital, request);

        DoctorRegisterRequest doctorRegisterRequest = new DoctorRegisterRequest(request.getDoctorName());
        doctorService.registerDoctor(hospital, doctorRegisterRequest);

        return response;
    }

    /**
     * 특정 동물병원에 수의사를 신규 등록합니다.
     * 동물 병원에 대한 요청만 처리하고, doctorService 로 요청을 넘깁니다.
     * @param hospitalId 등록 요청한 병원 ID
     * @param request 등록할 수의사 정보
     * @return 등록된 수의사 정보
     */
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

    /**
     * 회원가입 시, 이메일 인증을 위해 인증 코드를 발송합니다.
     * 랜덤 숫자로 이루어진 인증코드를 생성해서, 인증할 이메일로 코드를 발송합니다.
     * 인증 코드는 Redis 에 저장됩니다. ( key = "EMAIL_AUTH_CODE:" + Email / value = authCode )
     * @param request 이메일 전송 요청
     * @throws ApiException 이미 해당 이메일로 가입할 계정이 있는 경우 예외처리
     */
    public void sendEmailAuthCode(EmailSendRequest request) {
        String toEmail = request.getEmail();
        hospitalService.checkEmailAvailable(toEmail);

        String authCode = RandomCodeUtility.generateCode(EMAIL_AUTH_CODE_LENGTH);
        mailService.sendVerificationEmail(toEmail, authCode);

        redisService.setValues(EMAIL_AUTH_CODE_PREFIX + toEmail,
                authCode, Duration.ofMillis(authCodeExpirationMillis));
    }

    /**
     * 회원가입 시 이메일 인증을 위해 발송했던 인증 코드를 확인합니다.
     * 사용자에게 이메일로 전송한 인증코드와 사용자가 입력한 코드를 비교해서 인증 성공 여부를 반환합니다.
     * @param email 인증할 이메일
     * @param code 사용자가 입력한 인증코드
     * @throws ApiException 인증 코드가 만료된 경우 예외처리
     * @throws ApiException 인증 코드가 일치하지 않는 경우 예외처리
     */
    @Transactional(readOnly = true)
    public void checkEmailCodeValid(String email, String code) {
        hospitalService.checkEmailAvailable(email);

        String redisAuthCode = redisService.getValues(EMAIL_AUTH_CODE_PREFIX + email);
        if (Objects.isNull(redisAuthCode)) {
            throw new ApiException(ErrorCode.AUTH_CODE_EXPIRED);
        }
        if (!redisAuthCode.equals(code)) {
            throw new ApiException(ErrorCode.AUTH_CODE_NOT_MATCHED);
        }

        redisService.deleteValues(EMAIL_AUTH_CODE_PREFIX + email);
    }


    /**
     * 비밀번호 재발급 시, 이메일 인증을 위해 인증 코드를 발송합니다.
     * 랜덤 숫자로 이루어진 인증코드를 생성해서, 인증할 이메일로 코드를 발송합니다.
     * 인증 코드는 Redis 에 저장됩니다. ( key = "PASSWORD_AUTH_CODE:" + Email / value = authCode )
     * @param request 비밀번호 초기화 요청
     * @throws ApiException 계정과 이메일 정보가 일치하지 않는 경우 예외처리
     */
    public void resetPassword(PasswordResetRequest request) {
        final String email = request.getEmail();
        Hospital hospital = hospitalService.findHospitalByAccount(request.getAccount());

        if(!hospital.getEmail().equals(email)) {
            throw new ApiException(ErrorCode.EMAIL_NOT_MATCHED);
        }

        String newPassword = RandomCodeUtility.generatePassword(PASSWORD_LENGTH);

        hospital.setPassword(passwordEncoder.encode(newPassword));
        hospitalService.saveHospital(hospital);

        mailService.sendPasswordResetEmail(email, newPassword);
    }

    /**
     * 사용자의 계정 찾기 요청을 처리합니다.
     * @param request 계정 찾기 요청
     * @return 조회된 계정 정보
     */
    public AccountFindResponse findHospitalAccount(AccountFindRequest request) {
        return hospitalService.findHospitalAccount(request);
    }

    /**
     * 동물병원 회원을 탈퇴합니다.
     * 비밀번호가 일치하지 않으면 탈퇴할 수 없습니다.
     * 동물 병원에 가입된 의사 정보는 모두 영구적으로 삭제됩니다.
     * @param hospitalId 탈퇴할 동물병원 ID
     * @param request 삭제 요청
     */
    public void unSubscribeHospital(Integer hospitalId, HospitalUnsubscribeRequest request) {
        Hospital hospital = hospitalService.findHospitalById(hospitalId);

        hospitalService.checkPasswordMatch(request.getPassword(), hospital);

        doctorService.deleteDoctorsAllFromHospital(hospitalId);

        resetHospital(hospital);

        hospitalService.saveHospital(hospital);
    }

    /**
     * 동물병원 회원 계정을 가입 전으로 초기화합니다.
     * 초기화된 시점을 기준으로 DeleteDate 가 설정됩니다.
     * @param hospital 초기화할 동물병원 entity
     */
    private void resetHospital(Hospital hospital){
        hospital.setFlagCertified(false);

        hospital.setAccount(null);
        hospital.setPassword(null);
        hospital.setEmail(null);
        hospital.setDoctorName(null);
        hospital.setDid(null);

        hospital.setDeleteDate(LocalDate.now());
    }
}

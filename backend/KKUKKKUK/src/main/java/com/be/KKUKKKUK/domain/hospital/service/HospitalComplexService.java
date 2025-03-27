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
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.dto.request.RegisterTreatmentRequest;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalInfoResponse;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.domain.pet.service.PetService;
import com.be.KKUKKKUK.domain.treatment.TreatState;
import com.be.KKUKKKUK.domain.treatment.dto.response.TreatmentResponse;
import com.be.KKUKKKUK.domain.treatment.service.TreatmentService;
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

    private final HospitalService hospitalService;
    private final TokenService tokenService;
    private final DoctorService doctorService;
    private final EmailService mailService;
    private final RedisService redisService;
    private final PasswordEncoder passwordEncoder;
    private final PetService petService;
    private final TreatmentService treatmentService;

    @Value("${spring.mail.auth-code-expiration-millis}")
    private Long authCodeExpirationMillis;

    /**
     * 동물병원 로그인 기능.
     * 요청된 account, password 정보로 Hospital 계정을 조회하고,
     * 일치하는 경우 JWT 토큰과 함께 응답합니다.
     * @param request 로그인 요청 정보
     * @return 로그인 성공 시 병원 정보 및 토큰 반환
     */
    @Transactional
    public HospitalLoginResponse login(HospitalLoginRequest request) {
        // 1. Hospital 관련 요청은 hospitalService 에게 넘깁니다
        HospitalInfoResponse hospitalInfo = hospitalService.tryLogin(request);

        // 2. Token 관련 요청은 tokenService 에게 넘깁니다.
        JwtTokenPairResponse tokenPair = tokenService.generateTokens(hospitalInfo.getId(), hospitalInfo.getName(), RelatedType.HOSPITAL);

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
        // 1. ID 로 동물병원을 조회합니다.
        Hospital hospital = hospitalService.findHospitalById(request.getId());

        // 2. 동물병원 관련 요청은 hospitalService 에게 넘깁니다.
        HospitalSignupResponse signupResponse = hospitalService.trySignUp(hospital, request);

        // 3. 의사 관련 요청은 doctorService 에게 넘깁니다.
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


    /**
     * 회원가입 시, 이메일 인증을 위해 인증 코드를 발송합니다.
     * 랜덤 숫자로 이루어진 인증코드를 생성해서, 인증할 이메일로 코드를 발송합니다.
     * 인증 코드는 Redis 에 저장됩니다. ( key = "EMAIL_AUTH_CODE:" + Email / value = authCode )
     * @param request 이메일 전송 요청
     * @throws ApiException 이미 해당 이메일로 가입할 계정이 있는 경우 예외처리
     */
    @Transactional
    public void sendEmailAuthCode(EmailSendRequest request) {
        String toEmail = request.getEmail();
        // 1. 이메일 중복체크
        if(Boolean.FALSE.equals(hospitalService.checkEmailAvailable(toEmail))) throw new ApiException(ErrorCode.EMAIL_DUPLICATED);

        // 2. 인증코드 생성
        String authCode = RandomCodeUtility.generateCode(EMAIL_AUTH_CODE_LENGTH);

        // 3. 인증 코드 발송
        mailService.sendVerificationEmail(toEmail, authCode);

        // 4. 인증 번호 Redis에 저장
        redisService.setValues(EMAIL_AUTH_CODE_PREFIX + toEmail,
                authCode, Duration.ofMillis(authCodeExpirationMillis));
    }

    /**
     * 회원가입 시 이메일 인증을 위해 발송했던 인증 코드를 확인합니다.
     * 사용자에게 이메일로 전송한 인증코드와 사용자가 입력한 코드를 비교해서 인증 성공 여부를 반환합니다.
     * @param email 인증할 이메일
     * @param code 사용자가 입력한 인증코드
     * @throws ApiException 이미 해당 이메일로 가입한 계정이 있는 경우 예외처리
     * @throws ApiException 인증 코드가 만료된 경우 예외처리
     * @throws ApiException 인증 코드가 일치하지 않는 경우 예외처리
     */
    @Transactional(readOnly = true)
    public void checkEmailCodeValid(String email, String code) {
        // 1. 이메일이 유효한지 체크, 중복이면 가입 불가하기 때문에 예외처리
        if(Boolean.FALSE.equals(hospitalService.checkEmailAvailable(email))) throw new ApiException(ErrorCode.EMAIL_DUPLICATED);

        // 2. Redis 에 저장된 인증 코드 조회
        String redisAuthCode = redisService.getValues(EMAIL_AUTH_CODE_PREFIX + email);
        if (Objects.isNull(redisAuthCode)) throw new ApiException(ErrorCode.AUTH_CODE_EXPIRED);

        // 3. 사용자가 입력한 인증 코드와 저장된 인증 코드 비교
        if (!redisAuthCode.equals(code)) throw new ApiException(ErrorCode.AUTH_CODE_NOT_MATCH);

        // 4. 인증 완료한 인증코드 삭제
        redisService.deleteValues(EMAIL_AUTH_CODE_PREFIX + email);
    }


    /**
     * 비밀번호 재발급 시, 이메일 인증을 위해 인증 코드를 발송합니다.
     * 랜덤 숫자로 이루어진 인증코드를 생성해서, 인증할 이메일로 코드를 발송합니다.
     * 인증 코드는 Redis 에 저장됩니다. ( key = "PASSWORD_AUTH_CODE:" + Email / value = authCode )
     * @param request 비밀번호 초기화 요청
     * @throws ApiException 계정과 이메일 정보가 일치하지 않는 경우 예외처리
     */
    @Transactional
    public void resetPassword(PasswordResetRequest request) {
        final String email = request.getEmail();
        // 1. 계정 정보로 병원 entity 찾기
        Hospital hospital = hospitalService.findHospitalByAccount(request.getAccount());

        // 2. 이메일 정보가 일치하지 않는 경우 예외처리
        if(!hospital.getEmail().equals(email)) throw new ApiException(ErrorCode.EMAIL_NOT_MATCH);

        // 3. 신규 비밀번호 생성
        String newPassword = RandomCodeUtility.generatePassword(PASSWORD_LENGTH);

        // 4. 신규 비밀번호 저장
        hospital.setPassword(passwordEncoder.encode(newPassword));
        hospitalService.saveHospital(hospital);

        // 5. 메일로 임시 비밀번호 발송
        mailService.sendPasswordResetEmail(email, newPassword);
    }

    /**
     * 특정 동물병원에 새로운 진료를 등록합니다.
     * @param ownerDetails 진료를 요청한 보호자(Owner) ID
     * @param hospitalId 진료 요청할 동물병원 ID
     * @param petId 진료 요청할 Pet ID
     * @param request 새로운 진료 요청 DTO
     * @return 등록된 진료 정보
     */
    public TreatmentResponse registerTreatment(OwnerDetails ownerDetails, Integer hospitalId, Integer petId, RegisterTreatmentRequest request) {
        // 1. 진료 등록할 병원 찾기
        Hospital hospital = hospitalService.findHospitalById(hospitalId);

        // 2. 진료 등록할 반려동물 찾기
        Pet pet = petService.findPetById(petId);

        // 3. 진료 등록할 권한 체크 (요청 보낸 사람이 반려동물의 주인인지 확인)
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        if(!Objects.equals(ownerId, pet.getWallet().getOwner().getId())) throw new ApiException(ErrorCode.PET_NOT_ALLOW);

        return treatmentService.registerTreatment(hospital, pet, request);
    }


    /**
     * 현재 로그인한 동물병원의 진료 기록을 조회합니다.
     * 쿼리 스트링 값에 따라 데이터를 필터링하고, pet ID 를 기준으로 그룹화해서 조회합니다.
     * @param hospitalDetails 인증된 병원 회원
     * @param flagExpired 만료된 기록 조회 여부
     * @return 조회된 진료 기록
     */
    public List<TreatmentResponse> getTreatmentMine(
            HospitalDetails hospitalDetails, Boolean flagExpired, TreatState state, Integer petId) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return treatmentService.getFilteredTreatmentByHospitalId(hospitalId, flagExpired, state, petId);
    }

    /**
     * 사용자의 계정 찾기 요청을 처리합니다.
     * @param request 계정 찾기 요청
     * @return 조회된 계정 정보
     */
    public AccountFindResponse findAccount(AccountFindRequest request) {
        return hospitalService.findHospitalAccount(request);
    }




}

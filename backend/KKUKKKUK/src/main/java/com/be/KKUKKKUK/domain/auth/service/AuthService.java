package com.be.KKUKKKUK.domain.auth.service;

import com.be.KKUKKKUK.domain.auth.dto.request.*;
import com.be.KKUKKKUK.domain.auth.dto.response.*;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.service.HospitalComplexService;
import com.be.KKUKKKUK.domain.owner.service.OwnerComplexService;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import jakarta.servlet.http.HttpServletRequest;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Service;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.service<br>
 * fileName       : AuthService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 인증에 대한 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.18          haelim           이메일 인증 api 추가<br>
 * 25.03.20          haelim           로그아웃시 엑세스 토큰 블랙리스트에 추가<br>
 * 25.03.27          haelim           계정 찾기 API 추가, JWT 토큰에 name 추가 <br>
 */
@Service
@RequiredArgsConstructor
public class AuthService {
    private final HospitalComplexService hospitalComplexService;
    private final OwnerComplexService ownerComplexService;
    private final TokenService tokenService;

    /**
     * 보호자 로그인을 수행합니다.
     *
     * @param request 보호자 로그인 요청 정보
     * @return 보호자 로그인 응답 객체
     */
    public OwnerLoginResponse ownerLogin(OwnerLoginRequest request) {
        return ownerComplexService.loginOrSignup(request);
    }

    /**
     * 동물병원 로그인을 수행합니다.
     *
     * @param request 동물병원 로그인 요청 정보
     * @return 동물병원 로그인 응답 객체
     */
    public HospitalLoginResponse hospitalLogin(HospitalLoginRequest request) {
        return hospitalComplexService.login(request);
    }

    /**
     * 동물병원 회원가입을 수행합니다.
     *
     * @param request 동물병원 회원가입 요청 정보
     * @return 동물병원 회원가입 응답 객체
     */
    public HospitalSignupResponse hospitalSignup(HospitalSignupRequest request) {
        return hospitalComplexService.signup(request);
    }


    /**
     * 액세스 토큰을 갱신합니다.
     *
     * @param request 리프레시 토큰 요청 객체
     * @return 새로운 액세스 토큰과 기존 리프레시 토큰을 포함하는 응답 객체
     */
    public JwtTokenPairResponse refreshAccessToken(HttpServletRequest request){
        return tokenService.refreshAccessToken(request);
    }

    /**
     * 사용자를 로그아웃시킵니다.
     * 사용자 정보에서 사용자의 type (동물병원, 보호자)을 구분하여 요청을 처리합니다.
     *
     * @param userDetails 현재 인증된 사용자 정보
     */
    public void logout(UserDetails userDetails, HttpServletRequest request) {
        int userId = Integer.parseInt(userDetails.getUsername());
        RelatedType type = (userDetails instanceof HospitalDetails) ? RelatedType.HOSPITAL : RelatedType.OWNER;

        tokenService.deleteRefreshToken(userId, type);
        tokenService.blacklistAccessToken(request);
    }

    /**
     * 회원가입 시, 이메일 인증을 위해 인증 코드를 발송합니다.
     * 랜덤 숫자로 이루어진 인증코드를 생성해서, 인증할 이메일로 코드를 발송합니다.
     * @param request 인증할 이메일
     */
    public void sendEmailAuthCode(EmailSendRequest request){
        hospitalComplexService.sendEmailAuthCode(request);
    }

    /**
     * 회원가입 시 이메일 인증을 위해 발송했던 인증 코드를 확인합니다.
     * 사용자에게 이메일로 전송한 인증코드와 사용자가 입력한 코드를 비교해서 인증 성공 여부를 반환합니다.
     * @param request 이메일 인증 요청
     */
    public void checkEmailCodeValid(EmailVerificationRequest request) {
        hospitalComplexService.checkEmailCodeValid(request.getEmail(), request.getCode());
    }

    /**
     * 비밀번호를 초기화하고 이메일로 발급받습니다.
     * @param request 비밀번호 초기화 요청
     */
    public void resetPassword(PasswordResetRequest request) {
        hospitalComplexService.resetPassword(request);
    }

    /**
     * 이메일로 사용자의 회원가입 계정을 찾습니다.
     * @param request 이메일이 포함된 계정 찾기 요청
     * @return 사용자의 계정 찾기 응답 객체
     */
    public AccountFindResponse findAccount(AccountFindRequest request) {
        return hospitalComplexService.findAccount(request);
    }
}

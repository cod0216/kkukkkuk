package com.be.KKUKKKUK.domain.auth.controller;

import com.be.KKUKKKUK.domain.auth.dto.request.*;
import com.be.KKUKKKUK.domain.auth.service.AuthService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.web.bind.annotation.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.controller<br>
 * fileName       : AuthController.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 인증 관련 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.18          haelim           이메인 인증 api 추가<br>
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auths")
public class AuthController {
    private final AuthService authService;

    /** 보호자 회원의 로그인 api **/
    @PostMapping("/owners/kakao/login")
    public ResponseEntity<?> ownerLogin(@Valid @RequestBody OwnerLoginRequest request) {
        return ResponseUtility.success("현재 로그인한 보호자 회원의 토큰 정보입니다.", authService.ownerLogin(request));

    }

    /** 동물병원 회원의 로그인 api **/
    @PostMapping("/hospitals/login")
    public ResponseEntity<?> hospitalLogin(@Valid @RequestBody HospitalLoginRequest request) {
        return ResponseUtility.success("동물병원 로그인이 완료되었습니다.", authService.hospitalLogin(request));
    }

    /** 동물병원 회원의 회원가입 api **/
    @PostMapping("/hospitals/signup")
    public ResponseEntity<?> hospitalSignup(@Valid @RequestBody HospitalSignupRequest request) {
        return ResponseUtility.success( "동물병원 회원가입이 완료되었습니다.", authService.hospitalSignup(request));
    }

    /**
     * 리프레시 토큰으로 새로운 액세스 토큰을 발급받습니다.
     */
    @PostMapping("/refresh")
    public ResponseEntity<?> refreshAccessToken(HttpServletRequest request) {
        return ResponseUtility.success("액세스 토큰 재발급이 완료되었습니다.", authService.refreshAccessToken(request));
    }

    /**
     * 공통 로그아웃 api
     */
    @PostMapping("/logout")
    public ResponseEntity<?> logout(@AuthenticationPrincipal UserDetails userDetails){
        return ResponseUtility.success("로그아웃이 성공적으로 처리되었습니다.", authService.logout(userDetails));
    }

    /**
     * 회원가입을 위한 이메일 인증을 위해 인증 번호를 발송합니다.
     */
    @PostMapping("/emails/send")
    public ResponseEntity<?> sendEmailAuthCode(@RequestBody @Valid EmailSendRequest request) {
        authService.sendEmailAuthCode(request);
        return ResponseUtility.success("이메일이 성공적으로 전송되었습니다.",null);
    }

    /**
     * 회원가입을 위한 이메일 인증을 위해 발송했던 인증 번호를 확인합니다.
     */
    @PostMapping("/emails/verify")
    public ResponseEntity<?> verifyEmail(@RequestBody @Valid EmailVerificationRequest request) {
        authService.checkEmailCodeValid(request);
        return ResponseUtility.success("이메일 인증이 성공적으로 완료되었습니다.", null);
    }
}

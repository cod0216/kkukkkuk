package com.be.KKUKKKUK.domain.auth.controller;

import com.be.KKUKKKUK.domain.auth.dto.request.*;
import com.be.KKUKKKUK.domain.auth.service.AuthService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
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
 * 25.03.18          haelim           이메일 인증 api 추가<br>
 * 25.03.22          haelim           swagger 추가<br>
 * 25.03.27          haelim           계청 찾기 api 추가<br>
 */
@Tag(name = "인증 API", description = "회원 로그인, 회원가입, 로그아웃, 토큰 재발급 등의 기능을 제공합니다.")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/auths")
public class AuthController {
    private final AuthService authService;

    /** 보호자 회원의 로그인 api **/
    @Operation(summary = "보호자 로그인", description = "카카오 로그인 방식으로 보호자 회원이 로그인합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "로그인 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "401", description = "인증 실패")
    })
    @PostMapping("/owners/kakao/login")
    public ResponseEntity<?> ownerLogin(
            @Valid @RequestBody OwnerLoginRequest request) {
        return ResponseUtility.success("현재 로그인한 보호자 회원의 토큰 정보입니다.", authService.ownerLogin(request));
    }

    /** 동물병원 회원의 로그인 api **/
    @Operation(summary = "동물병원 회원 로그인", description = "동물병원 회원이 로그인합니다.")
    @PostMapping("/hospitals/login")
    public ResponseEntity<?> hospitalLogin(
            @Valid @RequestBody HospitalLoginRequest request) {
        return ResponseUtility.success("동물병원 로그인이 완료되었습니다.", authService.hospitalLogin(request));
    }

    /** 동물병원 회원의 회원가입 api **/
    @Operation(summary = "동물병원 회원가입", description = "동물병원 회원이 회원가입합니다.")
    @PostMapping("/hospitals/signup")
    public ResponseEntity<?> hospitalSignup(
            @Valid @RequestBody HospitalSignupRequest request) {
        return ResponseUtility.success("동물병원 회원가입이 완료되었습니다.", authService.hospitalSignup(request));
    }

    /**
     * 리프레시 토큰으로 새로운 액세스 토큰을 발급받습니다.
     */
    @Operation(summary = "액세스 토큰 재발급", description = "리프레시 토큰을 이용해 새로운 액세스 토큰을 발급받습니다.")
    @PostMapping("/refresh")
    public ResponseEntity<?> refreshAccessToken(HttpServletRequest request) {
        return ResponseUtility.success("액세스 토큰 재발급이 완료되었습니다.", authService.refreshAccessToken(request));
    }

    /**
     * 공통 로그아웃 api
     */
    @Operation(summary = "로그아웃", description = "로그아웃을 수행합니다.")
    @PostMapping("/logout")
    public ResponseEntity<?> logout(
            @AuthenticationPrincipal UserDetails userDetails,
            HttpServletRequest request) {
        authService.logout(userDetails, request);
        return ResponseUtility.success("로그아웃이 성공적으로 처리되었습니다.", null);
    }

    /**
     * 회원가입을 위한 이메일 인증을 위해 인증 번호를 발송합니다.
     */
    @Operation(summary = "이메일 인증 코드 발송", description = "회원가입을 위해 이메일 인증 코드를 발송합니다.")
    @PostMapping("/emails/send")
    public ResponseEntity<?> sendEmailAuthCodeForEmail(
            @RequestBody @Valid EmailSendRequest request) {
        authService.sendEmailAuthCode(request);
        return ResponseUtility.success("이메일 인증을 위한 코드가 발송되었습니다.", null);
    }

    /**
     * 회원가입을 위한 이메일 인증을 위해 발송했던 인증 번호를 확인합니다.
     */
    @Operation(summary = "이메일 인증 코드 검증", description = "발송된 인증 코드를 확인합니다.")
    @PostMapping("/emails/verify")
    public ResponseEntity<?> verifyEmail(
            @RequestBody @Valid EmailVerificationRequest request) {
        authService.checkEmailCodeValid(request);
        return ResponseUtility.success("이메일 인증이 성공적으로 완료되었습니다.", null);
    }

    /**
     * 비밀번호를 초기화합니다.
     */
    @Operation(summary = "비밀번호 초기화", description = "비밀번호를 초기화하고 이메일로 전송합니다.")
    @PostMapping("/passwords/reset")
    public ResponseEntity<?> sendEmailAuthCodeForPassword(
            @RequestBody @Valid PasswordResetRequest request) {
        authService.resetPassword(request);
        return ResponseUtility.success("비밀번호가 이메일로 발송되었습니다.", null);
    }

    /**
     * 회원가입했던 계정을 찾습니다.
     */
    @Operation(summary = "계정 찾기", description = "이메일로 회원가입했던 계정 정보를 찾습니다.")
    @PostMapping("/accounts/find")
    public ResponseEntity<?> findAccount(
            @RequestBody @Valid AccountFindRequest request) {
        return ResponseUtility.success("계정 조회에 성공했습니다.", authService.findAccount(request));
    }
}

package com.be.KKUKKKUK.domain.auth.controller;

import com.be.KKUKKKUK.domain.auth.dto.request.HospitalLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.OwnerLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.RefreshTokenRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.RefreshTokenResponse;
import com.be.KKUKKKUK.domain.auth.service.AuthService;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.global.util.ApiResponse;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Controller;
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
 */

@RequiredArgsConstructor
@RequestMapping("/api/auth")
@Controller
@Slf4j
public class AuthController {
    private final AuthService authService;

    /** 보호자 로그인 **/
    @PostMapping("/owners/kakao/login")
    public ResponseEntity<?> ownerLogin(@Valid @RequestBody OwnerLoginRequest request) {
        log.info("OwnerLoginRequest: {}", request);
        return ResponseEntity.status(HttpStatus.OK).body(authService.ownerLogin(request));
    }

    /** 동물병원 로그인 **/
    @PostMapping("/hospitals/login")
    public ResponseEntity<?> hospitalLogin(@Valid @RequestBody HospitalLoginRequest request) {
        log.info("HospitalLoginRequest: {}", request);
        return ResponseUtility.success("현재 로그인한 동물병원 회원의 토큰 정보입니다.", authService.hospitalLogin(request));

    }

    /** 동물병원 회원가입 **/
    @PostMapping("/hospitals/signup")
    public ResponseEntity<?> hospitalSignup(@Valid @RequestBody HospitalSignupRequest request) {
        return ResponseUtility.success( "병원 회원가입이 완료되었습니다.", authService.hospitalSignup(request));
    }

    /**
     * 리프레시 토큰으로 새로운 액세스 토큰을 발급받습니다.
     */
    @PostMapping("/refresh")
    public ResponseEntity<?> refreshAccessToken(@Valid @RequestBody RefreshTokenRequest request) {
        return ResponseUtility.success("액세스 토큰 재발급이 완료되었습니다.", authService.refreshAccessToken(request));
    }

    @PostMapping("/logout")
    public ResponseEntity<?> logout(@AuthenticationPrincipal UserDetails userDetails){
        return ResponseUtility.success("로그아웃이 성공적으로 처리되었습니다.", authService.logout(userDetails));
    }

}

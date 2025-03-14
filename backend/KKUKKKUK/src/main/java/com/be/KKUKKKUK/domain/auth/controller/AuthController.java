package com.be.KKUKKKUK.domain.auth.controller;

import com.be.KKUKKKUK.domain.auth.dto.request.HospitalLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.OwnerLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.RefreshTokenRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.OwnerLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.RefreshTokenResponse;
import com.be.KKUKKKUK.domain.auth.service.AuthService;
import com.be.KKUKKKUK.global.api.ApiResponseWrapper;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
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
    @ApiResponseWrapper(message = "현재 로그인한 보호자 회원의 정보와 토큰 정보입니다.")
    @PostMapping("/owners/kakao/login")
    public ResponseEntity<OwnerLoginResponse> ownerLogin(@Valid @RequestBody OwnerLoginRequest request) {
        log.info("OwnerLoginRequest: {}", request);
        return ResponseEntity.status(HttpStatus.OK).body(authService.ownerLogin(request));
    }

    /** 동물병원 로그인 **/
    @ApiResponseWrapper(message = "현재 로그인한 동물병원 회원의 토큰 정보입니다.")
    @PostMapping("/hospitals/login")
    public ResponseEntity<HospitalLoginResponse> hospitalLogin(@Valid @RequestBody HospitalLoginRequest request) {
        log.info("HospitalLoginRequest: {}", request);
        return ResponseEntity.status(HttpStatus.OK).body(authService.hospitalLogin(request));
    }

    /** 동물병원 회원가입 **/
    @ApiResponseWrapper(message = "병원 회원가입이 완료되었습니다.", status = HttpStatus.OK)
    @PostMapping("/hospitals/signup")
    public ResponseEntity<?> hospitalSignup(@Valid @RequestBody HospitalSignupRequest request) {
        return ResponseEntity.ok(authService.hospitalSignup(request));
    }

    /**
     * 리프레시 토큰으로 새로운 액세스 토큰을 발급받습니다.
     */
    @ApiResponseWrapper(message = "액세스 토큰 재발급이 완료되었습니다.")
    @PostMapping("/refresh")
    public ResponseEntity<RefreshTokenResponse> refreshAccessToken(@Valid @RequestBody RefreshTokenRequest request) {
        log.info("RefreshTokenRequest: {}", request);
        return ResponseEntity.status(HttpStatus.OK).body(authService.refreshAccessToken(request));
    }



}

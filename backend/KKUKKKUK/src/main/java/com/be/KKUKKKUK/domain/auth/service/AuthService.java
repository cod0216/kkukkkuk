package com.be.KKUKKKUK.domain.auth.service;

import com.be.KKUKKKUK.domain.auth.dto.request.HospitalLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.OwnerLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.RefreshTokenRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.OwnerLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.RefreshTokenResponse;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.domain.owner.service.OwnerService;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
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
 */
@RequiredArgsConstructor
@Service
@Slf4j
public class AuthService {
    private final HospitalService hospitalService;
    private final OwnerService ownerService;
    private final TokenService tokenService;

    public OwnerLoginResponse ownerLogin(OwnerLoginRequest request) {
        return ownerService.loginOrSignup(request);
    }

    public HospitalLoginResponse hospitalLogin(HospitalLoginRequest request) {
        return hospitalService.login(request);
    }

    public HospitalSignupResponse hospitalSignup(HospitalSignupRequest request) {
        return hospitalService.signup(request);
    }

    public RefreshTokenResponse refreshAccessToken(RefreshTokenRequest request){
        return tokenService.refreshAccessToken(request);
    }
}

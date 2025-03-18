package com.be.KKUKKKUK.domain.auth.service;

import com.be.KKUKKKUK.domain.auth.dto.request.HospitalLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.OwnerLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.request.RefreshTokenRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalLoginResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.domain.auth.dto.response.OwnerLoginResponse;
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
     * @return 로그아웃 성공 여부 (항상 true 반환)
     */
    public boolean logout(UserDetails userDetails) {
        try {
            int userId = Integer.parseInt(userDetails.getUsername());
            RelatedType type = (userDetails instanceof HospitalDetails) ? RelatedType.HOSPITAL : RelatedType.OWNER;
            tokenService.deleteRefreshToken(userId, type);

            return true;
        } catch (NumberFormatException e) {
            return false;
        }
    }
}

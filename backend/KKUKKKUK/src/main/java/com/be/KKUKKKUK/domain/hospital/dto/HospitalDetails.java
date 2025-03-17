package com.be.KKUKKKUK.domain.hospital.dto;


import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto<br>
 * fileName       : HospitalDetails.java<br>
 * author         : haerim<br>
 * date           : 2025-03-13<br>
 * description    : Spring Security의 UserDetails를 구현한 Hospital 의 인증 정보 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 * <br>
 */
public class HospitalDetails implements UserDetails {
    private final Hospital hospital;

    public HospitalDetails(Hospital hospital) {
        this.hospital = hospital;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(new SimpleGrantedAuthority("ROLE_HOSPITAL"));
    }

    @Override
    public String getPassword() {
        return hospital.getPassword();  // 일반 로그인 사용
    }

    @Override
    public String getUsername() {
        return String.valueOf(hospital.getId());
    }

    @Override
    public boolean isAccountNonExpired() {
        return true;
    }

    @Override
    public boolean isAccountNonLocked() {
        return true;
    }

    @Override
    public boolean isCredentialsNonExpired() {
        return true;
    }

    @Override
    public boolean isEnabled() {
        return true;
    }
}
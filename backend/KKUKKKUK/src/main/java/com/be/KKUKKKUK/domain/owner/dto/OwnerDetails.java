package com.be.KKUKKKUK.domain.owner.dto;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import lombok.Getter;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;

import java.util.Collection;
import java.util.Collections;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.dto<br>
 * fileName       : OwnerDetails.java<br>
 * author         : haerim<br>
 * date           : 2025-03-13<br>
 * description    : Spring Security의 UserDetails를 구현한 Owner 의 인증 정보 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haerim           최초생성<br>
 * <br>
 */
public class OwnerDetails implements UserDetails {
    private final Owner owner;

    public OwnerDetails(Owner owner) {
        this.owner = owner;
    }

    @Override
    public Collection<? extends GrantedAuthority> getAuthorities() {
        return Collections.singletonList(new SimpleGrantedAuthority("ROLE_OWNER"));
    }

    @Override
    public String getPassword() {
        return null;  // 카카오 로그인이라 비밀번호 없음
    }

    @Override
    public String getUsername() {
        return owner.getId().toString();
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
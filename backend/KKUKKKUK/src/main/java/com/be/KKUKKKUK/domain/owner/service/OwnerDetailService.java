package com.be.KKUKKKUK.domain.owner.service;

import com.be.KKUKKKUK.domain.owner.dto.mapper.OwnerMapper;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.owner.repository.OwnerRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.stereotype.Service;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.service<br>
 * fileName       : OwnerDetailService.java<br>
 * author         : haerim<br>
 * date           : 2025-03-13<br>
 * description    : Spring Security의 UserDetailsService를 구현한 OwnerDetails 의 Service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haerim           최초생성<br>
 * <br>
 */
@Service
@RequiredArgsConstructor
public class OwnerDetailService implements UserDetailsService {
    private final OwnerRepository ownerRepository;
    private final OwnerMapper ownerMapper;

    @Override
    public UserDetails loadUserByUsername(String id) {
        Owner owner = ownerRepository.findById(Integer.parseInt(id))
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_TOKEN));
        return ownerMapper.mapToOwnerDetails(owner);
    }
}
package com.be.KKUKKKUK.domain.hospital.service;

import com.be.KKUKKKUK.domain.hospital.dto.mapper.HospitalMapper;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.hospital.repository.HospitalRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Component;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.service<br>
 * fileName       : HospitalDetailService.java<br>
 * author         : haerim<br>
 * date           : 2025-03-13<br>
 * description    : Spring Security의 UserDetailsService를 구현한 HospitalDetails 의 Service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haerim           최초생성<br>
 * <br>
 */
@Component
@RequiredArgsConstructor
public class HospitalDetailService implements UserDetailsService {
    private final HospitalRepository hospitalRepository;
    private final HospitalMapper hospitalMapper;

    @Override
    public UserDetails loadUserByUsername(String id) {
        Hospital hospital = hospitalRepository.findById(Integer.parseInt(id))
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_TOKEN));

        return hospitalMapper.mapToHospitalDetails(hospital);
    }
}

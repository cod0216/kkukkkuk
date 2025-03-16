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
    public UserDetails loadUserByUsername(String id) throws UsernameNotFoundException { //TODO 메서드 단에서 throw 를 던지는데 이게 맞을까요?? 이 메서드를 사용하는곳에서는 exception handling 을 하지 않는데 이 메서드 안에서 하는 건 어떨까요?
        Hospital hospital = hospitalRepository.findById(Integer.parseInt(id))
                .orElseThrow(() -> new ApiException(ErrorCode.INVALID_TOKEN));

        return hospitalMapper.hospitalToHospitalDetails(hospital);
    }
}

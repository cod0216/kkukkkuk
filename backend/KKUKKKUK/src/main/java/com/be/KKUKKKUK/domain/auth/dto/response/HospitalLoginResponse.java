package com.be.KKUKKKUK.domain.auth.dto.response;

import com.be.KKUKKKUK.domain.hospital.dto.HospitalInfo;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.response<br>
 * fileName       : HospitalLoginResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 동물병원 로그인을 위한 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */

@AllArgsConstructor
@Data
public class HospitalLoginResponse {
    private HospitalInfo hospital;
    private JwtTokenPairResponse tokens;
}

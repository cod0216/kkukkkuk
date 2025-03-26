package com.be.KKUKKKUK.domain.auth.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.response<br>
 * fileName       : HospitalSignupResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 동물병원 회원가입을 위한 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.26          haelim           email 추가<br>
 */
@Data
@AllArgsConstructor
public class HospitalSignupResponse {
    private String account;
    private Integer id;
    private String did;
    private String name;
    private String email;
}

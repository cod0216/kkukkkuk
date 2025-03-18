package com.be.KKUKKKUK.domain.hospital.dto.request;

import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto.request<br>
 * fileName       : PasswordUpdateRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-18<br>
 * description    : 동물병원 회원의 비밀번호 수정 요청을 처리하는 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.18          haelim           최초생성<br>
 */
@Getter
public class PasswordUpdateRequest {

    @NotEmpty
    @Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&])[A-Za-z\\d!@#$%^&]{6,20}$",
            message = "비밀번호는 6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합이어야 합니다.")
    private String password;

}

package com.be.KKUKKKUK.domain.auth.dto.request;

import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.request<br>
 * fileName       : HospitalLoginRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 동물병원 로그인 요청을 위한 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@Getter
@ToString
public class HospitalLoginRequest {
    @NotBlank(message = "계정은 필수로 입력해주세요.")
    @Pattern(regexp = "^[a-z0-9_]{5,10}$", message = "계정은 5~10자의 영문 소문자, 숫자, 밑줄(_)만 허용됩니다.")
    private String account;

    @NotBlank(message = "비밀번호는 필수로 입력해주세요.")
    @Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&])[A-Za-z\\d!@#$%^&]{6,20}$",
            message = "비밀번호는 6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합이어야 합니다.")
    private String password;
}

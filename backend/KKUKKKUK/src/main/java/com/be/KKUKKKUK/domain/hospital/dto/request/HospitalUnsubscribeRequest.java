package com.be.KKUKKKUK.domain.hospital.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto.request<br>
 * fileName       : HospitalUnsubscribeRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-04-01<br>
 * description    : 동물병원 회원 탈퇴 요청을 위한 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.04          haelim           최초 생성<br>
 */
@Getter
public class HospitalUnsubscribeRequest {
    @NotBlank
    @Schema(description = "비밀번호", example = "Apassword1234!")
    @Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&])[A-Za-z\\d!@#$%^&]{6,20}$",
            message = "6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합이어야 합니다.")
    private String password;
}

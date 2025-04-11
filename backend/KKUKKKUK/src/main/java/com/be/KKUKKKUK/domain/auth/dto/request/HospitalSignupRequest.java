package com.be.KKUKKKUK.domain.auth.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.request<br>
 * fileName       : HospitalSignupRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 동물병원 회원가입 요청을 위한 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.24          haelim           swagger, JsonNaming 설정<br>
 * 25.03.26          haelim           email 추가, did blank 삭제 <br>
 */

@Getter
@ToString
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class HospitalSignupRequest {
    @NotBlank
    @Schema(description = "계정", example = "ssafy1234")
    @Pattern(regexp = "^[a-z0-9_]{5,10}$", message = "5~10자의 영문 소문자, 숫자, 밑줄(_)만 허용됩니다.")
    private String account;

    @NotBlank
    @Schema(description = "비밀번호", example = "Apassword1234!")
    @Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&])[A-Za-z\\d!@#$%^&]{6,20}$",
            message = "6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합이어야 합니다.")
    private String password;

    @NotNull
    @Schema(description = "동물병원 고유 식별번호", example = "1")
    private Integer id;

    //    @NotBlank
    @Schema(description = "동물병원 DID", example = "hospital:0xexemplehospitaldid")
    private String did;

    @NotBlank
    @Schema(description = "의사 이름", example = "김닥터")
    private String doctorName;

    @Email
    @NotBlank
    @Schema(description = "이메일 주소", example = "test@example.com")
    private String email;
}

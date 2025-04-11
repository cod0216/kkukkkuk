package com.be.KKUKKKUK.domain.auth.dto.request;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.Getter;
import lombok.ToString;

import java.time.LocalDate;


/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.request<br>
 * fileName       : OwnerLoginRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : 보호자 로그인 / 회원가입 요청을 위한 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.24          haelim           swagger, JsonNaming 설정<br>
 */
@Getter
@ToString
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class OwnerLoginRequest {
    @NotBlank
    @Schema(description = "보호자 이름", example = "김길동")
    private String name;

    @Email
    @NotBlank
    @Schema(description = "이메일 주소", example = "test@example.com")
    private String email;

    @NotBlank
    @Schema(description = "출생년도", example = "2000")
    @Pattern(regexp = "\\d{4}", message = "출생년도는 2000 형식이어야 합니다.")
    private String birthyear;

    @NotBlank
    @Schema(description = "출생년도", example = "0310")
    @Pattern(regexp = "\\d{4}", message = "출생일은 0523 형식이어야 합니다.")
    private String birthday;

    @NotBlank
    @Schema(description = "카카오 식별 ID", example = "123451243")
    private String providerId;


    public Owner toOwnerEntity() {
        return Owner.builder()
                .name(name)
                .birth(LocalDate.of(
                        Integer.parseInt(birthyear),
                        Integer.parseInt(birthday.substring(0, 2)),
                        Integer.parseInt(birthday.substring(2))
                ))
                .email(email)
                .providerId(providerId)
                .build();
    }
}

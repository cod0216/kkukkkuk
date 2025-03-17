package com.be.KKUKKKUK.domain.auth.dto.request;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.Email;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Pattern;
import lombok.AllArgsConstructor;
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
 */
@Getter
@ToString
public class OwnerLoginRequest {
    @NotBlank
    private String name;

    @Email
    @NotBlank
    private String email;

    @NotBlank
    @Pattern(regexp = "\\d{4}", message = "출생연도은 1999 형식이어야 합니다.")
    private String birthyear; //TODO 스네이크 케이스로 수정해주세요

    @NotBlank
    @Pattern(regexp = "\\d{4}", message = "출생일은 0523 형식이어야 합니다.")
    private String birthday;

    @NotBlank
    @JsonProperty("provider_id")
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

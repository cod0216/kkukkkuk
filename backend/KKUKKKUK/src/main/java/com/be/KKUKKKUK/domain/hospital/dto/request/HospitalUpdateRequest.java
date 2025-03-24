package com.be.KKUKKKUK.domain.hospital.dto.request;
import com.fasterxml.jackson.annotation.JsonProperty;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotEmpty;
import jakarta.validation.constraints.Pattern;
import lombok.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto.request<br>
 * fileName       : HospitalUpdateRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    :  Hospital 수정 요청을 처리하는 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 * 25.03.24          haelim           swagger 작성, JsonNaming 설정<br>
 */


@Getter
@ToString
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class HospitalUpdateRequest {
    @Schema(description = "동물병원 DID", example = "hospital:0x9c8030a7b5e83919F83aa5aF82294FB4E1b816c4")
    private String did;

    @Schema(description = "동물병원 이름", example = "KKUK KKUK 동물병원")
    private String name;

    @Schema(description = "동물병원 전화번호", example = "000-0000-0000")
    private String phoneNumber;

    @Schema(description = "비밀번호", example = "Apassword1234!")
    @NotEmpty
    @Pattern(regexp = "^(?=.*[a-zA-Z])(?=.*\\d)(?=.*[!@#$%^&])[A-Za-z\\d!@#$%^&]{6,20}$",
            message = "비밀번호는 6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합이어야 합니다.")
    private String password;
}

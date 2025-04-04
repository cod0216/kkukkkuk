package com.be.KKUKKKUK.domain.doctor.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.Size;
import lombok.Getter;


/**
 * packageName    : com.be.KKUKKKUK.domain.doctor.dto.request<br>
 * fileName       : DoctorUpdateRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-17<br>
 * description    : Doctor 수정 요청을 처리하는 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.17          haelim           최초생성<br>
 * 25.03.24          haelim           swagger 작성<br>
 */

@Getter
public class DoctorUpdateRequest {
    @NotBlank
    @Size(min = 1, max = 30)
    @Schema(description = "의사 이름", example = "권닥터")
    private String name;
}

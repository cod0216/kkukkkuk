package com.be.KKUKKKUK.domain.doctor.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.NotBlank;
import lombok.AllArgsConstructor;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.doctor.dto.request<br>
 * fileName       : DoctorRegisterRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-15<br>
 * description    : Doctor 등록 요청을 처리하는 request DTO 클래스입니다.<br>
 *                  Hospital Service 에서 request 생성을 위해 AllArgsConstructor 추가하였습니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.15          haelim           최초생성<br>
 * 25.03.24          haelim           swagger 작성<br>
 */
//TODO 어노테이션 다 필요할까요?
@Getter
@ToString
@NoArgsConstructor
@AllArgsConstructor
public class DoctorRegisterRequest {
    @Schema(description = "의사 이름", example = "권닥터")
    @NotBlank
    private String name;
}

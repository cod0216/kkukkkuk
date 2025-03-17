package com.be.KKUKKKUK.domain.doctor.dto.request;

import jakarta.validation.constraints.NotBlank;
import lombok.Getter;
import lombok.NoArgsConstructor;
import lombok.ToString;


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
 */

@Getter
@ToString
@NoArgsConstructor
public class DoctorUpdateRequest {
    @NotBlank
    private String name;
}

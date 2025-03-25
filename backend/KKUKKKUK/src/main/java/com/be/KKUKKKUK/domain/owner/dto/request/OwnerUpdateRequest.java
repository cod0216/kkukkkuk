package com.be.KKUKKKUK.domain.owner.dto.request;

import io.swagger.v3.oas.annotations.media.Schema;
import lombok.Getter;
import lombok.ToString;

import java.time.LocalDate;

/**
 * packageName    :  com.be.KKUKKKUK.domain.owner.dto.request<br>
 * fileName       :  OwnerUpdateRequest.java<br>
 * author         :  haelim<br>
 * date           :  2025-03-17<br>
 * description    :  Owner 수정 요청을 처리하는 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.17          haelim           최초생성<br>
 * 25.03.24          haelim           swagger 작성<br>
 */
@Getter
@ToString
public class OwnerUpdateRequest {
    @Schema(description = "보호자 이름", example = "강길동")
    private String name;

    @Schema(description = "변경할 보호자 생년월일 (YYYY-MM-DD)", example = "2023-01-01")
    private LocalDate birth;
}

package com.be.KKUKKKUK.domain.vaccination.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.vaccination.dto.request<br>
 * fileName       : vaccinationRequest.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : vaccination의 Update Request 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Getter
@ToString
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class VaccinationRequest {
    @Size(min = 1, max = 100)
    private String name;
}

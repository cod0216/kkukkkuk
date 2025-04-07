package com.be.KKUKKKUK.domain.diagnosis.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import jakarta.validation.constraints.Size;
import lombok.Getter;
import lombok.ToString;

/**
 * packageName    : com.be.KKUKKKUK.domain.diagnosis.dto.request<br>
 * fileName       : DiagnosisUpdateRequest.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : Diagnosis의 Update Request 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Getter
@ToString
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class DiagnosisRequest {
    @Size(min = 1, max = 100) //TODO nullable 한 데이터인가요? 만약 빈칸도 허용되는 데이터 인가요?
    private String name;
}

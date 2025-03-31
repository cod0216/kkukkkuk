package com.be.KKUKKKUK.domain.hospital.dto.response;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto<br>
 * fileName       : HospitalInfo.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Hospital 엔터티의 요약 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class HospitalMapInfoResponse {
    private Integer id;

    private String name;

    private String phoneNumber;

    private String address;

    private BigDecimal xAxis;

    private BigDecimal yAxis;
}

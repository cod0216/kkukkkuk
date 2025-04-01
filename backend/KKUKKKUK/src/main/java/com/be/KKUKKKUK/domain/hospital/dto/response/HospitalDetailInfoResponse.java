package com.be.KKUKKKUK.domain.hospital.dto.response;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto<br>
 * fileName       : HospitalDetailInfoResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Hospital 엔터티의 상세 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.29          haelim           라이센스 삭제<br>
 */
@Data
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class HospitalDetailInfoResponse {
    private Integer id;

    private String name;

    private String phoneNumber;

    private String did;

    private String account;

    private String address;

    private String publicKey;

    private String authorizationNumber;

    private BigDecimal xAxis;

    private BigDecimal yAxis;

    private String doctorName;
}

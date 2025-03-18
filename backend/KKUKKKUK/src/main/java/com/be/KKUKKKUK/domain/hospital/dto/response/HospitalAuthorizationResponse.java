package com.be.KKUKKKUK.domain.hospital.dto.response;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto.response<br>
 * fileName       : HospitalAuthorizationResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    :  동물 병원의 인허가번호(authorizationNumber)로 Hospital 정보를 조회하는 요청에 대한 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 */
@Data
@AllArgsConstructor
public class HospitalAuthorizationResponse {
    private Integer id;
    private String name;
    @JsonProperty("phone_number")
    private String phoneNumber;
    private String address;
}

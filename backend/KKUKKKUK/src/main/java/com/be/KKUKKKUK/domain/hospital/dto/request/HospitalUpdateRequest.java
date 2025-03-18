package com.be.KKUKKKUK.domain.hospital.dto.request;
import com.fasterxml.jackson.annotation.JsonProperty;
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
 */

@Getter
@ToString
@AllArgsConstructor
public class HospitalUpdateRequest {
    private String did;

    private String name;

    @JsonProperty("phone_number")
    private String phoneNumber;

}

package com.be.KKUKKKUK.domain.hospital.dto.request;

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
@NoArgsConstructor
@AllArgsConstructor
@ToString
public class HospitalUpdateRequest {
    private String password;
    private String name;
}

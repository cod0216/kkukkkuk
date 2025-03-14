package com.be.KKUKKKUK.domain.hospital.dto.response;

import com.be.KKUKKKUK.domain.hospital.dto.HospitalInfo;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto.response<br>
 * fileName       : HospitalUpdateResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    :  Hospital 수정 요청을 처리하는 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 */
@Data
@AllArgsConstructor
public class HospitalUpdateResponse {
    private HospitalInfo hospital;
}

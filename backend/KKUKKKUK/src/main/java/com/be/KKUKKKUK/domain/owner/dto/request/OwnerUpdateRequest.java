package com.be.KKUKKKUK.domain.owner.dto.request;

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
 */
@Getter
@ToString
public class OwnerUpdateRequest {
    private String name;
    private LocalDate birth;
}

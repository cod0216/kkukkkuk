package com.be.KKUKKKUK.domain.owner.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.dto<br>
 * fileName       : OwnerShortInfoResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-28<br>
 * description    : Owner 엔터티의 가장 짧은 요약 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.28          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
public class OwnerShortInfoResponse {
    private Integer id;
    private String name;
    private String image;
}

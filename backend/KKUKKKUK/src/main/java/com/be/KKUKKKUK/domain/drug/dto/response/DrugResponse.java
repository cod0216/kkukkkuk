package com.be.KKUKKKUK.domain.drug.dto.response;

import lombok.Data;
/**
 * packageName    : com.be.KKUKKKUK.domain.drug.dto.response<br>
 * fileName       : DrugResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-04-01<br>
 * description    : Drug 엔터티의 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.01          eunchang           최초 생성<br>
 */

@Data
public class DrugResponse {
    private Integer id;
    private String nameKr;
    private String nameEn;
    private String applyAnimal;
}
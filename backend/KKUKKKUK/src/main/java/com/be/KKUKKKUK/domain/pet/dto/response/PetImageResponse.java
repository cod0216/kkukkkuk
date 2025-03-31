package com.be.KKUKKKUK.domain.pet.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.dto<br>
 * fileName       : PetImageResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-30<br>
 * description    : 반려동물 이미지 수정 요청에 응답하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.30          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
public class PetImageResponse {
    private String image;
}

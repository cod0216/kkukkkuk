package com.be.KKUKKKUK.domain.ocr.dto.response;


import lombok.AllArgsConstructor;
import lombok.Data;
/**
 * packageName    : com.be.KKUKKKUK.domain.ocr.dto.response<br>
 * fileName       : OcrDetail.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-02<br>
 * description    : Ocr파싱 결과를 반환하는 하위 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.03          eunchang           최초 생성<br>
 */
@Data
@AllArgsConstructor
public class OcrDetail {
    String type;
    String key;
    String value;
}

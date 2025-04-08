package com.be.KKUKKKUK.domain.ocr.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

import java.util.Collections;
import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.ocr.dto.response<br>
 * fileName       : EmptyResponse.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-08<br>
 * description    : Ocr 파싱 빈 결과를 반환하는 EmptyResponse DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.08          eunchang           최초 생성<br>
 */


@Data
@NoArgsConstructor
public class EmptyResponse extends Response {
    private String date = "";
    private String diagnosis = "";
    private String notes = "";
    private String doctorName = "";
    private String hospitalName = "";
    private List<OcrDetail> examinations = Collections.emptyList();
    private List<OcrDetail> medications = Collections.emptyList();
    private List<OcrDetail> vaccinations = Collections.emptyList();
}

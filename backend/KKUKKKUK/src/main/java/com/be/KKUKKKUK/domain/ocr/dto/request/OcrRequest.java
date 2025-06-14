package com.be.KKUKKKUK.domain.ocr.dto.request;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.*;

import java.util.Comparator;
import java.util.Map;

/**
 * packageName    : com.be.KKUKKKUK.domain.ocr.dto.request<br>
 * fileName       : OcrRequest.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-02<br>
 * description    : 모바일에서 Ocr파싱된 문자열을 반환하는 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.02          eunchang           최초 생성<br>
 * 25.04.05          eunchang           에노테이션 제거<br>
 */

@Getter
public class OcrRequest {
    private String text;
}

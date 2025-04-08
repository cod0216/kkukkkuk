package com.be.KKUKKKUK.domain.ocr.dto.mapper;

import com.be.KKUKKKUK.domain.ocr.dto.response.OcrResponse;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * packageName    : com.be.KKUKKKUK.domain.ocr.dto.mapper<br>
 * fileName       : OcrMapper.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-03<br>
 * description    : OcrMapper 클래스는 GPT API로부터 받은 JSON 문자열을 OcrResponse 객체로 매핑합니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.03          eunchang           최초 생성<br>
 */

@Component
@RequiredArgsConstructor
public class OcrMapper {

    private final ObjectMapper objectMapper;

    /**
     * GPT 결과 문자열을 OcrResponse 객체로 변환합니다.
     *
     * @param gptResult GPT API로부터 받은 응답 JSON 문자열
     * @return 매핑된 OcrResponse 객체
     * @throws ApiException GTP 결과가 RequestDTO와 매핑되지 않을 경우 예외 처리
     */
    public OcrResponse toOcrResponse(String gptResult) {
        try {
            return objectMapper.readValue(gptResult, OcrResponse.class);
        } catch (Exception e) {
            throw new ApiException(ErrorCode.GPT_MAPPER_ERROR);
        }
    }
}

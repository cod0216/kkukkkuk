package com.be.KKUKKKUK.domain.ocr.dto.mapper;

import com.be.KKUKKKUK.domain.ocr.dto.response.OcrResponse;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Component;

/**
 * OcrMapper 클래스는 GPT API로부터 받은 JSON 문자열을 OcrResponse 객체로 매핑합니다.
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
     */
    public OcrResponse toOcrResponse(String gptResult) {
        try {
            return objectMapper.readValue(gptResult, OcrResponse.class);
        } catch (Exception e) {
            throw new RuntimeException("GPT 결과를 OcrResponse로 매핑하는 데 실패했습니다.", e);
        }
    }
}

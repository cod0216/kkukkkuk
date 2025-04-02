package com.be.KKUKKKUK.domain.ocr.service;

import com.be.KKUKKKUK.domain.ocr.client.OpenAiApiClient;
import com.be.KKUKKKUK.domain.ocr.dto.mapper.OcrMapper;
import com.be.KKUKKKUK.domain.ocr.dto.request.OcrRequest;
import com.be.KKUKKKUK.domain.ocr.dto.response.OcrResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

/**
 * packageName    : com.be.KKUKKKUK.domain.ocr.service<br>
 * fileName       : OcrService.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-02<br>
 * description    : ocr 요청을 처리하는 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.02          eunchang           최초 생성<br>
 */

@Service
@RequiredArgsConstructor
public class OcrService {

    private final OpenAiApiClient openAiApiClient;
    private final OcrMapper ocrMapper;

    /**
     *
     *
     * @param request OCR 요청 DTO
     * @return 파싱된 결과 OcrResponse DTO
     */
    public OcrResponse getOcrResult(OcrRequest request) {
        String prompt = ocrMapper.buildPromptFromOcrText(request.getText());
        String aiOutput = openAiApiClient.callOpenAi(prompt);
        return ocrMapper.extractResponse(aiOutput);
    }

}

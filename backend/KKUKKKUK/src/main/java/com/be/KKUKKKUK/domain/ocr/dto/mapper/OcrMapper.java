package com.be.KKUKKKUK.domain.ocr.dto.mapper;

import com.be.KKUKKKUK.domain.ocr.dto.response.OcrResponse;
import org.springframework.stereotype.Component;

import java.util.Arrays;

@Component
public class OcrMapper {

    /**
     * orc된 텍스트를 포함한 프롬프트를 생성합니다.
     * 
     * @param ocrText ocr 된 텍스트
     * @return orc 텍스트가 포함된 프롬프트
     */
    public String buildPromptFromOcrText(String ocrText) {
        return """
               다음은 동물병원 진료 문서의 OCR 텍스트입니다:
               
               ---
               %s
               ---
               
               아래의 템플릿 형식으로 정리해 주세요. (추측 없이, 문서에 나온 데이터만 사용)
               
               날짜: 진료 날짜나 처방이 이루어진 날짜를 명확히 적습니다.
               
               진단: 병원에서 명시한 진단명이 있다면 그대로 적고, 없을 경우 검사 내역을 기반으로 유추 가능한 진단명을 적습니다 (※ 명시되지 않은 경우는 "명시되지 않음"으로 표기 가능). **이 템플릿에는 보내준 데이터만 들어가고 추측해서는 안 됩니다.**
               
               처방: 검사명, 약물 처방, 접종 등이 이 항목에 들어갑니다. 항목별로 한 줄씩 구분해서 정리합니다.
               
               증상: 보호자나 수의사가 기록한 증상이 있으면 입력합니다. 문서에 명시되어 있지 않다면 "기록 없음"으로 표기할 수 있습니다. **이 템플릿에는 보내준 데이터만 들어가고 추측해서는 안 됩니다.**
               """.formatted(ocrText);
    }

    /**
     * 추출된 결과를 반환합니다.
     *
     * @param aiOutput 프롬프트로 생성된 결과값
     * @return 템플릿에 맞게 넣어진 결과값
     */
    public OcrResponse extractResponse(String aiOutput) {
        // 간단한 정규식 파싱 또는 OpenAI 결과를 line-by-line 파싱
        String[] lines = aiOutput.split("\n");

        String date = extractField(lines, "날짜:");
        String diagnosis = extractField(lines, "진단:");
        String prescription = extractField(lines, "처방:");
        String symptoms = extractField(lines, "증상:");

        return new OcrResponse(date, diagnosis, prescription, symptoms);
    }

    /**
     * AI 응답 결과에 각 항목의 결과값들을 반환합니다.
     *
     * @param lines  라인들
     * @param prefix 파싱할 단어 
     * @return 라인 결과값
     */
    private String extractField(String[] lines, String prefix) {
        return Arrays.stream(lines)
                .filter(line -> line.startsWith(prefix))
                .map(line -> line.replace(prefix, "").trim())
                .findFirst()
                .orElse("없음");
    }
}

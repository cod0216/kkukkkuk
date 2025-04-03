package com.be.KKUKKKUK.domain.ocr.service;

import com.be.KKUKKKUK.domain.ocr.client.OpenAiApiClient;
import com.be.KKUKKKUK.domain.ocr.dto.mapper.OcrMapper;
import com.be.KKUKKKUK.domain.ocr.dto.request.OcrRequest;
import com.be.KKUKKKUK.domain.ocr.dto.response.OcrResponse;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;

@Service
@RequiredArgsConstructor
public class OcrService {

    private final OpenAiApiClient openAiApiClient;
    private final OcrMapper ocrMapper;


    private static final String prompt =
            "너는 의료 기록 전문가이자 OCR 파싱 전문가다. 반드시 아래 규칙에 따라 순수 JSON을 생성하라:\n\n" +
                    "1) 입력 데이터에 존재하는 내용만을 바탕으로 JSON 구조를 생성하라. 절대 입력에 없는 정보를 추측하거나 추가하지 마라.\n" +
                    "2) 환자 이름이나 기타 환자 관련 정보(예: '호테', 'Feline', 'C.male', '중남', '체중' 등)는 모두 출력하지 말라.\n" +
                    "3) 다음 필드를 사용하되, 해당 정보가 없으면 빈 문자열(\"\") 또는 빈 배열([])로 처리하라.\n" +
                    "   - date: 진료 날짜 (예: '2023-01-31').\n" +
                    "       - 여러 날짜가 있다면, '날짜:'로 표시된 항목 또는 가장 먼저 등장하는 날짜를 date로 설정하라.\n" +
                    "   - diagnosis: 진단 내용.\n" +
                    "   - notes: 비고.\n" +
                    "   - doctorName: 수의사 이름 (구체적인 이름이 없으면 빈 문자열).\n" +
                    "   - hospitalName: 병원 이름 (입력 데이터에 명시가 없으면 빈 문자열).\n" +
                    "   - examinations: [{ \"type\": \"검사\", \"key\": \"검사항목\", \"value\": \"세부정보\" }].\n" +
                    "   - medications: [{ \"type\": \"약물\", \"key\": \"약품명\", \"value\": \"용량/용법\" }].\n" +
                    "   - vaccinations: [{ \"type\": \"접종\", \"key\": \"백신명\", \"value\": \"차수\" }].\n\n" +
                    "4) OCR 데이터에 나타난 모든 검사 관련 항목(예: 재진료, *일반신체검사, 임상병리 검사, 혈액검사, 방사선, 초음파, 뇨검사, vcheck, Feline-pro-BNP 등)을 누락 없이 examinations 배열에 추가하라.\n" +
                    "   - 각 항목은 { \"type\": \"검사\", \"key\": \"검사이름\", \"value\": \"세부정보\" } 형태로 구성하라.\n" +
                    "   - 예를 들어 '2023-01-31 혈액검사-종합검사(화학검사BS-240)-화학검사 종함v'라면,\n" +
                    "     key는 '혈액검사-종합검사(화학검사BS-240)-화학검사', value는 '종함v'가 될 수 있다.\n" +
                    "   - 세부정보(값) 없이 검사명만 있으면 value는 빈 문자열로 둔다.\n" +
                    "5) 약물이나 접종 관련 내용이 구체적으로 드러나지 않으면, medications와 vaccinations는 빈 배열([])로 둬라.\n" +
                    "6) 출력은 반드시 순수 JSON 형식만을 사용하고, 추가적인 설명이나 문장은 포함하지 마라.\n\n" +
                    "예시 출력 (참고용, 실제 데이터가 없으면 채우지 말 것):\n" +
                    "{\n" +
                    "  \"date\": \"2023-01-31\",\n" +
                    "  \"diagnosis\": \"\",\n" +
                    "  \"notes\": \"\",\n" +
                    "  \"doctorName\": \"\",\n" +
                    "  \"hospitalName\": \"\",\n" +
                    "  \"examinations\": [\n" +
                    "    {\"type\": \"검사\", \"key\": \"혈액검사\", \"value\": \"종합검사(화학검사BS-240)-화학검사\"},\n" +
                    "    {\"type\": \"검사\", \"key\": \"xray검사\", \"value\": \"흉복부 (기본)\"},\n" +
                    "    {\"type\": \"검사\", \"key\": \"재진료\", \"value\": \"\"},\n" +
                    "    {\"type\": \"검사\", \"key\": \"일반신체검사\", \"value\": \"\"}\n" +
                    "  ],\n" +
                    "  \"medications\": [],\n" +
                    "  \"vaccinations\": []\n" +
                    "}\n";
    /**
     * 의료 기록 전문 지식을 바탕으로 입력 데이터를 정제하여 반환합니다.
     *
     * @param request OcrRequest - OCR 결과 문자열을 담은 요청 DTO
     * @return OcrResponse - GPT API 결과를 매핑한 응답 DTO
     */
    public OcrResponse getOcrResult(OcrRequest request) {
        // 1. 입력 데이터가 존재하는지 확인합니다.
        String text = request.getText();
        if (text == null || text.trim().isEmpty()) {
            throw new IllegalArgumentException("입력 데이터가 제공되지 않았습니다.");
        }

        // 2. 프롬프트와 입력 데이터를 결합합니다.
        String fullPrompt = prompt + "\n\n입력 데이터:\n" + text;
        System.out.println("fullPrompt = " + fullPrompt);

        // 3. GPT API 호출
        String gptResult = openAiApiClient.sendPrompt(fullPrompt);
        System.out.println("gptResult = " + gptResult);

        // 4. GPT API 응답에 에러 메시지가 있는지 체크합니다.
        if (gptResult.contains("\"error\"")) {
            throw new RuntimeException("GPT API 오류 발생: " + gptResult);
        }

        // 5. 정상적인 응답인 경우 OcrResponse 객체로 매핑하여 반환합니다.
        return ocrMapper.toOcrResponse(gptResult);
    }

}

package com.be.KKUKKKUK.domain.ocr.service;

import com.be.KKUKKKUK.domain.ocr.client.OpenAiApiClient;
import com.be.KKUKKKUK.domain.ocr.dto.mapper.OcrMapper;
import com.be.KKUKKKUK.domain.ocr.dto.response.EmptyResponse;
import com.be.KKUKKKUK.domain.ocr.dto.response.OcrResponse;
import com.be.KKUKKKUK.domain.ocr.dto.response.Response;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.Comparator;
import java.util.Map;
import java.util.Objects;

/**
 * packageName    : com.be.KKUKKKUK.domain.ocr.service<br>
 * fileName       : OcrService.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-02<br>
 * description    : Ocr Service 클래스 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.02          eunchang           최초 생성<br>
 * 25.04.08          eunchang           파싱 실패 시 빈객체 반환 <br>
 */

@Slf4j
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
                    "7) 입력 데이터에서 '내복약', '주사', '약' 등과 같이 약물을 나타내는 단어가 발견되면, 이를 medications 배열에 추가하라. " +
                    "   - 예를 들어, '내복약 (-20kg)-진소염제'가 있다면, key는 '내복약'으로, value는 '(-20kg)-진소염제'로 처리하라.\n"
                    +
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
     * @param request OcrRequest OCR 결과 문자열을 담은 요청 DTO
     * @return OcrResponse GPT API 결과를 매핑한 응답 DTO
     * @throws ApiException 입력한 데이터가 올바르지 않은 경우
     * @throws ApiException GTP 결과가 올바르지 않거나 error처리가 된 경우
     */
    public Response getOcrResult(Map<String, String> request) {
        String text = combineText(request);
        if (Objects.isNull(text) || text.trim().isEmpty()) {
            return new EmptyResponse();
        }

        String fullPrompt = prompt + "\n\n입력 데이터:\n" + text;
        String gptResult = openAiApiClient.sendPrompt(fullPrompt);

        log.info("gptResult = {}", gptResult);

        if (gptResult.contains("\"error\"")) {
            throw new ApiException(ErrorCode.GPT_API_ERROR);
        }

        OcrResponse response = ocrMapper.toOcrResponse(gptResult);


        return response;
    }

    /**
     * 파라미터로 들어온 키-벨류 값들을 정제해서 하나의 택스트로 결합합니다.
     *
     * @param requestMap 모바일에서 Json 형식으로 요청한 값
     */
    public String combineText(Map<String, String> requestMap) {
        StringBuilder combinedText = new StringBuilder();
        requestMap.entrySet().stream()
                .filter(entry -> entry.getKey().startsWith("word_"))
                .sorted(Comparator.comparingInt(e -> Integer.parseInt(e.getKey().substring(5))))
                .forEach(entry -> combinedText.append(entry.getValue()).append(" "));

        return combinedText.toString().trim();
    }
}

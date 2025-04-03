package com.be.KKUKKKUK.domain.ocr.client;

import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.*;
/**
 * packageName    : com.be.KKUKKKUK.domain.ocr.client<br>
 * fileName       : OpenAiApiClient.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-03<br>
 * description    :  OpenAi API를 호출하고 응답 결과를 처리하는 클래스입니다..<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 2025-04-03          eunchang           최초생성<br>
 */


@Component
@RequiredArgsConstructor
public class OpenAiApiClient {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    @Value("${openai.api.key}")
    private String apiKey;

    private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

    /**
     * GPT에게 프롬프트를 전달하고 응답 내용을 문자열로 반환합니다.
     *
     * @param fullPrompt GPT에 전달할 전체 프롬프트 메시지
     * @return GPT의 응답 내용 문자열
     * @throws ApiException GTP 결과가 JSON 형식이 아닌경우 예외 처리
     * @throws ApiException GTP API 요청 후 200이 아닌 경우 예외 처리
     */
    public String sendPrompt(String fullPrompt) {
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", "gpt-3.5-turbo");

        List<Map<String, String>> messages = new ArrayList<>();
        Map<String, String> userMessage = new HashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", fullPrompt);
        messages.add(userMessage);

        requestBody.put("messages", messages);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        ResponseEntity<String> response = restTemplate.postForEntity(OPENAI_API_URL, entity, String.class);

        if (response.getStatusCode() != HttpStatus.OK) throw new ApiException(ErrorCode.GPT_API_ERROR);


        try {
            JsonNode root = objectMapper.readTree(response.getBody());
            JsonNode choices = root.path("choices");
            if (!choices.isArray() && choices.size() <= 0) throw new ApiException(ErrorCode.GPT_API_ERROR);
            JsonNode messageNode = choices.get(0).path("message").path("content");
            return messageNode.asText();

        } catch (Exception e) {
            throw new ApiException(ErrorCode.GPT_JSON_ERROR);
        }
    }
}

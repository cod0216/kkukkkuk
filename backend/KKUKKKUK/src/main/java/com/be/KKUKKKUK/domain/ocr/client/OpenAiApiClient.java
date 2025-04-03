package com.be.KKUKKKUK.domain.ocr.client;

import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Component;
import org.springframework.web.client.RestTemplate;

import java.util.*;

@Component
@RequiredArgsConstructor
public class OpenAiApiClient {

    private final RestTemplate restTemplate;
    private final ObjectMapper objectMapper;

    @Value("${openai.api.key}")
    private String apiKey;

    // OpenAI Chat API 엔드포인트 (예시)
    private static final String OPENAI_API_URL = "https://api.openai.com/v1/chat/completions";

    /**
     * GPT에게 프롬프트를 전달하고 응답 내용을 문자열로 반환합니다.
     *
     * @param fullPrompt GPT에 전달할 전체 프롬프트 메시지
     * @return GPT의 응답 내용 문자열
     */
    public String sendPrompt(String fullPrompt) {
        // 요청 헤더 설정
        HttpHeaders headers = new HttpHeaders();
        headers.setContentType(MediaType.APPLICATION_JSON);
        headers.setBearerAuth(apiKey);

        // 요청 바디 구성 (ChatGPT 모델 기준)
        Map<String, Object> requestBody = new HashMap<>();
        requestBody.put("model", "gpt-3.5-turbo"); // 사용 모델 설정 (필요 시 변경)

        // 메시지 리스트 구성 (단일 user 메시지)
        List<Map<String, String>> messages = new ArrayList<>();
        Map<String, String> userMessage = new HashMap<>();
        userMessage.put("role", "user");
        userMessage.put("content", fullPrompt);
        messages.add(userMessage);

        requestBody.put("messages", messages);

        HttpEntity<Map<String, Object>> entity = new HttpEntity<>(requestBody, headers);

        // API 호출
        ResponseEntity<String> response = restTemplate.postForEntity(OPENAI_API_URL, entity, String.class);

        if (response.getStatusCode() != HttpStatus.OK) {
            throw new RuntimeException("OpenAI API 호출 실패: " + response.getStatusCode());
        }

        try {
            // 응답 JSON에서 choices 배열 내 첫번째 메시지의 content를 추출합니다.
            JsonNode root = objectMapper.readTree(response.getBody());
            JsonNode choices = root.path("choices");
            if (choices.isArray() && choices.size() > 0) {
                JsonNode messageNode = choices.get(0).path("message").path("content");
                return messageNode.asText();
            } else {
                throw new RuntimeException("응답 형식이 올바르지 않습니다.");
            }
        } catch (Exception e) {
            throw new RuntimeException("OpenAI API 응답 파싱 실패", e);
        }
    }
}

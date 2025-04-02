package com.be.KKUKKKUK.domain.ocr.client;

import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.JsonNode;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;
import reactor.util.retry.Retry;

import javax.swing.*;
import java.time.Duration;
import java.util.Collection;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;

@Component
@RequiredArgsConstructor
public class OpenAiApiClient {

    @Value("${openai.api.key}")
    private String apiKey;

    private final ObjectMapper objectMapper;

    private final WebClient webClient = WebClient.builder()
            .baseUrl("https://api.openai.com/v1/chat/completions")
            .defaultHeader(HttpHeaders.CONTENT_TYPE, MediaType.APPLICATION_JSON_VALUE)
            .build();

    /**
     * 주어진 프롬프트를 사용하여 OpenAI API를 호출하고 응답 텍스트를 반환합니다.
     *
     * @param prompt OpenAI에게 전달할 프롬프트
     * @return OpenAI가 생성한 응답 텍스트
     */
    public String callOpenAi(String prompt) {
        Collections.emptyList();

        try {
            Map<String, Object> payload = new HashMap<>();
            payload.put("model", "gpt-4");

            Map<String, String> systemMessage = Map.of(
                    "role", "system",
                    "content", "You are a helpful assistant."
            );
            Map<String, String> userMessage = Map.of(
                    "role", "user",
                    "content", prompt
            );
            payload.put("messages", new Map[]{systemMessage, userMessage});

            String responseBody = webClient.post()
                    .header("Authorization", "Bearer " + apiKey)
                    .bodyValue(payload)
                    .retrieve()
                    .bodyToMono(String.class)
                    .retryWhen(
                            Retry.backoff(3, Duration.ofSeconds(2))  // 최대 3회 재시도, 2초 간격
                                    .filter(throwable ->
                                            throwable instanceof WebClientResponseException.TooManyRequests
                                    )
                    )
                    .block();

            JsonNode root = objectMapper.readTree(responseBody);
            JsonNode choices = root.path("choices");
            if (choices.isArray() && choices.size() > 0) {
                return choices.get(0).path("message").path("content").asText();
            }
            return "";

        } catch (WebClientResponseException.TooManyRequests | JsonProcessingException e) {
            throw new ApiException(ErrorCode.TOO_MANY_REQUESTS);
        }
    }
}

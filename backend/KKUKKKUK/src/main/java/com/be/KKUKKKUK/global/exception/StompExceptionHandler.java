package com.be.KKUKKKUK.global.exception;

import com.fasterxml.jackson.core.JsonProcessingException;
import com.fasterxml.jackson.databind.ObjectMapper;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.Message;
import org.springframework.messaging.simp.stomp.StompCommand;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.messaging.support.MessageBuilder;
import org.springframework.stereotype.Component;
import org.springframework.web.socket.messaging.StompSubProtocolErrorHandler;

import java.nio.charset.StandardCharsets;

/**
 * packageName    : com.be.KKUKKKUK.global.exception<br>
 * fileName       : StompExceptionHandler.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : stomp 웹소켓 통신의 예외 처리를 위한 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
@Slf4j
@Component
@RequiredArgsConstructor
public class StompExceptionHandler extends StompSubProtocolErrorHandler {

    @Override
    public Message<byte[]> handleClientMessageProcessingError(Message<byte[]> clientMessage, Throwable e) {
        log.error("WebSocket Error: ", e);

        if (e instanceof ApiException apiException) {
            return createErrorMessage(apiException.getErrorCode());
        }

        return createErrorMessage(ErrorCode.INTERNAL_SERVER_ERROR);
    }

    private Message<byte[]> createErrorMessage(ErrorCode errorCode) {
        StompHeaderAccessor headerAccessor = StompHeaderAccessor.create(StompCommand.ERROR);
        headerAccessor.setMessage(errorCode.getMessage());

        ResponseEntity<?> errorResponse = ErrorResponseEntity.toResponseEntity(errorCode);
        String payload = convertToJson(errorResponse);

        return MessageBuilder.createMessage(payload.getBytes(StandardCharsets.UTF_8), headerAccessor.getMessageHeaders());
    }

    private String convertToJson(ResponseEntity<?> errorResponse) {
        try {
            return new ObjectMapper().writeValueAsString(errorResponse);
        } catch (JsonProcessingException e) {
            log.error("Error converting to JSON", e);
            return "{\"message\": \"Error processing error response\"}";
        }
    }
}

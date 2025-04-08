package com.be.KKUKKKUK.domain.chat.controller;

import com.be.KKUKKKUK.domain.chat.dto.request.ChattingRequest;
import com.be.KKUKKKUK.domain.chat.service.ChatComplexService;
import com.be.KKUKKKUK.domain.chat.service.ChatService;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import com.be.KKUKKKUK.global.util.JwtUtility;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.context.event.EventListener;
import org.springframework.http.ResponseEntity;
import org.springframework.messaging.handler.annotation.*;
import org.springframework.messaging.simp.SimpMessageSendingOperations;
import org.springframework.messaging.simp.stomp.StompHeaderAccessor;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.socket.messaging.SessionConnectEvent;
import org.springframework.web.socket.messaging.SessionDisconnectEvent;

@Slf4j
@RestController
@RequiredArgsConstructor
public class ChatController {
    private final ChatComplexService chatComplexService;
    private final JwtUtility jwtUtility;


    @SendTo("/topic/chat/{receiverId}")
    @MessageMapping("/chat/{receiverId}/send")
    public ResponseEntity<?> sendMessage(@DestinationVariable Integer receiverId,
                                         @Header("Authorization") String authorization,
                                         ChattingRequest request
    ) {
        Integer hospitalId = authorizationFromToken(authorization);
        return ResponseUtility.success("채팅 메세지 성공", chatComplexService.saveChat(receiverId, hospitalId, request));
    }

    private Integer authorizationFromToken(String authorization){
        String token = authorization.substring(7);
        if(!jwtUtility.validateToken(token)){
            throw new ApiException(ErrorCode.INVALID_TOKEN);
        }
        return jwtUtility.getUserId(token);
    }
}

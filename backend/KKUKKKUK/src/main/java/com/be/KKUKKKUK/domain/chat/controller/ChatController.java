package com.be.KKUKKKUK.domain.chat.controller;

import com.be.KKUKKKUK.domain.chat.dto.request.ChattingRequest;
import com.be.KKUKKKUK.domain.chat.dto.response.ChattingResponse;
import com.be.KKUKKKUK.domain.chat.service.ChatComplexService;
import com.be.KKUKKKUK.global.util.JwtUtility;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.*;
import org.springframework.web.bind.annotation.*;

@RestController
@RequiredArgsConstructor
public class ChatController {
    private final static String HEADER_AUTHORIZATION = "Authorization";
    private final ChatComplexService chatComplexService;
    private final JwtUtility jwtUtility;

    @SendTo("/topic/chats/{receiverId}")
    @MessageMapping("/chats/{receiverId}/send")
    public ChattingResponse sendMessage(@DestinationVariable Integer receiverId,
                                         @Header(HEADER_AUTHORIZATION) String authorization,
                                         @Valid @RequestBody ChattingRequest request) {
        Integer senderId = extractUserIdFromToken(authorization);
        return  chatComplexService.sendMessage(receiverId, senderId, request);
    }

    private Integer extractUserIdFromToken(String authorization) {
        String token = authorization.substring(7);
        return jwtUtility.getUserId(token);
    }
}
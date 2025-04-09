package com.be.KKUKKKUK.domain.chat.controller;

import com.be.KKUKKKUK.domain.chat.dto.request.ChattingRequest;
import com.be.KKUKKKUK.domain.chat.dto.response.ChattingResponse;
import com.be.KKUKKKUK.domain.chat.service.ChatComplexService;
import com.be.KKUKKKUK.global.util.JwtUtility;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.messaging.handler.annotation.*;
import org.springframework.web.bind.annotation.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.chat.controller<br>
 * fileName       : ChatController.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : chatting 웹소켓 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
@RestController
@RequiredArgsConstructor
public class ChatController {
    private final static String HEADER_AUTHORIZATION = "Authorization";
    private final ChatComplexService chatComplexService;
    private final JwtUtility jwtUtility;

    @SendTo("/topic/chats/{roomId}")
    @MessageMapping("/chats/{roomId}/send")
    public ChattingResponse sendMessage(@DestinationVariable Integer roomId,
                                         @Header(HEADER_AUTHORIZATION) String authorization,
                                         @Valid @RequestBody ChattingRequest request) {
        Integer senderId = extractUserIdFromToken(authorization);
        return  chatComplexService.sendMessage(roomId, senderId, request);
    }

    private Integer extractUserIdFromToken(String authorization) {
        String token = authorization.substring(7);
        return jwtUtility.getUserId(token);
    }
}
package com.be.KKUKKKUK.domain.chat.dto.response;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@Builder
@AllArgsConstructor
public class ChatRoomSummaryResponse {

    private Integer chatRoomId;

    private String partnerName;

    private Integer partnerId;

    private String lastMessage;

    private LocalDateTime lastMessageAt;

    private Integer unreadMessageCount;
}
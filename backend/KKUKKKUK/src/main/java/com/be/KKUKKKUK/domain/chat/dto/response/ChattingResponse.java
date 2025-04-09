package com.be.KKUKKKUK.domain.chat.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.Setter;

import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class ChattingResponse {
    private Long id;

    private String content;

    private Long chatRoomId;

    private Integer senderId;

    private String senderName;

    private LocalDateTime sentAt;

    private Boolean flagRead;

    private LocalDateTime readAt;

    private Boolean flagSentByMe;
}
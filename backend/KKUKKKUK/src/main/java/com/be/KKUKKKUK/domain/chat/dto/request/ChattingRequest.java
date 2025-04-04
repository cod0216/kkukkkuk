package com.be.KKUKKKUK.domain.chat.dto.request;

import com.be.KKUKKKUK.domain.chat.entity.Chat;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Getter;

@Getter
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ChattingRequest {
    private String content;
    private Integer hospitalId;

    public Chat toChatEntity() {
        return Chat.builder()
                .content(content)
                .build();
    }
}

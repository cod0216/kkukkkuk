package com.be.KKUKKKUK.domain.chat.dto.response;

import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.AllArgsConstructor;
import lombok.Setter;

import java.time.LocalDateTime;

@Setter
@AllArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class ChattingResponse {
    private String messageId;
    private String content;
    private Integer hospitalId;
    private String hospitalName;
    private LocalDateTime createdAt;
}

package com.be.KKUKKKUK.domain.chat.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDateTime;

/**
 * packageName    : com.be.KKUKKKUK.domain.chat.dto.response<br>
 * fileName       : ChatRoomSummaryResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : 채팅방 요청에 대한 response dto 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
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
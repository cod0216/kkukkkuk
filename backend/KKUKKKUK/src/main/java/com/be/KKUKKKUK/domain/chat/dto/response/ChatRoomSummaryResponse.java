package com.be.KKUKKKUK.domain.chat.dto.response;

import lombok.*;

import java.time.LocalDateTime;

/**
 * packageName    : com.be.KKUKKKUK.domain.chat.dto.mapper<br>
 * fileName       : ChatRoomSummaryResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : 채팅방 목록 요청에 대한 request dto 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */

@Getter
@Setter
@Builder
@NoArgsConstructor
@AllArgsConstructor
public class ChatRoomSummaryResponse {

    private Integer chatRoomId;

    private String partnerName;

    private Integer partnerId;

    private String lastMessage;

    private LocalDateTime lastMessageAt;

    private Integer unreadMessageCount;
}
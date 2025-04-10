package com.be.KKUKKKUK.domain.chat.dto.request;

import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import jakarta.validation.constraints.Size;
import lombok.Getter;

/**
 * packageName    : com.be.KKUKKKUK.domain.chat.dto.mapper<br>
 * fileName       : ChattingRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : chatting 요청에 대한 request dto 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
@Getter
public class ChattingRequest {

    @NotBlank(message = "메시지 내용은 필수입니다")
    @Size(max = 1000, message = "메시지는 1000자를 초과할 수 없습니다")
    private String content;

    @Min(1)
    @NotNull
    private Integer chatRoomId;

    @Min(1)
    @NotNull
    private Integer receiverId;
}
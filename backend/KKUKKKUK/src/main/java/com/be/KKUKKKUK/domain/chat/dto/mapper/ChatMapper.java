package com.be.KKUKKKUK.domain.chat.dto.mapper;

import com.be.KKUKKKUK.domain.chat.dto.response.ChatRoomSummaryResponse;
import com.be.KKUKKKUK.domain.chat.dto.response.ChattingResponse;
import com.be.KKUKKKUK.domain.chat.entity.Chat;
import com.be.KKUKKKUK.domain.chat.entity.ChatRoom;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import java.util.List;
import java.util.stream.Collectors;


/**
 * packageName    : com.be.KKUKKKUK.domain.chat.dto.mapper<br>
 * fileName       : ChatMapper.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : Chat entity 에 대한 mapper 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface ChatMapper {

    /**
     * Chat 엔티티를 ChattingResponse DTO로 변환합니다.
     *
     * @param chat 변환할 Chat 엔티티
     * @return 변환된 ChattingResponse DTO
     */
    @Mapping(source = "id", target = "id")
    @Mapping(source = "content", target = "content")
    @Mapping(source = "chatRoom.id", target = "chatRoomId")
    @Mapping(source = "sender.id", target = "senderId")
    @Mapping(source = "sender.name", target = "senderName")
    @Mapping(source = "sentAt", target = "sentAt")
    @Mapping(source = "flagRead", target = "flagRead")
    @Mapping(source = "readAt", target = "readAt")
    ChattingResponse mapToChattingResponse(Chat chat);

    /**
     * Chat 엔티티를 ChattingResponse DTO로 변환하고 현재 사용자가 발신자인지 여부를 설정합니다.
     *
     * @param chat 변환할 Chat 엔티티
     * @param currentUserId 현재 요청 사용자의 ID
     * @return 변환된 ChattingResponse DTO (isSentByMe 필드가 설정됨)
     */
    @Mapping(source = "chat.id", target = "id")
    @Mapping(source = "chat.content", target = "content")
    @Mapping(source = "chat.chatRoom.id", target = "chatRoomId")
    @Mapping(source = "chat.sender.id", target = "senderId")
    @Mapping(source = "chat.sender.name", target = "senderName")
    @Mapping(source = "chat.sentAt", target = "sentAt")
    @Mapping(source = "chat.flagRead", target = "flagRead")
    @Mapping(source = "chat.readAt", target = "readAt")
    @Mapping(expression = "java(chat.getSender().getId().equals(currentUserId))", target = "flagSentByMe")
    ChattingResponse mapToChattingResponseWithCurrentUser(Chat chat, Integer currentUserId);

    /**
     * Chat 엔티티 목록을 ChattingResponse DTO 목록으로 변환합니다.
     *
     * @param chats 변환할 Chat 엔티티 목록
     * @return 변환된 ChattingResponse DTO 목록
     */
    List<ChattingResponse> mapToChattingResponseList(List<Chat> chats);

    /**
     * Chat 엔티티 목록을 ChattingResponse DTO 목록으로 변환하고 현재 사용자가 발신자인지 여부를 설정합니다.
     *
     * @param chats 변환할 Chat 엔티티 목록
     * @param currentUserId 현재 요청 사용자의 ID
     * @return 변환된 ChattingResponse DTO 목록 (isSentByMe 필드가 설정됨)
     */
    default List<ChattingResponse> mapToChattingResponseListWithCurrentUser(List<Chat> chats, Integer currentUserId) {
        return chats.stream()
                .map(chat -> mapToChattingResponseWithCurrentUser(chat, currentUserId))
                .collect(Collectors.toList());
    }

    /**
     * ChatRoom 엔티티를 ChatRoomSummaryResponse DTO로 변환합니다.
     *
     * @param chatRoom 변환할 ChatRoom 엔티티
     * @param partner 상대방 병원
     * @param lastMessage 마지막 메시지
     * @param unreadCount 읽지 않은 메시지 수
     * @return 변환된 ChatRoomSummaryResponse DTO
     */
    @Mapping(source = "chatRoom.id", target = "chatRoomId")
    @Mapping(source = "partner.name", target = "partnerName")
    @Mapping(source = "partner.id", target = "partnerId")
    @Mapping(source = "lastMessage.content", target = "lastMessage")
    @Mapping(source = "chatRoom.lastMessageAt", target = "lastMessageAt")
    @Mapping(source = "unreadCount", target = "unreadMessageCount")
    ChatRoomSummaryResponse mapToChatRoomSummaryResponse(
            ChatRoom chatRoom, Hospital partner, Chat lastMessage, Long unreadCount);
}
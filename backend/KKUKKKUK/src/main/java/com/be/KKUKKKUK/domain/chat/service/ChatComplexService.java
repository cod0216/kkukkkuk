package com.be.KKUKKKUK.domain.chat.service;

import com.be.KKUKKKUK.domain.chat.dto.response.ChatRoomSummaryResponse;
import com.be.KKUKKKUK.domain.chat.dto.request.ChattingRequest;
import com.be.KKUKKKUK.domain.chat.dto.response.ChattingResponse;
import com.be.KKUKKKUK.domain.chat.entity.Chat;
import com.be.KKUKKKUK.domain.chat.entity.ChatRoom;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.domain.hospital.service.HospitalService;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.Comparator;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

/**
 * packageName    : com.be.KKUKKKUK.domain.chat.service <br>
 * fileName       : ChatComplexService.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : Chatroom entity 에 대한 상위 레벨의 Service 클래스입니다.<br>
 *                  ChatService, ChatRoomService, HospitalService 등 저수준 Service 클래스를 묶어서
 *                  복잡한 비즈니스 로직을 처리합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class ChatComplexService {
    private final ChatService chatService;
    private final ChatRoomService chatRoomService;
    private final HospitalService hospitalService;

    public ChattingResponse sendMessage(Integer receiverId, Integer senderId, ChattingRequest request) {
        // 발신자와 수신자 병원 조회
        Hospital sender = hospitalService.findHospitalById(senderId);
        Hospital receiver = hospitalService.findHospitalById(receiverId);

        if (sender.equals(receiver)) {
            throw new ApiException(ErrorCode.SELF_CHAT_NOT_ALLOWED);
        }

        // 채팅방 조회 또는 생성
        ChatRoom chatRoom = chatRoomService.getChatRoomByParticipants(sender, receiver);

        // 채팅 메시지 생성
        Chat chat = Chat.builder()
                .content(request.getContent())
                .sender(sender)
                .chatRoom(chatRoom)
                .flagRead(false)
                .sentAt(LocalDateTime.now())
                .build();

        return chatService.saveChat(chat);
    }

    public List<ChattingResponse> getChatHistory(Integer requesterId, Integer partnerId) {
        Hospital requester = hospitalService.findHospitalById(requesterId);
        Hospital partner = hospitalService.findHospitalById(partnerId);

        ChatRoom chatRoom = chatRoomService.getChatRoomByParticipants(requester, partner);
        return chatService.getChatHistoryByChatRoomId(chatRoom.getId(), requesterId);
    }

    public List<ChatRoomSummaryResponse> getChatRoomList(Integer hospitalId) {
        List<ChatRoom> chatRooms = chatRoomService.getChatRoomsByHospitalId(hospitalId);

        return chatRooms.stream()
                .map(room -> {
                    // 상대방 병원 정보 찾기
                    Hospital partner = room.getInitiatorHospital().getId().equals(hospitalId) ?
                            room.getReceiverHospital() : room.getInitiatorHospital();

                    // 읽지 않은 메시지 수 계산
                    int unreadCount = chatService.getUnreadMessageCount(hospitalId, room.getId());

                    // 최근 메시지 가져오기
                    Optional<Chat> lastMessage = room.getMessages().stream()
                            .max(Comparator.comparing(Chat::getSentAt));

                    return ChatRoomSummaryResponse.builder()
                            .chatRoomId(room.getId())
                            .partnerName(partner.getName())
                            .partnerId(partner.getId())
                            .lastMessage(lastMessage.map(Chat::getContent).orElse(""))
                            .lastMessageAt(room.getLastMessageAt())
                            .unreadMessageCount(unreadCount)
                            .build();

                })
                .collect(Collectors.toList());
    }

    public ChatRoomSummaryResponse getChatRoomId(Integer partnerId, Integer requesterId) {
        Hospital partner = hospitalService.findHospitalById(partnerId);
        Hospital requester = hospitalService.findHospitalById(requesterId);

        ChatRoom room = chatRoomService.getChatRoomByParticipants(requester, partner);

        // 마지막 메시지 찾기
        String lastMessageContent = "";
        if (room.getMessages() != null && !room.getMessages().isEmpty()) {
            Optional<Chat> lastMessage = room.getMessages().stream()
                    .max(Comparator.comparing(Chat::getSentAt));
            lastMessageContent = lastMessage.map(Chat::getContent).orElse("");
        }

        // 읽지 않은 메시지 수 계산
        int unreadCount = 0;
        if (room.getMessages() != null) {
            unreadCount = (int) room.getMessages().stream()
                    .filter(chat -> !chat.getSender().getId().equals(requesterId) && !chat.getFlagRead())
                    .count();
        }

        return ChatRoomSummaryResponse.builder()
                .chatRoomId(room.getId())
                .partnerName(partner.getName())
                .partnerId(partner.getId())
                .lastMessage(lastMessageContent)
                .lastMessageAt(room.getLastMessageAt())
                .unreadMessageCount(unreadCount)
                .build();
    }
}
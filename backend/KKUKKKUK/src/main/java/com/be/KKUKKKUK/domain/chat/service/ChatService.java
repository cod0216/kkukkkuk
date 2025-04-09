package com.be.KKUKKKUK.domain.chat.service;

import com.be.KKUKKKUK.domain.chat.dto.mapper.ChatMapper;
import com.be.KKUKKKUK.domain.chat.dto.response.ChattingResponse;
import com.be.KKUKKKUK.domain.chat.entity.Chat;
import com.be.KKUKKKUK.domain.chat.repository.ChatRepository;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.stream.Collectors;

/**
 * packageName    : com.be.KKUKKKUK.domain.chat.service <br>
 * fileName       : ChatService.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : chat entity 에 대한 service 클래스입니다.<br>
 *
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class ChatService {
    private final ChatRepository chatRepository;
    private final ChatMapper chatMapper;
    private final ChatRoomService chatRoomService;

    public ChattingResponse saveChat(Chat chat) {
        Chat savedChat = chatRepository.save(chat);
        chatRoomService.updateLastMessageTime(chat.getChatRoom());
        return chatMapper.mapToChattingResponse(savedChat);
    }

    public List<ChattingResponse> getChatHistoryByChatRoomId(Integer chatRoomId, Integer requesterId) {
        List<Chat> chats = chatRepository.findByChatRoomIdOrderBySentAtAsc(chatRoomId);

        chats.stream()
                .filter(chat -> !chat.getSender().getId().equals(requesterId) && !chat.getFlagRead())
                .forEach(chat -> {
                    chat.setFlagRead(true);
                    chat.setReadAt(LocalDateTime.now());
                    chatRepository.save(chat);
                });

        return chats.stream()
                .map(chatMapper::mapToChattingResponse)
                .collect(Collectors.toList());
    }

    public int getUnreadMessageCount(Integer hospitalId, Integer chatRoomId) {
        return chatRepository.countByFlagReadFalseAndChatRoomIdAndSenderIdNot(chatRoomId, hospitalId);
    }
}
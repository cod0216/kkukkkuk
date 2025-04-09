package com.be.KKUKKKUK.domain.chat.respository;

import com.be.KKUKKKUK.domain.chat.entity.Chat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


public interface ChatRepository extends JpaRepository<Chat, Integer> {

    List<Chat> findByChatRoomIdOrderBySentAtAsc(Integer chatRoomId);

    int countByFlagReadFalseAndChatRoomIdAndSenderIdNot(Integer chatRoomId, Integer hospitalId);
}

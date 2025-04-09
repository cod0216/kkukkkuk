package com.be.KKUKKKUK.domain.chat.repository;

import com.be.KKUKKKUK.domain.chat.entity.Chat;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;


/**
 * packageName    : com.be.KKUKKKUK.domain.chat.repository <br>
 * fileName       : ChatRepository.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : chat entity 에 대한 repository 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
public interface ChatRepository extends JpaRepository<Chat, Integer> {

    List<Chat> findByChatRoomIdOrderBySentAtAsc(Integer chatRoomId);

    int countByFlagReadFalseAndChatRoomIdAndSenderIdNot(Integer chatRoomId, Integer hospitalId);
}

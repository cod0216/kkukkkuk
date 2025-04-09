package com.be.KKUKKKUK.domain.chat.repository;

import com.be.KKUKKKUK.domain.chat.entity.ChatRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.chat.repository <br>
 * fileName       : ChatRoomRepository.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : chatroom entity 에 대한 repository 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
public interface ChatRoomRepository extends JpaRepository<ChatRoom, Integer> {

    @Query("SELECT cr FROM ChatRoom cr WHERE " +
            "(cr.initiatorHospital.id = :hospitalId1 AND cr.receiverHospital.id = :hospitalId2) OR " +
            "(cr.initiatorHospital.id = :hospitalId2 AND cr.receiverHospital.id = :hospitalId1)")
    Optional<ChatRoom> findByParticipantIds(@Param("hospitalId1") Integer hospitalId1,
                                            @Param("hospitalId2") Integer hospitalId2);

    List<ChatRoom> findByInitiatorHospitalIdOrReceiverHospitalIdOrderByLastMessageAtDesc(
            Integer initiatorId, Integer receiverId);
}
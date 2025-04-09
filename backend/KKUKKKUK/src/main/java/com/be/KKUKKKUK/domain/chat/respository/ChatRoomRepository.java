package com.be.KKUKKKUK.domain.chat.respository;

import com.be.KKUKKKUK.domain.chat.entity.ChatRoom;
import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.jpa.repository.Query;
import org.springframework.data.repository.query.Param;

import java.util.List;
import java.util.Optional;


public interface ChatRoomRepository extends JpaRepository<ChatRoom, Long> {

    @Query("SELECT cr FROM ChatRoom cr WHERE " +
            "(cr.initiatorHospital.id = :hospitalId1 AND cr.receiverHospital.id = :hospitalId2) OR " +
            "(cr.initiatorHospital.id = :hospitalId2 AND cr.receiverHospital.id = :hospitalId1)")
    Optional<ChatRoom> findByParticipantIds(@Param("hospitalId1") Integer hospitalId1,
                                            @Param("hospitalId2") Integer hospitalId2);

    List<ChatRoom> findByInitiatorHospitalIdOrReceiverHospitalIdOrderByLastMessageAtDesc(
            Integer initiatorId, Integer receiverId);
}
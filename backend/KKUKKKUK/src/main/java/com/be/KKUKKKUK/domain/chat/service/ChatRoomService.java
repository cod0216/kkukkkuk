package com.be.KKUKKKUK.domain.chat.service;

import com.be.KKUKKKUK.domain.chat.entity.ChatRoom;
import com.be.KKUKKKUK.domain.chat.respository.ChatRoomRepository;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Optional;

@Service
@Transactional
@RequiredArgsConstructor
public class ChatRoomService {
    private final ChatRoomRepository chatRoomRepository;

    public ChatRoom getChatRoomByParticipants(Hospital initiator, Hospital receiver) {
        // 항상 ID가 작은 병원이 initiator가 되도록 보장
        Hospital initiatorHospital, receiverHospital;
        if (initiator.getId() < receiver.getId()) {
            initiatorHospital = initiator;
            receiverHospital = receiver;
        } else {
            initiatorHospital = receiver;
            receiverHospital = initiator;
        }

        return chatRoomRepository.findByParticipantIds(initiatorHospital.getId(), receiverHospital.getId())
                .orElseGet(() -> createNewChatRoom(initiatorHospital, receiverHospital));
    }

    private ChatRoom createNewChatRoom(Hospital initiator, Hospital receiver) {
        ChatRoom chatRoom = ChatRoom.builder()
                .initiatorHospital(initiator)
                .receiverHospital(receiver)
                .createdAt(LocalDateTime.now())
                .lastMessageAt(LocalDateTime.now())
                .flagActive(true)
                .build();

        return chatRoomRepository.save(chatRoom);
    }

    public List<ChatRoom> getChatRoomsByHospitalId(Integer hospitalId) {
        return chatRoomRepository.findByInitiatorHospitalIdOrReceiverHospitalIdOrderByLastMessageAtDesc(
                hospitalId, hospitalId);
    }

    public void updateLastMessageTime(ChatRoom chatRoom) {
        chatRoom.setLastMessageAt(LocalDateTime.now());
        chatRoomRepository.save(chatRoom);
    }
}
package com.be.KKUKKKUK.domain.chat.service;

import com.be.KKUKKKUK.domain.chat.dto.mapper.ChatMapper;
import com.be.KKUKKKUK.domain.chat.dto.request.ChattingRequest;
import com.be.KKUKKKUK.domain.chat.dto.response.ChattingResponse;
import com.be.KKUKKKUK.domain.chat.respository.ChatRepository;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@Transactional
@RequiredArgsConstructor
public class ChatService {
    private final ChatRepository chatRepository;
    private final ChatMapper chatMapper;

    public List<ChattingResponse> saveChat(Integer roomId, RelatedType relatedType, Integer userId, ChattingRequest request) {
        // TODO

        return null;
    }
}

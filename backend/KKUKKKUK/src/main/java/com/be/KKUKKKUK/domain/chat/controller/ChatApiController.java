package com.be.KKUKKKUK.domain.chat.controller;

import com.be.KKUKKKUK.domain.chat.service.ChatComplexService;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;


/**
 * packageName    : com.be.KKUKKKUK.domain.chat.controller<br>
 * fileName       : ChatApiController.java<br>
 * author         : haelim<br>
 * date           : 2025-04-09<br>
 * description    : chatting entity 관련 api 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.09          haelim           최초 생성<br>
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/chats")
public class ChatApiController {
    private final ChatComplexService chatComplexService;

    @GetMapping("/rooms")
    public ResponseEntity<?> getChatRooms(@AuthenticationPrincipal HospitalDetails hospitalDetails) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success("채팅방 목록 조회 성공", chatComplexService.getChatRoomList(hospitalId));
    }


    @PostMapping("/rooms/{partnerId}")
    public ResponseEntity<?> getChatRooms(@PathVariable Integer partnerId,
                                          @AuthenticationPrincipal HospitalDetails hospitalDetails) {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success("채팅방 번호 조회 성공", chatComplexService.getChatRoomId(partnerId, hospitalId));
    }

    @GetMapping("/history/{partnerId}")
    public ResponseEntity<?> getChatHistory(@PathVariable Integer partnerId,
                                            @AuthenticationPrincipal HospitalDetails hospitalDetails)  {
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        return ResponseUtility.success("채팅 내역 조회 성공", chatComplexService.getChatHistory(hospitalId, partnerId));
    }
}
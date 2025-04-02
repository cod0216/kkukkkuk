package com.be.KKUKKKUK.domain.ocr.controller;

import com.be.KKUKKKUK.domain.ocr.dto.request.OcrRequest;
import com.be.KKUKKKUK.domain.ocr.service.OcrService;
import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

@RestController
@RequestMapping("/api/ocr")
@RequiredArgsConstructor
public class OcrController {
    private final OcrService ocrService;

    @PostMapping("/extract")
    public ResponseEntity<?> extractOcr(
            @AuthenticationPrincipal OwnerDetails ownerDetails,
            @RequestBody OcrRequest request) {
        return ResponseUtility.success("OCR 파싱 데이터 가공에 성공하였습니다", ocrService.getOcrResult(request));

    }
}

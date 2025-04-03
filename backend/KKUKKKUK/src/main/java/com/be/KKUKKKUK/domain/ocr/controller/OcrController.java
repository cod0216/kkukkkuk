package com.be.KKUKKKUK.domain.ocr.controller;

import com.be.KKUKKKUK.domain.ocr.dto.request.OcrRequest;
import com.be.KKUKKKUK.domain.ocr.dto.response.OcrResponse;
import com.be.KKUKKKUK.domain.ocr.service.OcrService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Comparator;
import java.util.Map;

@RestController
@RequestMapping("/api/ocr")
@RequiredArgsConstructor
public class OcrController {
    private final OcrService ocrService;

    @PostMapping("/extract")
    public ResponseEntity<?> extractOcr(@RequestBody Map<String, String> requestMap) {
        StringBuilder combinedText = new StringBuilder();
        // "word_"로 시작하는 키를 숫자 순으로 정렬하여 값을 결합
        requestMap.entrySet().stream()
                .filter(entry -> entry.getKey().startsWith("word_"))
                .sorted(Comparator.comparingInt(e -> Integer.parseInt(e.getKey().substring(5))))
                .forEach(entry -> combinedText.append(entry.getValue()).append(" "));

        String text = combinedText.toString().trim();
        System.out.println("Combined text = " + text);

        // 전처리된 문자열을 OcrRequest DTO로 생성
        OcrRequest ocrRequest = new OcrRequest(text);
        OcrResponse response = ocrService.getOcrResult(ocrRequest);

        return ResponseUtility.success("OCR 파싱 데이터 가공에 성공하였습니다", response);
    }
}

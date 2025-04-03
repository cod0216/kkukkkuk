package com.be.KKUKKKUK.domain.ocr.controller;

import com.be.KKUKKKUK.domain.ocr.dto.request.OcrRequest;
import com.be.KKUKKKUK.domain.ocr.dto.response.OcrResponse;
import com.be.KKUKKKUK.domain.ocr.service.OcrService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import java.util.Comparator;
import java.util.Map;

/**
 * packageName    :com.be.KKUKKKUK.domain.ocr.controller;<br>
 * fileName       : OcrController.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-03<br>
 * description    : Ocr Request 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.03          eunchang           최초 생성<br>
 */
@Tag(name = "OCR API", description = "모바일에서 받은 OCR을 정보를 정제하는 API입니다.")
@RestController
@RequestMapping("/api/ocr")
@RequiredArgsConstructor
public class OcrController {
    private final OcrService ocrService;

    @Operation(summary = "OCR 데이터 정제", description = "입력 받은 데이터를 정제 후 OcrResponse로 응답을 보냅니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "OCR 파싱 데이터 가공에 성공하였습니다"),
            @ApiResponse(responseCode = "500", description = "입력한 데이터가 제공되지 않았습니다."),
            @ApiResponse(responseCode = "500", description = "GPT API 호출 중 오류가 발생했습니다."),
            @ApiResponse(responseCode = "500", description = "OpenAI API 응답 파싱을 실패하였습니다."),
            @ApiResponse(responseCode = "500", description = "GPT 결과를 OcrResponse로 매핑하는 데 실패했습니다.")
    })
    @PostMapping("/extract")
    public ResponseEntity<?> extractOcr(@RequestBody Map<String, String> request) {
        return ResponseUtility.success("OCR 파싱 데이터 가공에 성공하였습니다", ocrService.getOcrResult(request));
    }
}

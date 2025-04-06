package com.be.KKUKKKUK.domain.diagnosis.controller;


import com.be.KKUKKKUK.domain.diagnosis.dto.request.DiagnosisRequest;
import com.be.KKUKKKUK.domain.diagnosis.dto.response.DiagnosisResponse;
import com.be.KKUKKKUK.domain.diagnosis.service.DiagnosisService;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jdk.jfr.Description;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.*;

import javax.management.Descriptor;
import java.util.List;

@Tag( name = "진료 관련 API", description = "병원에서 검사 항목을 조회, 추가, 삭제하는 API입니다.")
@RestController
@RequiredArgsConstructor
@RequestMapping("api/diagnoses")
public class DiagnosisController {
    private final DiagnosisService diagnosisService;



    //TODO 검사 항목 삭제
    @DeleteMapping("/{diagnosisId}")
    public ResponseEntity<?> deleteDiagnosis(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                             @PathVariable Integer diagnosisId
    ){
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        diagnosisService.deleteDiagnosis(hospitalId, diagnosisId);
        return ResponseUtility.emptyResponse("진료 기록이 성공적으로 제거 되었습니다.");
    }


    //TODO 검사 항목 자동 완성

    @Operation(summary = "검사 항목 조회", description = "검사 항목을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "403", description = "접근 권한 없음")
    })
    @GetMapping
    public ResponseEntity<?> getDiagnoses(@AuthenticationPrincipal HospitalDetails hospital) {
        List<DiagnosisResponse> response = diagnosisService.getDiagnoses(hospital.getHospital().getId());
        return ResponseUtility.success("진단 전체 조회가 올바르게 성공하였습니다.", response);
    }

    //TODO 검사 항목 이름 포함 조회

}

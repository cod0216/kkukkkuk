package com.be.KKUKKKUK.domain.diagnosis.controller;


import com.be.KKUKKKUK.domain.diagnosis.dto.request.DiagnosisRequest;
import com.be.KKUKKKUK.domain.diagnosis.dto.response.DiagnosisResponse;
import com.be.KKUKKKUK.domain.diagnosis.service.DiagnosisAutoCompleteService;
import com.be.KKUKKKUK.domain.diagnosis.service.DiagnosisService;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.diagnosis.controller<br>
 * fileName       : DiagnosisController.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : Diagnosis의 Contorller 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Tag( name = "진료 관련 API", description = "병원에서 검사 항목을 조회, 추가, 삭제하는 API입니다.")
@RestController
@RequiredArgsConstructor
@RequestMapping("api/diagnoses")
public class DiagnosisController {
    private final DiagnosisService diagnosisService;
    private final DiagnosisAutoCompleteService diagnosisAutoCompleteService;


    @Operation(summary = "포함된 검사 항목 생성", description = "이름이 포함된 검사 항목을 생성합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "생성 성공"),
    })
    @PostMapping
    public ResponseEntity<?> createDiagnosis(@AuthenticationPrincipal HospitalDetails hospital,
                                             @RequestBody DiagnosisRequest request){
        DiagnosisResponse response= diagnosisService.createDiagnoses(hospital.getHospital().getId(), request); //TODO hospital.getHospital().getId() 중복 코드가 존재합니다.
        return ResponseUtility.success("검사 항목이 성공적으로 생성되었습니다.", response);
    }

    @DeleteMapping("/{diagnosisId}")
    public ResponseEntity<?> deleteDiagnosis(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                             @PathVariable Integer diagnosisId
    ){
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        diagnosisService.deleteDiagnosis(hospitalId, diagnosisId);
        return ResponseUtility.emptyResponse("검사 항목이 성공적으로 제거 되었습니다.");
    }

    @Operation(summary = "검사 항목 조회", description = "검사 항목을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "403", description = "접근 권한 없음")
    })
    @GetMapping
    public ResponseEntity<?> getDiagnoses(@AuthenticationPrincipal HospitalDetails hospital) {
        List<DiagnosisResponse> response = diagnosisService.getDiagnoses(hospital.getHospital().getId());
        return ResponseUtility.success("검사 전체 조회가 올바르게 성공하였습니다.", response);
    }

    @Operation(summary = "검사 항목 수정", description = "검사 항목을 수정합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수정 성공"),
            @ApiResponse(responseCode = "400", description = "해당 검사 품목을 찾을수없습니다."),
            @ApiResponse(responseCode = "403", description = "해당 병원에서 입력한 검사가 아닙니다.")
    })
    @PutMapping("/{diagnosisId}")
    public ResponseEntity<?> updateDiagnosis(@AuthenticationPrincipal HospitalDetails hospital,
                                             @PathVariable Integer diagnosisId,
                                             @RequestBody DiagnosisRequest request) {
        DiagnosisResponse response = diagnosisService.updateDiagnosis(hospital.getHospital().getId(), diagnosisId, request);
        return ResponseUtility.success("검사 항목이 올바르게 수정되었습니다.", response);
    }

    @Operation(summary = "포함된 검사 항목 조회", description = "이름이 포함된 검사 항목을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수정 성공"),
            @ApiResponse(responseCode = "403", description = "해당 병원에서 입력한 검사가 아닙니다.")
    })
    @GetMapping("/{search}")
    public ResponseEntity<?> containDiagnosis(@AuthenticationPrincipal HospitalDetails hospital,
                                              @PathVariable String search) {
        List<DiagnosisResponse> response = diagnosisService.searchDiagnoses(hospital.getHospital().getId(), search);
        return ResponseUtility.success("요청하신 이름이 포함된 검사 항목입니다.", response);
    }



    @Operation(summary = "검사 항목 자동완성", description = "검색어에 따른 검사 항목 자동완성 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "자동완성 조회 성공")
    })
    @GetMapping("/auto-correct")
    public ResponseEntity<?> autoCorrectDiagnoses(@AuthenticationPrincipal HospitalDetails hospital,
                                                  @RequestParam("search") String search) {
        List<String> suggestions = diagnosisAutoCompleteService.autocorrectKeyword(hospital.getHospital().getId(), search);
        return ResponseUtility.success("검색어에 따른 검사 항목 자동완성 결과입니다.", suggestions);
    }
}

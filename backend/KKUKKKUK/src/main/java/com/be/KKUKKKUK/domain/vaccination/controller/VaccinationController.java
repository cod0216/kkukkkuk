package com.be.KKUKKKUK.domain.vaccination.controller;


import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.vaccination.dto.request.VaccinationRequest;
import com.be.KKUKKKUK.domain.vaccination.dto.response.VaccinationResponse;
import com.be.KKUKKKUK.domain.vaccination.service.VaccinationRedisService;
import com.be.KKUKKKUK.domain.vaccination.service.VaccinationService;
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
 * packageName    : com.be.KKUKKKUK.domain.vaccination.controller<br>
 * fileName       : VaccinationController.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : vaccination의 Contorller 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Tag( name = "예방 접종 관련 API", description = "병원에서 예방 접종 항목을 조회, 추가, 삭제하는 API입니다.")
@RestController
@RequiredArgsConstructor
@RequestMapping("api/vaccinations")
public class VaccinationController {
    private final VaccinationService vaccinationService;
    private final VaccinationRedisService vaccinationAutoCompleteService;


    @Operation(summary = "포함된 예방 접종 항목 생성", description = "이름이 포함된 예방 접종 항목을 생성합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "생성 성공"),
    })
    @PostMapping
    public ResponseEntity<?> createVaccination(@AuthenticationPrincipal HospitalDetails hospital,
                                             @RequestBody VaccinationRequest request){
        VaccinationResponse response= vaccinationService.createVaccinations(hospital.getHospital().getId(), request);
        return ResponseUtility.success("예방 접종 항목이 성공적으로 생성되었습니다.", response);
    }

    @DeleteMapping("/{vaccinationId}")
    public ResponseEntity<?> deleteVaccination(@AuthenticationPrincipal HospitalDetails hospitalDetails,
                                             @PathVariable Integer vaccinationId
    ){
        Integer hospitalId = Integer.parseInt(hospitalDetails.getUsername());
        vaccinationService.deleteVaccination(hospitalId, vaccinationId);
        return ResponseUtility.emptyResponse("접종 항목이 성공적으로 제거 되었습니다.");
    }

    @Operation(summary = "예방 접종 항목 조회", description = "예방 접종 항목을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "조회 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "403", description = "접근 권한 없음")
    })
    @GetMapping
    public ResponseEntity<?> getVaccinations(@AuthenticationPrincipal HospitalDetails hospital) {
        List<VaccinationResponse> response = vaccinationService.getVaccinations(hospital.getHospital().getId());
        return ResponseUtility.success("예방 접종 전체 조회가 올바르게 성공하였습니다.", response);
    }

    @Operation(summary = "예방 접종 항목 수정", description = "예방 접종 항목을 수정합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수정 성공"),
            @ApiResponse(responseCode = "400", description = "해당 접종 품목을 찾을수없습니다."),
            @ApiResponse(responseCode = "403", description = "해당 병원에서 입력한 접종이 아닙니다.")
    })
    @PutMapping("/{vaccinationId}")
    public ResponseEntity<?> updateVaccination(@AuthenticationPrincipal HospitalDetails hospital,
                                             @PathVariable Integer vaccinationId,
                                             @RequestBody VaccinationRequest request) {
        VaccinationResponse response = vaccinationService.updateVaccination(hospital.getHospital().getId(), vaccinationId, request);
        return ResponseUtility.success("예방 접종 항목이 올바르게 수정되었습니다.", response);
    }

    @Operation(summary = "포함된 예방 접종 항목 조회", description = "이름이 포함된 예방 접종 항목을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "수정 성공"),
            @ApiResponse(responseCode = "403", description = "해당 병원에서 입력한 예방 접종이 아닙니다.")
    })
    @GetMapping("/{search}")
    public ResponseEntity<?> containVaccination(@AuthenticationPrincipal HospitalDetails hospital,
                                              @PathVariable String search) {
        List<VaccinationResponse> response = vaccinationService.searchVaccinations(hospital.getHospital().getId(), search);
        return ResponseUtility.success("요청하신 이름이 포함된 예방 접종 항목입니다.", response);
    }



    @Operation(summary = "접종 항목 자동완성", description = "검색어에 따른 접종 항목 자동완성 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "자동완성 조회 성공")
    })
    @GetMapping("/auto-correct")
    public ResponseEntity<?> autoCorrectVaccination(@AuthenticationPrincipal HospitalDetails hospital,
                                                  @RequestParam("search") String search) {
        List<String> suggestions = vaccinationAutoCompleteService.autocorrectKeyword(hospital.getHospital().getId(), search);
        return ResponseUtility.success("검색어에 따른 접종 항목 자동완성 결과입니다.", suggestions);
    }
}

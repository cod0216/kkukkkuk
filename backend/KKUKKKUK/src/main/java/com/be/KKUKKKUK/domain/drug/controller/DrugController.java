package com.be.KKUKKKUK.domain.drug.controller;


import com.be.KKUKKKUK.domain.drug.dto.response.DrugResponse;
import com.be.KKUKKKUK.domain.drug.entity.Drug;
import com.be.KKUKKKUK.domain.drug.service.DrugService;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.drug.controller<br>
 * fileName       : DrugController.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-01<br>
 * description    : 약품을 조회하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.01          eunchang           최초 생성<br>
 * 25.04.02          eunchang           약품 자동완성 및 @AuthenticationPrincipal 추가 <br>
 */
@Tag(name = "약품 조회 API", description = "병원에서 약품을 조회할 수 있는 API입니다.")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/drugs")
public class DrugController {
    private final DrugService drugService;

    @Operation(summary = "약품 조회", description = "약품 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "약품 조회 성공")
    })
    @GetMapping("all") //TODO restful 한게 뭔지 공부해보셔야 할 것 같습니다.
    public ResponseEntity<?> getDrugAll() {
        List<Drug> drugResponses = drugService.getAllDrugs(); //TODO entity 그대로 response 해주는게 맞을까요?
        return ResponseUtility.success("조회된 전체 약품 목록입니다.", drugResponses);
    }

    @Operation(summary = "약품 자동 완성", description = "검색어에 따른 약품 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "약품 검색 성공")
    })
    @GetMapping("/autocomplete")
    public ResponseEntity<?> autocompleteDrugs( //TODO  메서드 명은 앞에 동사로 작성해주세요
            @AuthenticationPrincipal HospitalDetails hospitalDetails, //TODO 이건 없어도 될 것 같습니다.
            @RequestParam("query") String query) { //TODO 검색이면 search 가 더 적절하지 않을까요?
        List<DrugResponse> responses = drugService.searchDrugResponses(query);
        return ResponseUtility.success("검색어에 따른 약품 목록입니다.", responses);
    }

    @Operation(summary = "약품 자동 완성", description = "검색어에 따른 약품 자동완성 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "약품 자동완성 조회 성공")
    })
    @GetMapping("/autocorrect")
    public ResponseEntity<?> autocorrectDrugs(
            @AuthenticationPrincipal HospitalDetails hospitalDetails, //TODO Controller 클래스 메서드의 파라미터를 어떤식으로 배치 할건지 정했는데 이거 물어보세요
            @RequestParam("query") String query) {
        List<String> responses = drugService.autocorrect(query);
        return ResponseUtility.success("검색어에 따른 약품 자동완성 목록입니다.", responses);
    }

    @Operation(summary = "약품 검색", description = "검색어에 따른 약품을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "약품 검색 성공"),
            @ApiResponse(responseCode = "404", description = "해당 약품을 찾을 수 없습니다.")
    })
    @GetMapping
    public ResponseEntity<?> getDrug(
            @AuthenticationPrincipal HospitalDetails hospitalDetails,
            @RequestParam("query") String query) {
        DrugResponse responses = drugService.getDrug(query);
        return ResponseUtility.success("검색어에 따른 약품 입니다.", responses);
    }
}

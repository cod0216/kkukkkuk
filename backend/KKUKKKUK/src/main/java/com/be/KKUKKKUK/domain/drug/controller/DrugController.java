package com.be.KKUKKKUK.domain.drug.controller;


import com.be.KKUKKKUK.domain.breed.dto.response.BreedResponse;
import com.be.KKUKKKUK.domain.breed.service.BreedService;
import com.be.KKUKKKUK.domain.drug.dto.response.DrugResponse;
import com.be.KKUKKKUK.domain.drug.entity.Drug;
import com.be.KKUKKKUK.domain.drug.service.DrugService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
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
    @GetMapping
    public ResponseEntity<?> getDrugAll() {
        List<Drug> drugResponses = drugService.getAllDrugs();
        return ResponseUtility.success("조회된 전체 약품 목록입니다.", drugResponses);
    }
}

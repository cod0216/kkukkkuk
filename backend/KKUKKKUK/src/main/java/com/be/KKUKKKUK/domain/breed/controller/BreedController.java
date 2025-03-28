package com.be.KKUKKKUK.domain.breed.controller;

import com.be.KKUKKKUK.domain.breed.dto.response.BreedResponse;
import com.be.KKUKKKUK.domain.breed.service.BreedService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Objects;

/**
 * packageName    : com.be.KKUKKKUK.domain.breed.controller<br>
 * fileName       : BreedController.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-21<br>
 * description    :  Breed entity controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.21          Fiat_lux            최초 생성<br>
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/breeds")
public class BreedController {
    private final BreedService breedService;

    @Operation(summary = "최상위 품종 목록 조회", description = "고양이 또는 강아지의 상위 품종 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "최상위 품종 조회 성공")
    })
    @GetMapping
    public ResponseEntity<?> getPetParentBreed() {
        List<BreedResponse> breedResponses = breedService.breedResponses();
        return ResponseUtility.success("최상위 종 목록입니다.", breedResponses);
    }

    @Operation(summary = "하위 품종 목록 조회", description = "선택한 상위 품종 ID에 해당하는 하위 품종 목록을 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "하위 품종 조회 성공"),
            @ApiResponse(responseCode = "404", description = "상위 품종 못 찾음")
    })
    @GetMapping("/{parentId}")
    public ResponseEntity<?> getPetChildBreed(@PathVariable Integer parentId) {
        List<BreedResponse> breedResponses = breedService.breedResponseList(parentId);

        return ResponseUtility.success("하위 종 목록입니다.", breedResponses);
    }
}

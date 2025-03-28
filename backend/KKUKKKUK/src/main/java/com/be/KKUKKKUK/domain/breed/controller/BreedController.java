package com.be.KKUKKKUK.domain.breed.controller;

import com.be.KKUKKKUK.domain.breed.dto.response.BreedResponse;
import com.be.KKUKKKUK.domain.breed.service.BreedService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
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

    @GetMapping
    public ResponseEntity<?> getPetParentBreed() {
        List<BreedResponse> breedResponses = breedService.breedResponses();
        return ResponseUtility.success("최상위 종 목록입니다.", breedResponses);
    }


    @GetMapping("/{parentId}")
    public ResponseEntity<?> getPetChildBreed(@PathVariable Integer parentId) {
        List<BreedResponse> breedResponses = breedService.breedResponseList(parentId);

        return ResponseUtility.success("하위 종 목록입니다.", breedResponses);
    }
}

package com.be.KKUKKKUK.domain.pet.controller;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.pet.dto.request.PetUpdateRequest;
import com.be.KKUKKKUK.domain.pet.service.PetComplexService;
import com.be.KKUKKKUK.domain.pet.service.PetService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.pet.controller<br>
 * fileName       : PetController.java<br>
 * author         : haelim<br>
 * date           : 2025-03-19<br>
 * description    : pet entity 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          haelim           최초 생성, 반려동물 조회, 수정, 삭제 api 작성<br>
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/pets")
public class PetController {
    private final PetComplexService petComplexService;
    private final PetService petService;

    @GetMapping("/{petId}")
    public ResponseEntity<?> getPetInfoByPetId(
            @AuthenticationPrincipal OwnerDetails ownerDetails,
            @PathVariable Integer petId) {
        return ResponseUtility.success("반려동물 조회에 성공했습니다.", petService.getPetInfoByPetId(ownerDetails, petId));
    }

    @PatchMapping("/{petId}")
    public ResponseEntity<?> updatePet(
            @AuthenticationPrincipal OwnerDetails ownerDetails,
            @PathVariable Integer petId,
            @RequestBody PetUpdateRequest request
            ){
        return ResponseUtility.success("반려동물 정보 수정에 성공했습니다.", petComplexService.updatePet(ownerDetails, petId, request));
    }

    @DeleteMapping("/{petId}")
    public ResponseEntity<?> deletePet(
            @AuthenticationPrincipal OwnerDetails ownerDetails,
            @PathVariable Integer petId
    ){
        petComplexService.deletePetFromWallet(ownerDetails, petId);
        return ResponseUtility.success("반려동물 삭제에 성공했습니다.");
    }

}

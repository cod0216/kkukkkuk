package com.be.KKUKKKUK.domain.pet.controller;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.pet.dto.request.PetUpdateRequest;
import com.be.KKUKKKUK.domain.pet.service.PetComplexService;
import com.be.KKUKKKUK.domain.pet.service.PetService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import jakarta.validation.constraints.NotNull;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

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
 * 25.03.22          haelim           swagger 작성<br>
 */
@Tag(name = "반려동물 API", description = "반려동물 정보를 조회, 수정, 삭제할 수 있는 API입니다.")
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/pets")
public class PetController {
    private final PetComplexService petComplexService;
    private final PetService petService;

    /**
     * 반려동물 정보를 반려동물의 ID 로 조회합니다.
     * @param ownerDetails 인증된 보호자 계정
     * @param petId 조회할 반려동물 ID
     * @return 조회된 반려동물 정보
     */
    @Operation(summary = "반려동물 조회", description = "반려동물 ID를 이용하여 정보를 조회합니다.")
    @GetMapping("/{petId}")
    public ResponseEntity<?> getPetInfoByPetId(@AuthenticationPrincipal OwnerDetails ownerDetails,
                                               @PathVariable @Min(1) Integer petId
    ) {
        return ResponseUtility.success("반려동물 조회에 성공했습니다.", petComplexService.getPetInfoByPetId(ownerDetails, petId));
    }

    /**
     * 반려동물 정보를 수정합니다.
     * @param ownerDetails 인증된 보호자 계정
     * @param petId 수정할 반려동물 ID
     * @param request 반려동물 정보 수정 요청
     * @return 수정된 반려동물 정보
     */
    @Operation(summary = "반려동물 수정", description = "반려동물 정보를 수정합니다.")
    @PatchMapping("/{petId}")
    public ResponseEntity<?> updatePet(@AuthenticationPrincipal OwnerDetails ownerDetails,
                                       @PathVariable @Min(1) Integer petId,
                                       @RequestBody @Valid PetUpdateRequest request
    ){
        return ResponseUtility.success("반려동물 정보 수정에 성공했습니다.", petComplexService.updatePet(ownerDetails, petId, request));
    }

    /**
     * 반려동물을 지갑에서 삭제합니다.
     * 실제 데이터베이스에서 삭제하는 것이 아닌, 지갑과의 관계를 끊습니다.
     * @param ownerDetails 인증된 보호자 계정
     * @param petId 수정할 반려동물 ID
     */
    @Operation(summary = "반려동물 삭제", description = "반려동물을 지갑에서 삭제합니다.")
    @DeleteMapping("/{petId}")
    public ResponseEntity<?> deletePet(@AuthenticationPrincipal OwnerDetails ownerDetails,
                                       @PathVariable @Min(1) Integer petId
    ){
        petComplexService.deletePetFromWallet(ownerDetails, petId);
        return ResponseUtility.emptyResponse("반려동물 삭제에 성공했습니다.");
    }

    /**
     * 반려동물 프로필을 업로드합니다.
     * @param ownerDetails 인증된 보호자 계정
     * @param petId 프로필 변경할 반려동물 ID
     * @return 수정된 이미지 url
     */
    @Operation(summary = "반려동물 프로필 이미지 변경", description = "반려동물 프로필 이미지를 업로드합니다.")
    @PostMapping(path = "/{petId}/images", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<?> uploadPetImage(@AuthenticationPrincipal OwnerDetails ownerDetails,
                                            @PathVariable @Min(1) Integer petId,
                                            @RequestParam("image") @NotNull MultipartFile imageFile
    ) {
        return ResponseUtility.success("반려동물 프로필 업로드에 성공했습니다.", petComplexService.updatePetImage(ownerDetails, petId, imageFile));
    }


}

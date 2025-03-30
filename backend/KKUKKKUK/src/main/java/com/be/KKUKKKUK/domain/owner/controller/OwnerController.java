package com.be.KKUKKKUK.domain.owner.controller;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.owner.dto.request.OwnerUpdateRequest;
import com.be.KKUKKKUK.domain.owner.service.OwnerComplexService;
import com.be.KKUKKKUK.domain.owner.service.OwnerService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import lombok.RequiredArgsConstructor;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.controller<br>
 * fileName       : OwnerController.java<br>
 * author         : haelim<br>
 * date           : 2025-03-17<br>
 * description    : owner entity 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.17          haelim           최초 생성<br>
 * 25.03.22          haelim           swagger 작성<br>
 * 25.03.30          haelim           프로필 이미지 수정<br>
 */
@Tag(name = "보호자 API", description = "보호자 정보를 관리하는 API입니다.")
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/owners")
public class OwnerController {
    private final OwnerComplexService ownerComplexService;
    private final OwnerService ownerService;

    /**
     * 현재 로그인된 보호자 회원의 상세 정보를 반환합니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @return 보호자 회원의 상세 정보
     */
    @Operation(summary = "프로필 조회", description = "현재 로그인한 계정의 프로필 정보를 조회합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "프로필 조회 성공"),
            @ApiResponse(responseCode = "401", description = "인증 실패")
    })
    @GetMapping("/me")
    public ResponseEntity<?> getMyInfo(@AuthenticationPrincipal OwnerDetails ownerDetails) {
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        return ResponseUtility.success("현재 로그인한 계정의 프로필 정보입니다.", ownerComplexService.getOwnerInfoWithWallet(ownerId));
    }

    /**
     * 현재 로그인된 보호자 회원의 정보를 수정합니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @param request 정보 업데이트 요청
     * @return 변경된 보호자 회원의 상세 정보
     */
    @Operation(summary = "프로필 수정", description = "현재 로그인한 계정의 프로필 정보를 수정합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "프로필 수정 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "401", description = "인증 실패")
    })
    @PatchMapping("/me")
    public ResponseEntity<?> updateMyInfo(@AuthenticationPrincipal OwnerDetails ownerDetails, @RequestBody OwnerUpdateRequest request) {
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        return ResponseUtility.success("계정 정보가 성공적으로 업데이트되었습니다.", ownerService.updateOwnerInfo(ownerId, request));
    }

    @Operation(summary = "프로필 수정", description = "현재 로그인한 계정의 프로필 이미지를 수정합니다.")
    @ApiResponses({
            @ApiResponse(responseCode = "200", description = "이미지 수정 성공"),
            @ApiResponse(responseCode = "400", description = "잘못된 요청"),
            @ApiResponse(responseCode = "401", description = "인증 실패"),
            @ApiResponse(responseCode = "500", description = "서버 오류"),
    })
    @PostMapping(path = "/me/images", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<?> updateOwnerImage(
            @AuthenticationPrincipal OwnerDetails ownerDetails,
            @RequestParam("image") MultipartFile imageFile
    ){
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        return ResponseUtility.success("계정 프로필이 성공적으로 업데이트되었습니다.", ownerComplexService.updateOwnerImage(ownerId, imageFile));
    }
}

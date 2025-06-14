package com.be.KKUKKKUK.domain.wallet.controller;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.domain.wallet.service.WalletComplexService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.tags.Tag;
import jakarta.validation.Valid;
import jakarta.validation.constraints.Min;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.controller<br>
 * fileName       : WalletController.java<br>
 * author         : haelim<br>
 * date           : 2025-03-20<br>
 * description    : Wallet entity 요청을 처리하는 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.20          haelim           최초 생성, 지갑 CRUD, 지갑에 대한 반려동물 등록, 조회 api <br>
 * 25.03.22          haelim           swagger 작성 <br>
 * 25.03.28          haelim           wallet 여러 개 등록 가능하도록 수정 <br>
 * 25.04.01          haelim           pet 조회 api 삭제 <br>
 */
@Tag(name = "디지털 지갑 API", description = "지갑 정보를 등록, 조회, 수정, 삭제, 복구, 지갑에 반려동물을 추가 / 조회할 수 있는 API입니다.")
@Validated
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/wallets")
public class WalletController {
    private final WalletComplexService walletComplexService;

    /**
     * 현재 로그인된 사용자의 지갑 정보를 등록합니다.
     * @param owner   인증된 보호자 계정 정보
     * @param request 지갑 등록 요청
     * @return 등록 완료된 지갑의 정보
     */
    @Operation(summary = "지갑 등록", description = "현재 로그인된 사용자에게 지갑 정보를 등록합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "지갑 등록 성공"),
            @ApiResponse(responseCode = "409", description = "이미 등록된 지갑")
    })
    @PostMapping
    public ResponseEntity<?> registerMyWallet(@AuthenticationPrincipal OwnerDetails owner,
                                              @RequestBody @Valid WalletRegisterRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑이 성공적으로 등록되었습니다.", walletComplexService.registerWallet(ownerId, request));
    }

    /**
     * 현재 로그인된 보호자 회원의 지갑 목록을 조회합니다.
     * @param owner 인증된 보호자 계정 정보
     * @return 현재 로그인된 회원의 지갑 정보
     */
    @Operation(summary = "지갑 정보 전체 조회", description = "현재 로그인된 보호자 회원의 모든 지갑 정보를 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "지갑 정보 조회 성공"),
    })
    @GetMapping
    public ResponseEntity<?> getAllWalletInfo(@AuthenticationPrincipal OwnerDetails owner) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("현재 로그인한 계정의 디지털 지갑 목록입니다.", walletComplexService.getWalletInfoByOwnerId(ownerId));
    }

    /**
     * 특정 지갑 정보를 조회합니다.
     * @param owner 인증된 보호자 계정 정보
     * @return 조회된 지갑의 상세 정보
     */
    @Operation(summary = "지갑 정보 상세 조회", description = "현재 로그인된 보호자 회원의 모든 지갑 정보를 조회합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "지갑 정보 조회 성공"),
            @ApiResponse(responseCode = "403", description = "지갑에 대한 권한 없음"),
            @ApiResponse(responseCode = "404", description = "지갑을 찾을 수 없음"),
    })
    @GetMapping("/{walletId}")
    public ResponseEntity<?> getWalletInfo(@AuthenticationPrincipal OwnerDetails owner,
                                           @PathVariable @Min(1) Integer walletId
    ){
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("현재 로그인한 계정의 디지털 지갑 목록입니다.", walletComplexService.getWalletInfoByWalletId(ownerId, walletId));
    }


    /**
     * 특정 지갑 정보를 수정합니다.
     * @param owner   인증된 보호자 계정 정보
     * @param request 지갑 수정 요청
     * @return 수정 완료된 지갑의 정보
     */
    @Operation(summary = "지갑 정보 수정", description = "특정 지갑 정보를 수정합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "지갑 정보 수정 성공"),
            @ApiResponse(responseCode = "403", description = "지갑에 대한 권한 없음"),
            @ApiResponse(responseCode = "404", description = "지갑을 찾을 수 없음"),
    })
    @PutMapping("/{walletId}")
    public ResponseEntity<?> updateWallet(@AuthenticationPrincipal OwnerDetails owner,
                                          @PathVariable @Min(1) Integer walletId,
                                          @RequestBody @Valid WalletUpdateRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑 정보가 성공적으로 업데이트되었습니다.", walletComplexService.updateWallet(ownerId, walletId, request));
    }

    /**
     * 현재 로그인된 사용자의 지갑 정보를 삭제합니다.
     * @param owner 인증된 보호자 계정 정보
     */
    @Operation(summary = "지갑 삭제", description = "현재 로그인된 사용자의 지갑 정보를 삭제합니다.")
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "지갑 삭제 성공"),
            @ApiResponse(responseCode = "403", description = "지갑에 대한 권한 없음"),
            @ApiResponse(responseCode = "404", description = "지갑을 찾을 수 없음"),
    })
    @DeleteMapping("/{walletId}")
    public ResponseEntity<?> deleteMyWalletById(@AuthenticationPrincipal OwnerDetails owner,
                                                @PathVariable @Min(1) Integer walletId
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        walletComplexService.deleteWalletByWalletId(ownerId, walletId);
        return ResponseUtility.emptyResponse("지갑 정보가 정상적으로 삭제되었습니다.");
    }


}
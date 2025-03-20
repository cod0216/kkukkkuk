package com.be.KKUKKKUK.domain.wallet.controller;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.pet.dto.request.PetRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.domain.wallet.service.WalletComplexService;
import com.be.KKUKKKUK.domain.wallet.service.WalletService;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import jakarta.validation.Valid;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
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
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/wallets")
public class WalletController {
    private final WalletComplexService walletComplexService;
    private final WalletService walletService;

    /**
     * 현재 로그인된 보호자 회원의 지갑 정보를 조회합니다.
     * @param owner 인증된 보호자 계정 정보
     * @return 현재 로그인된 회원의 지갑 정보
     */
    @GetMapping("/me")
    public ResponseEntity<?> getMyWalletInfo(@AuthenticationPrincipal OwnerDetails owner) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("현재 로그인한 계정의 디지털 지갑 정보입니다.", walletService.getWalletInfoByOwnerId(ownerId));
    }

    /**
     * 현재 로그인된 사용자의 지갑 정보를 요청합니다.
     * @param owner 인증된 보호자 계정 정보
     * @param request 지갑 등록 요청
     * @return 등록 완료된 지갑의 정보
     */
    @PostMapping("/me")
    public ResponseEntity<?> registerMyWallet(
            @AuthenticationPrincipal OwnerDetails owner,
            @RequestBody WalletRegisterRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑이 성공적으로 등록되었습니다.", walletComplexService.registerWallet(ownerId, request));
    }

    /**
     * 현재 로그인된 사용자의 지갑 정보를 수정합니다.
     * @param owner 인증된 보호자 계정 정보
     * @param request 지갑 수정 요청
     * @return 수정 완료된 지갑의 정보
     */
    @PutMapping("/me")
    public ResponseEntity<?> updateMyWallet(
            @AuthenticationPrincipal OwnerDetails owner,
            @RequestBody WalletUpdateRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑 정보가 성공적으로 업데이트되었습니다.", walletService.updateWallet(ownerId, request));
    }

    /**
     * 현재 로그인된 사용자의 지갑 정보를 삭제합니다.
     * @param owner 인증된 보호자 계정 정보
     */
    @DeleteMapping("/me")
    public ResponseEntity<?> deleteMyWalletById(
            @AuthenticationPrincipal OwnerDetails owner
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        walletComplexService.deleteWallet(ownerId);
        return ResponseUtility.success("지갑 정보가 정상적으로 삭제되었습니다.", null);
    }

    /**
     * 사용자의 지갑 복구를 위해 개인 키 정보를 조회합니다.
     * @param owner 인증된 보호자 계정 정보
     * @return 암호화된 개인키
     */
    @PostMapping("/me/recover")
    public ResponseEntity<?> recoverMyWallet(
            @AuthenticationPrincipal OwnerDetails owner
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("암호화된 개인키 정보입니다.", walletService.recoverWallet(ownerId));
    }

    /**
     * 로그인된 사용자 지갑에 새로운 반려동물을 등록합니다.
     * @param ownerDetails 인증된 보호자 회원
     * @param request 반려동물 등록 요청
     * @return 등록된 반려동물 정보
     */
    @PostMapping("/me/pets")
    public ResponseEntity<?> registerPet(
            @AuthenticationPrincipal OwnerDetails ownerDetails,
            @RequestBody @Valid PetRegisterRequest request) {
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        return ResponseUtility.success("반려동물 등록에 성공했습니다.", walletComplexService.registerPet(ownerId, request));
    }

    /**
     * 로그인된 사용자 지갑에 있는 반려동물 목록을 조회합니다.
     * @param ownerDetails 인증된 보호자 회원
     * @return 조회된 반려동물 목록
     */
    @GetMapping("/me/pets")
    public ResponseEntity<?> getPetInfoList(@AuthenticationPrincipal OwnerDetails ownerDetails) {
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        return ResponseUtility.success("반려동물 전체 목록 조회에 성공했습니다.", walletComplexService.getPetInfoListByOwnerId(ownerId));
    }

}

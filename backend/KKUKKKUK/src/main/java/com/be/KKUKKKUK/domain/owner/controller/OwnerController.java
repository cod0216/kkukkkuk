package com.be.KKUKKKUK.domain.owner.controller;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.owner.dto.request.OwnerUpdateRequest;
import com.be.KKUKKKUK.domain.owner.service.OwnerComplexService;
import com.be.KKUKKKUK.domain.owner.service.OwnerService;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

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
 */
@RestController
@RequiredArgsConstructor
@RequestMapping("/api/owners")
public class OwnerController {
    private final OwnerComplexService ownerComplexService;
    private final OwnerService ownerService;

    /**
     * 현재 로그인된 보호자 회원의 상세 정보를 반환합니다.
     * @param owner 인증된 보호자 계정 정보
     * @return 보호자 회원의 상세 정보
     */
    @GetMapping("/me")
    public ResponseEntity<?> getMyInfo(@AuthenticationPrincipal OwnerDetails owner) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("현재 로그인한 계정의 프로필 정보입니다.", ownerComplexService.getOwnerInfoWithWallet(ownerId));
    }

    /**
     * 현재 로그인된 보호자 회원의 정보를 수정합니다.
     * @param owner 인증된 보호자 계정 정보
     * @param request 정보 업데이트 요청
     * @return 변경된 보호자 회원의 상세 정보
     */
    @PatchMapping("/me")
    public ResponseEntity<?> updateMyInfo(@AuthenticationPrincipal OwnerDetails owner, @RequestBody OwnerUpdateRequest request) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("계정 정보가 성공적으로 업데이트되었습니다.", ownerService.updateOwnerInfo(ownerId, request));
    }

    /**
     * 현재 로그인된 보호자 회원의 지갑 정보를 조회합니다.
     * @param owner 인증된 보호자 계정 정보
     * @return 현재 로그인된 회원의 지갑 정보
     */
    @GetMapping("/me/wallets")
    public ResponseEntity<?> getMyWalletInfo(@AuthenticationPrincipal OwnerDetails owner) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("현재 로그인한 계정의 디지털 지갑 정보입니다.", ownerComplexService.getWallet(ownerId));
    }

    /**
     * 현재 로그인된 사용자의 지갑 정보를 요청합니다.
     * @param owner 인증된 보호자 계정 정보
     * @param request 지갑 등록 요청
     * @return 등록 완료된 지갑의 정보
     */
    @PostMapping("/me/wallets")
    public ResponseEntity<?> registerMyWallet(
            @AuthenticationPrincipal OwnerDetails owner,
            @RequestBody WalletRegisterRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑이 성공적으로 등록되었습니다.", ownerComplexService.registerWallet(ownerId, request));
    }

    /**
     * 현재 로그인된 사용자의 지갑 정보를 수정합니다.
     * @param owner 인증된 보호자 계정 정보
     * @param request 지갑 수정 요청
     * @return 수정 완료된 지갑의 정보
     */
    @PutMapping("/me/wallets")
    public ResponseEntity<?> updateMyWallet(
            @AuthenticationPrincipal OwnerDetails owner,
            @RequestBody WalletUpdateRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑 정보가 성공적으로 업데이트되었습니다.", ownerComplexService.updateWallet(ownerId, request));
    }

    /**
     * 현재 로그인된 사용자의 지갑 정보를 삭제합니다.
     * @param owner 인증된 보호자 계정 정보
     */
    @DeleteMapping("/me/wallets")
    public ResponseEntity<?> deleteMyWalletById(
            @AuthenticationPrincipal OwnerDetails owner
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        ownerComplexService.deleteWallet(ownerId);
        return ResponseUtility.success("지갑 정보가 정상적으로 삭제되었습니다.", null);
    }

    /**
     * 사용자의 지갑 복구를 위해 개인 키 정보를 조회합니다.
     * @param owner 인증된 보호자 계정 정보
     * @return 암호화된 개인키
     */
    @PostMapping("/me/wallets/recover")
    public ResponseEntity<?> recoverMyWallet(
            @AuthenticationPrincipal OwnerDetails owner
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("암호화된 개인키 정보입니다.", ownerComplexService.recoverWallet(ownerId));
    }
}

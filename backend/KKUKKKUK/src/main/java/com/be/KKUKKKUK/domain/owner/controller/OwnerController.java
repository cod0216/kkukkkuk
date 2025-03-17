package com.be.KKUKKKUK.domain.owner.controller;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.owner.service.OwnerService;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.global.util.ResponseUtility;
import lombok.RequiredArgsConstructor;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.*;

@RequestMapping("/api/owners")
@RestController
@RequiredArgsConstructor
public class OwnerController {
    private final OwnerService ownerService;












    @GetMapping("/me/wallets")
    public ResponseEntity<?> getMyWalletInfo(
            @AuthenticationPrincipal OwnerDetails owner
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑 정보가 성공적으로 업데이트되었습니다.", ownerService.getWallet(ownerId));
    }

    @PostMapping("/me/wallets")
    public ResponseEntity<?> registerMyWallet(
            @AuthenticationPrincipal OwnerDetails owner,
            @RequestBody WalletRegisterRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑 정보가 성공적으로 업데이트되었습니다.", ownerService.registerWallet(ownerId, request));
    }

    @PutMapping("/me/wallets")
    public ResponseEntity<?> updateMyWallet(
            @AuthenticationPrincipal OwnerDetails owner,
            @RequestBody WalletUpdateRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑 정보가 성공적으로 업데이트되었습니다.", ownerService.updateWallet(ownerId, request));
    }

    @DeleteMapping("/me/wallets")
    public ResponseEntity<?> deleteMyWalletById(
            @AuthenticationPrincipal OwnerDetails owner,
            @RequestBody WalletUpdateRequest request
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        ownerService.deleteWallet(ownerId);
        return ResponseUtility.success("지갑 정보가 정상적으로 삭제되었습니다.", null);
    }

    @PostMapping("/me/wallets/recover")
    public ResponseEntity<?> recoverMyWallet(
            @AuthenticationPrincipal OwnerDetails owner
    ) {
        Integer ownerId = Integer.parseInt(owner.getUsername());
        return ResponseUtility.success("지갑 정보가 성공적으로 업데이트되었습니다.", ownerService.recoverWallet(ownerId));
    }
}

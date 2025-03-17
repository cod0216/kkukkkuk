package com.be.KKUKKKUK.domain.owner.service;

import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.domain.auth.dto.request.OwnerLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.OwnerLoginResponse;
import com.be.KKUKKKUK.domain.auth.service.TokenService;
import com.be.KKUKKKUK.domain.owner.dto.response.OwnerDetailInfoResponse;
import com.be.KKUKKKUK.domain.owner.dto.response.OwnerInfoResponse;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletRecoverResponse;
import com.be.KKUKKKUK.domain.wallet.service.WalletService;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;


/**
 * packageName    : com.be.KKUKKKUK.domain.owner.service<br>
 * fileName       : OwnerService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Owner entity 에 대한 상위 레벨의 service 클래스입니다.<br>
 *                  OwnerService, TokenService, WalletService 등 하위 모듈 Service 를 통해
 *                  복잡한 비즈니스 로직을 수행합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.17          haelim           OwnerService 와 계층화, 지갑 관련 CURD 메소드 추가<br>
 */
@Service
@RequiredArgsConstructor
public class OwnerComplexService {
    private final OwnerService ownerService;
    private final TokenService tokenService;
    private final WalletService walletService;

    public OwnerDetailInfoResponse getOwnerInfoWithWallet(Integer ownerId) {
        OwnerInfoResponse ownerInfo = ownerService.getOwnerInfo(ownerId);
        WalletInfoResponse walletInfo = walletService.getWalletInfoByOwnerId(ownerId);

        return new OwnerDetailInfoResponse(ownerInfo, walletInfo);
    }

    /**
     * Owner 로그인 또는 회원가입을 처리하는 메서드입니다.
     *
     * @param request 로그인 요청 정보 (providerId, name, email 등)
     * @return OwnerLoginResponse 로그인 응답 정보 (소유자 정보, JWT 토큰, 지갑 정보)
     */
    @Transactional
    public OwnerLoginResponse loginOrSignup(OwnerLoginRequest request) {
        // 1. 사용자 정보 불러오기
        OwnerInfoResponse ownerInfo = ownerService.tryLoginOrSignUp(request);

        // 2. 사용자 지갑 정보 요청
        WalletInfoResponse wallet = walletService.getWalletInfoByOwnerId(ownerInfo.getId());

        // 3. JWT 토큰 발급
        JwtTokenPairResponse tokenPair = tokenService.generateTokens(ownerInfo.getId(), RelatedType.OWNER);

        return new OwnerLoginResponse(ownerInfo, tokenPair, wallet);
    }

    /**
     * 보호자의 지갑을 신규로 생성합니다.
     *
     * @param ownerId 지갑 등록 요청한 보호자 ID
     * @param request 등록할 지갑 정보
     * @return 등록된 지갑 정보
     */
    @Transactional
    public WalletInfoResponse registerWallet(Integer ownerId, WalletRegisterRequest request) {
        Owner owner = ownerService.getOwnerById(ownerId);
        return walletService.registerWallet(owner, request);
    }

    /**
     *
     * 보호자의 지갑 정보를 조회합니다.
     *
     * @param ownerId 보호자 ID
     * @return 등록된 지갑 정보
     */
    @Transactional(readOnly = true)
    public WalletInfoResponse getWallet(Integer ownerId) {
        return walletService.getWalletInfoByOwnerId(ownerId);
    }

    /**
     *
     * 보호자의 지갑 정보를 업데이트합니다.
     *
     * @param ownerId 업데이트 요청한 보호자 ID
     * @return 등록된 지갑 정보
     */
    @Transactional
    public WalletInfoResponse updateWallet(Integer ownerId, WalletUpdateRequest request) {
        return walletService.updateWallet(ownerId, request);
    }

    /**
     * 보호자의 지갑을 삭제합니다.
     * @param ownerId 삭제 요청한 보호자 ID
     */
    @Transactional
    public void deleteWallet(Integer ownerId) {
        walletService.deleteWalletByOwnerId(ownerId);
    }

    /**
     * 보호자의 지갑 복구를 위한 개인키를 조회합니다..
     * @param ownerId 삭제 요청한 보호자 ID
     */
    @Transactional(readOnly = true)
    public WalletRecoverResponse recoverWallet(Integer ownerId) {
        return walletService.recoverWallet(ownerId);
    }

}

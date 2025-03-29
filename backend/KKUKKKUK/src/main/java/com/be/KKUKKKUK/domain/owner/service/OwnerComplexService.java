package com.be.KKUKKKUK.domain.owner.service;

import com.be.KKUKKKUK.domain.auth.dto.response.JwtTokenPairResponse;
import com.be.KKUKKKUK.domain.auth.dto.request.OwnerLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.OwnerLoginResponse;
import com.be.KKUKKKUK.domain.auth.service.TokenService;
import com.be.KKUKKKUK.domain.owner.dto.response.OwnerDetailInfoResponse;
import com.be.KKUKKKUK.domain.owner.dto.response.OwnerInfoResponse;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletShortInfoResponse;
import com.be.KKUKKKUK.domain.wallet.service.WalletComplexService;
import com.be.KKUKKKUK.domain.wallet.service.WalletService;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;


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
 * 25.03.19          haelim           지갑 관련 CURD 메소드 WalletComplexService 로 이동 <br>
 * 25.03.27          haelim           JWT 토큰에 이름 추가  <br>
 */

@Service
@Transactional
@RequiredArgsConstructor
public class OwnerComplexService {
    private final OwnerService ownerService;
    private final TokenService tokenService;
    private final WalletService walletService;
    private final WalletComplexService walletComplexService;

    /**
     * 특정 보호자(Owner)의 정보를 보호자의 지갑 정보와 함께 조회합니다.
     * @param ownerId 대상 보호자 ID
     * @return 보호자의 정보
     */
    @Transactional(readOnly = true)
    public OwnerDetailInfoResponse getOwnerInfoWithWallet(Integer ownerId) {
        OwnerInfoResponse ownerInfo = ownerService.getOwnerInfo(ownerId);
        List<WalletShortInfoResponse> walletInfo = walletComplexService.getWalletInfoByOwnerId(ownerId);

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
        List<WalletShortInfoResponse> wallets = walletComplexService.getWalletInfoByOwnerId(ownerInfo.getId());

        // 3. JWT 토큰 발급
        JwtTokenPairResponse tokenPair = tokenService.generateTokens(ownerInfo.getId(), ownerInfo.getName(), RelatedType.OWNER);

        return new OwnerLoginResponse(ownerInfo, tokenPair, wallets);
    }

}

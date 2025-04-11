package com.be.KKUKKKUK.domain.wallet.service;

import com.be.KKUKKKUK.domain.owner.dto.response.OwnerShortInfoResponse;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.owner.service.OwnerService;
import com.be.KKUKKKUK.domain.s3.service.S3Service;
import com.be.KKUKKKUK.domain.wallet.dto.mapper.WalletMapper;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletShortInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.walletowner.service.WalletOwnerService;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.service<br>
 * fileName       : WalletComplexService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-20<br>
 * description    : Wallet entity 에 대한 상위 레벨의 service 클래스입니다.<br>
 *                  WalletService, PetService, OwnerService 등 하위 모듈 Service 를 통해
 *                  복잡한 비즈니스 로직을 수행합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.20          haelim           최초 생성<br>
 * 25.03.28          haelim           지갑 여러 개 관리, WalletOwnerService 추가 <br>
 */

@Service
@Transactional
@RequiredArgsConstructor
public class WalletComplexService {
    private final S3Service s3Service;
    private final OwnerService ownerService;
    private final WalletService walletService;
    private final WalletOwnerService walletOwnerService;

    private final WalletMapper walletMapper;

    /**
     * 보호자 회원의 ID 를 통해 디지털 지갑을 찾고, 지갑 정보를 반환합니다.
     * 지갑이 없다면 빈 리스트를 반환합니다.
     *
     * @param ownerId 보호자 회원의 ID
     * @return 디지털 지갑 정보 목록
     */
    @Transactional(readOnly = true)
    public List<WalletShortInfoResponse> getWalletInfoByOwnerId(Integer ownerId) {
        return walletOwnerService.getWalletShortInfoByOwnerId(ownerId);
    }

    /**
     * 지갑 ID 로 특정 지갑의 정보를 조회합니다.
     * @param walletId 조회할 지갑 ID
     * @return 조회된 지갑 상세 정보
     */
    @Transactional(readOnly = true)
    public WalletInfoResponse getWalletInfoByWalletId(Integer ownerId, Integer walletId) {
        Wallet wallet = walletOwnerService.findWalletOwner(ownerId, walletId).getWallet();
        return buildWalletInfoResponse(wallet, walletId);
    }

    /**
     * 보호자에게 지갑을 신규 등록합니다.
     * 기존에 등록된 address 가 있다면 기존 지갑과 연결됩니다.
     * 등록 후 지갑 정보(지갑, 지갑의 다른 보호자, 지갑에 속한 반려동물 목록)과 함께 반환됩니다.
     * @param ownerId 등록할 지갑 주인 ID
     * @param request 등록 요청
     * @return 등록된 지갑 정보
     */
    public WalletInfoResponse registerWallet(Integer ownerId, WalletRegisterRequest request) {
        Owner owner = ownerService.getOwnerById(ownerId);
        Wallet wallet = walletService.getWalletOptionalByWalletAddress(request.getAddress())
                .orElseGet(() -> walletService.saveWallet(request.toWalletEntity()));

        walletOwnerService.connectWalletAndOwner(owner, wallet);
        return buildWalletInfoResponse(wallet, wallet.getId());
    }

    /**
     * 사용자의 지갑 정보를 업데이트합니다.
     * 업데이트 후 지갑 정보(지갑, 지갑의 다른 보호자, 지갑에 속한 반려동물 목록)과 함께 반환됩니다.
     * @param ownerId 업데이트 시도한 보호자 ID
     * @param walletId 업데이트할 지갑 ID
     * @param request 업데이트 요청
     * @return 업데이트된 지갑 정보
     */
    public WalletInfoResponse updateWallet(Integer ownerId, Integer walletId, WalletUpdateRequest request) {
        Wallet wallet = walletOwnerService.findWalletOwner(ownerId, walletId).getWallet();
        walletMapper.updateWalletFromRequest(wallet, request);
        Wallet updateWallet = walletService.saveWallet(wallet);
        return buildWalletInfoResponse(updateWallet, walletId);
    }

    /**
     * 사용자와 지갑 사이의 연결을 끊습니다.
     * @param ownerId 삭제 요청한 사용자 ID
     * @param walletId 삭제할 지갑 ID
     */
    public void deleteWalletByWalletId(Integer ownerId, Integer walletId) {
        walletOwnerService.disconnectWalletAndOwner(ownerId, walletId);
    }

    /**
     * WalletInfoResponse 객체를 만드는 공통 로직 메서드입니다.
     * @param wallet 지갑 entity 객체
     * @param walletId 지갑 ID
     * @return 지갑 정보에 대한 response
     */
    private WalletInfoResponse buildWalletInfoResponse(Wallet wallet, Integer walletId) {
        List<Owner> owners = walletOwnerService.getOwnersByWalletId(walletId);
        List<OwnerShortInfoResponse> ownerInfos = walletMapper.mapOwnersToOwnerShortInfos(owners);
        ownerInfos.forEach(ownerInfo ->
                ownerInfo.setImage(s3Service.getImage(ownerInfo.getId(), RelatedType.OWNER))
        );
        return walletMapper.mapToWalletInfoResponse(wallet, ownerInfos);
    }
}

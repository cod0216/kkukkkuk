package com.be.KKUKKKUK.domain.wallet.service;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.breed.service.BreedService;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.owner.service.OwnerService;
import com.be.KKUKKKUK.domain.pet.dto.request.PetRegisterRequest;
import com.be.KKUKKKUK.domain.pet.dto.response.PetInfoResponse;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.domain.pet.service.PetService;
import com.be.KKUKKKUK.domain.wallet.dto.mapper.WalletMapper;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import com.be.KKUKKKUK.domain.walletowner.entity.WalletOwner;
import com.be.KKUKKKUK.domain.walletowner.service.WalletOwnerService;
import com.be.KKUKKKUK.global.exception.ApiException;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.util.List;
import java.util.Optional;

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
    private final WalletService walletService;
    private final PetService petService;
    private final OwnerService ownerService;
    private final BreedService breedService;
    private final WalletOwnerService walletOwnerService;

    private final WalletMapper walletMapper;


    /**
     * 로그인한 사용자 계정에 반려동물을 신규로 등록합니다.
     * @param ownerId 로그인한 사용자 ID
     * @param request 반려동물 신규 등록 요청
     * @return 등록된 반려동물 정보
     */
    public PetInfoResponse registerPet(Integer ownerId, Integer walletId, PetRegisterRequest request) {
        // 1. 반려동물 entity 객체 생성
        Pet pet = request.toPetEntity();

        // 2. 등록할 지갑 찾기
        Wallet wallet = getWalletByWalletId(ownerId, walletId);

        // 3. 지갑과 반려동물 연결
        pet.setWallet(wallet);

        // 4. 반려동물 품종 조회
        Breed breed = breedService.getBreedById(request.getBreedId());
        pet.setBreed(breed);

        // 반려동물 저장
        return petService.savePetInfo(pet);
    }

    /**
     * 현재 로그인한 회원 지갑의 모든 반려동물 목록을 조회합니다.
     * @param ownerId 현재 로그인한 회원 계정 ID
     * @return 조회된 반려동물 목록
     */
    public List<PetInfoResponse> getPetInfoListByWalletId(Integer ownerId, Integer walletId) {
        Wallet wallet = getWalletByWalletId(ownerId, walletId);
        return petService.findPetInfoListByWalletId(wallet.getId());
    }



    public Wallet getWalletByWalletId(Integer ownerId, Integer walletId) {
        // 1. 지갑 - 보호자 관계 찾기
        WalletOwner walletOwner = walletOwnerService.checkPermission(ownerId, walletId);

        // 2. 지갑 반환
        return walletOwner.getWallet();
    }


    /**
     * 지갑을 신규 등록합니다.
     *
     * @param ownerId 등록할 지갑 주인 ID
     * @param request 등록 요청
     * @return 등록된 지갑 정보
     */
    @Transactional
    public WalletInfoResponse registerWallet(Integer ownerId, WalletRegisterRequest request) throws ApiException {
        // 1. 사용자 entity 불러오기
        Owner owner = ownerService.getOwnerById(ownerId);

        // 1. 이미 지갑이 존재하는지 확인
        Optional<Wallet> optionalWallet = walletService.getWalletOptionalByWalletAddress(request.getAddress());

        Wallet wallet;

        // 2. 기존 지갑 존재하면 기존 지갑 연결
        if(optionalWallet.isPresent()){
            wallet = optionalWallet.get();

        // 3. 존재하지 않으면 지갑 생성
        }else{
            wallet = request.toWalletEntity();
            wallet = walletService.saveWallet(wallet);
        }

        Wallet newWallet = walletOwnerService.connectWalletAndOwner(owner, wallet).getWallet();

        return walletMapper.mapWalletToWalletInfo(newWallet);
    }

    public void deleteWalletByWalletId(Integer ownerId, Integer ownerId1) {
        // TODO :
    }

    public WalletInfoResponse updateWallet(Integer ownerId, Integer walletId, WalletUpdateRequest request) {
        // TODO :
        return null;
    }

    /**
     * 보호자 ID로 보호자의 지갑을 조회합니다.
     * @param ownerId 지갑 주인 ID
     * @return 조회된 지갑 entity
     */
    private List<Wallet> getWalletOptionalByOwnerId(Integer ownerId) {
        // TODO :
        return null;
    }

    /**
     * 보호자 회원의 ID 를 통해 디지털 지갑을 찾고, 지갑 정보를 반환합니다.
     * 지갑이 없다면 null 을 반환합니다.
     *
     * @param ownerId 보호자 회원의 ID
     * @return 디지털 지갑 정보
     */
    @Transactional(readOnly = true)
    public List<WalletInfoResponse> getWalletInfoByOwnerId(Integer ownerId) {
        // TODO :

//        List<Wallet> wallets = walletRepository.findByOwnerId(ownerId);
//        return walletMapper.mapWalletsToWalletInfo(wallets);
        return null;
    }

}


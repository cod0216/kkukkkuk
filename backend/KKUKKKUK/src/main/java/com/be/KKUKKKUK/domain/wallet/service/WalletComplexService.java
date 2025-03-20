package com.be.KKUKKKUK.domain.wallet.service;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.breed.service.BreedService;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.owner.service.OwnerService;
import com.be.KKUKKKUK.domain.pet.dto.request.PetRegisterRequest;
import com.be.KKUKKKUK.domain.pet.dto.response.PetInfoResponse;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.domain.pet.service.PetService;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletRegisterRequest;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
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
 */

@Service
@Transactional
@RequiredArgsConstructor
public class WalletComplexService {
    private final WalletService walletService;
    private final PetService petService;
    private final OwnerService ownerService;
    private final BreedService breedService;

    /**
     * 보호자의 지갑을 신규로 생성합니다.
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
     * TODO : breed 처리
     * 로그인한 사용자 계정에 반려동물을 신규로 등록합니다.
     * @param ownerId 로그인한 사용자 ID
     * @param request 반려동물 신규 등록 요청
     * @return 등록된 반려동물 정보
     */
    public PetInfoResponse registerPet(Integer ownerId, PetRegisterRequest request) {
        Pet pet = request.toPetEntity();

        Wallet wallet = walletService.getWalletByOwnerId(ownerId);
        pet.setWallet(wallet);

        Breed breed = breedService.getBreedById(request.getBreedId());
        pet.setBreed(breed);

        return petService.savePetInfo(pet);
    }

    /**
     * 현재 로그인한 회원 지갑의 모든 반려동물 목록을 조회합니다.
     * @param ownerId 현재 로그인한 회원 계정 ID
     * @return 조회된 반려동물 목록
     */
    public List<PetInfoResponse> getPetInfoListByOwnerId(Integer ownerId) {
        Wallet wallet = walletService.getWalletByOwnerId(ownerId);
        return petService.findPetInfoListByWalletId(wallet.getId());
    }

}

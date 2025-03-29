package com.be.KKUKKKUK.domain.pet.service;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.breed.service.BreedService;
import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.pet.dto.request.PetUpdateRequest;
import com.be.KKUKKKUK.domain.pet.dto.response.PetInfoResponse;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.domain.wallet.service.WalletService;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;

/**
 * packageName    :  com.be.KKUKKKUK.domain.pet.service<br>
 * fileName       :  PetComplexService.java<br>
 * author         :  haelim<br>
 * date           :  2025-03-19<br>
 * description    : Pet entity 에 대한 상위 레벨의 service 클래스입니다.<br>
 *                  WalletService, PetService, BreedService 등 하위 모듈 Service 를 통해
 *                  복잡한 비즈니스 로직을 수행합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          haelim           최초생성, 반려동물 수정 / 조회 메서드 작성 <br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class PetComplexService {
    private final PetService petService;
    private final BreedService breedService;

    /**
     * 특정 반려동물의 정보를 수정합니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @param petId 반려동물의 ID
     * @param request 반려동물 정보 수정 요청
     * @return 수정된 반려동물 정보
     */
    public PetInfoResponse updatePet(OwnerDetails ownerDetails, Integer petId, PetUpdateRequest request){
        // 1. 반려동물 조회
        Pet pet = petService.findPetById(petId);

        // 2. 반려동물에 대한 권한 체크
        checkPetOwner(ownerDetails, pet);

        // 3. 수정사항 반영
        if(!Objects.isNull(request.getName())) pet.setName(request.getName());
        if(!Objects.isNull(request.getFlagNeutering())) pet.setFlagNeutering(request.getFlagNeutering());
        if(!Objects.isNull(request.getGender())) pet.setGender(request.getGender());
        if(!Objects.isNull(request.getDid())) pet.setDid(request.getDid());
        if(!Objects.isNull(request.getBirth())) pet.setBirth(request.getBirth());
        if(!Objects.isNull(request.getBreedId())){
            Breed breed = breedService.getBreedById(request.getBreedId());
            pet.setBreed(breed);
        }

        return petService.savePetInfo(pet);
    }

    /**
     * 특정 반려동물의 정보를 지갑에서 삭제합니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @param petId 반려동물의 ID
     */
    public void deletePetFromWallet(OwnerDetails ownerDetails, Integer petId) {
        // 1. 반려동물 조회
        Pet pet = petService.findPetById(petId);

        // 2. 반려동물에 대한 권한 체크
        checkPetOwner(ownerDetails, pet);

        // 3. 지갑과의 연결만 끊기
        pet.setWallet(null);

        // 4. 변경사항 저장
        petService.savePet(pet);
    }


    /**
     * 현재 로그인한 사용자가 특정 반려동물에 대한 권한이 있는지 확인합니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @param pet 대상 반려동물
     * @throws ApiException 요청자가 해당 반려동물에 대한 권한이 없는 경우 예외처리
     */
    private void checkPetOwner(OwnerDetails ownerDetails, Pet pet) {
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        if(Objects.isNull(pet.getWallet())) throw new ApiException(ErrorCode.PET_NOT_ALLOWED);

//        if(Boolean.FALSE.equals(pet.getWallet().getOwner().getId().equals(ownerId))){
//            throw new ApiException(ErrorCode.PET_NOT_ALLOW);
//        }
    }
}

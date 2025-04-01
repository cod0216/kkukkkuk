package com.be.KKUKKKUK.domain.pet.service;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.breed.service.BreedService;
import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.pet.dto.mapper.PetMapper;
import com.be.KKUKKKUK.domain.pet.dto.request.PetUpdateRequest;
import com.be.KKUKKKUK.domain.pet.dto.response.PetImageResponse;
import com.be.KKUKKKUK.domain.pet.dto.response.PetInfoResponse;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.domain.s3.service.S3Service;
import com.be.KKUKKKUK.domain.walletowner.service.WalletOwnerService;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

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
 * 25.03.30          haelim           이미지 업로드 / 조회 기능 추가 <br>
 */

@Service
@Transactional
@RequiredArgsConstructor
public class PetComplexService {
    private final S3Service s3Service;
    private final PetService petService;
    private final BreedService breedService;
    private final WalletOwnerService walletOwnerService;

    private final PetMapper petMapper;

    /**
     * 반려동물의 ID 로 반려 동물을 개별 조회합니다.
     * 반려동물의 보호자만 조회가 가능합니다.
     * @param petId 조회할 반려동물의 ID
     * @return 조회된 반려동물의 정보
     */
    public PetInfoResponse getPetInfoByPetId(OwnerDetails ownerDetails, Integer petId) {
        Pet pet = petService.findPetById(petId);
        checkPetOwner(ownerDetails, pet);

        PetInfoResponse response = petMapper.mapToPetInfoResponse(pet);
        response.setImage(s3Service.getImage(petId, RelatedType.PET));
        return response;
    }

    /**
     * 특정 반려동물의 정보를 수정합니다.
     * 반려동물의 보호자만 수정이 가능합니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @param petId 반려동물의 ID
     * @param request 반려동물 정보 수정 요청
     * @return 수정된 반려동물 정보
     */
    public PetInfoResponse updatePet(OwnerDetails ownerDetails, Integer petId, PetUpdateRequest request){
        Pet pet = petService.findPetById(petId);
        checkPetOwner(ownerDetails, pet);

        petMapper.updatePetFromRequest(pet, request);
        if(!Objects.isNull(request.getBreedId())){
            Breed breed = breedService.getBreedById(request.getBreedId());
            pet.setBreed(breed);
        }

        return petService.savePetInfo(pet);
    }

    /**
     * 특정 반려동물과 지갑의 연결을 끊습니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @param petId 반려동물의 ID
     */
    public void deletePetFromWallet(OwnerDetails ownerDetails, Integer petId) {
        Pet pet = petService.findPetById(petId);
        checkPetOwner(ownerDetails, pet);
        pet.setWallet(null);
        petService.savePet(pet);
    }

    /**
     * 반려동물의 프로필 이미지를 업로드합니다.
     * 반려동물의 보호자만 이미지 업로드가 가능합니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @param petId 반려동물 ID
     * @param imageFile 변경할 이미지
     * @return 업로드된 이미지 url
     */
    public PetImageResponse updatePetImage(OwnerDetails ownerDetails, Integer petId, MultipartFile imageFile) {
        Pet pet = petService.findPetById(petId);
        checkPetOwner(ownerDetails, pet);
        String image = s3Service.uploadImage(petId, RelatedType.PET, imageFile);
        return new PetImageResponse(image);
    }

    /**
     * 현재 로그인한 사용자가 특정 반려동물에 대한 권한이 있는지 확인합니다.
     * @param ownerDetails 인증된 보호자 계정 정보
     * @param pet 대상 반려동물
     * @throws ApiException 요청자가 해당 반려동물에 대한 권한이 없는 경우 예외처리
     */
    private void checkPetOwner(OwnerDetails ownerDetails, Pet pet) {
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        if(Objects.isNull(pet.getWallet())) {
            throw new ApiException(ErrorCode.PET_NOT_ALLOWED);
        }

        walletOwnerService.findWalletOwner(ownerId, pet.getWallet().getId());
    }
}

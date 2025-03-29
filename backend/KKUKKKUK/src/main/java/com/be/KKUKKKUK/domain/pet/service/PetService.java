package com.be.KKUKKKUK.domain.pet.service;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.pet.dto.mapper.PetMapper;
import com.be.KKUKKKUK.domain.pet.dto.response.PetInfoResponse;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.domain.pet.repository.PetRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;
import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.pet.service<br>
 * fileName       : PetService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-20<br>
 * description    : Pet entity 에 대한 하위 레벨의 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          haelim           최초 생성, 반려동물 조회 / 전체조회 관련 메서드 작성 <br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class PetService {
    private final PetRepository petRepository;
    private final PetMapper petMapper;

    /**
     * 반려동물의 ID 로 반려 동물을 개별 조회합니다.
     * @param petId 조회할 반려동물의 ID
     * @return 조회된 반려동물의 정보
     */
    public PetInfoResponse getPetInfoByPetId(OwnerDetails ownerDetails, Integer petId) {
        // 1. 반려동물 조회
        Pet pet = findPetById(petId);

        // 2. 반려동물에 대한 권한 체크
        checkOwnerAuthority(ownerDetails, pet);

        // 3. 응답
        return petMapper.mapToPetInfoResponse(pet);
    }

    /**
     * 지갑에 속한 반려동물을 전체조회합니다.
     * @param walletId 지갑 ID
     * @return 지갑에 속한 반려동물 정보 목록
     */
    @Transactional(readOnly = true)
    public List<PetInfoResponse> findPetInfoListByWalletId(Integer walletId) {
        return petMapper.mapToPetInfoList(findPetsByWalletId(walletId));
    }

    /**
     * Repository 에서 특정 지갑에 속한 반려동물 목록을 조회합니다.
     * @param walletId 지갑 ID
     * @return 지갑에 속한 반려동물 목록
     */
    private List<Pet> findPetsByWalletId(Integer walletId) {
        return petRepository.findByWalletId(walletId);
    }

    /**
     * 반려동물 ID 로 entity 객체를 조회합니다.
     * @param petId 조회할 반려동물 ID
     * @return 반려동물 entity 객체
     * @throws ApiException ID 로 반려동물을 찾을 수 없는 경우 예외처리
     */
    @Transactional(readOnly = true)
    public Pet findPetById(Integer petId) {
        return findByIdOptional(petId)
                .orElseThrow(() ->  new ApiException(ErrorCode.PET_NOT_FOUND));
    }

    /**
     * 반려동물 ID 로 Repository 에서 entity 객체를 조회합니다.
     * @param petId 조회할 반려동물 ID
     * @return 반려동물 entity 객체, 반려동물을 찾을 수 없는 경우 null
     */
    @Transactional(readOnly = true)
    public Optional<Pet> findByIdOptional(Integer petId) {
        return petRepository.findById(petId);
    }

    /**
     * 반려동물 entity 객체를 Repository 에 저장합니다.
     * @param pet 저장할 반려동물 entity 객체
     * @return 저장된 반려동물 entity 객체
     */
    public Pet savePet(Pet pet) {
        return petRepository.save(pet);
    }

    /**
     * 반려동물 entity 객체를 저장합니다.
     * @param pet 저장할 반려동물 entity 객체
     * @return 저장된 반려동물 정보
     */
    public PetInfoResponse savePetInfo(Pet pet) {
        return petMapper.mapToPetInfoResponse(savePet(pet));
    }

    /**
     * 요청을 시도하는 보호자 회원의 반려동물에 대한 권한을 확인합니다.
     * @param ownerDetails 요청 시도한 보호자 정보
     * @param pet 반려동물 entity 객체
     * @throws ApiException 반려동물이 속한 지갑 주인과 일치하지 않는 경우 예외처리
     */
    private void checkOwnerAuthority(OwnerDetails ownerDetails, Pet pet){
        Integer ownerId = Integer.parseInt(ownerDetails.getUsername());
        if(Objects.isNull(pet.getWallet())) {
            throw new ApiException(ErrorCode.PET_NOT_FOUND);
        }
//        if(!Objects.equals(ownerId, pet.getWallet().getOwner().getId()))
//            throw new ApiException(ErrorCode.PET_NOT_ALLOW);
    }
}

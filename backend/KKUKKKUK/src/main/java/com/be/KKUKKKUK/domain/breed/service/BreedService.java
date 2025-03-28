package com.be.KKUKKKUK.domain.breed.service;

import com.be.KKUKKKUK.domain.breed.dto.mapper.BreedMapper;
import com.be.KKUKKKUK.domain.breed.dto.response.BreedResponse;
import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.breed.repository.BreedRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Objects;

/**
 * packageName    : com.be.KKUKKKUK.domain.breed.service<br>
 * fileName       : BreedService.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-21<br>
 * description    :  Breed Service class 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.21          Fiat_lux           최초생성<br>
 * 25.03.21          haelim             getBreedById 메소드 추가<br>
 */
@Service
@RequiredArgsConstructor
public class BreedService {
    private final BreedRepository breedRepository;
    private final BreedMapper breedMapper;

    @Transactional(readOnly = true)
    public List<BreedResponse> breedResponses() {
        return breedMapper.mapBreedListToBreedResponseList(breedRepository.findBreedByParentIdIsNull());
    }

    @Transactional(readOnly = true)
    public List<BreedResponse> breedResponseList(Integer breedId) {
        Breed parentBreed = breedRepository.findByIdAndParentIdIsNull(breedId)
                .orElseThrow(
                        () -> new ApiException(ErrorCode.BREED_NOT_FOUND));

        List<Breed> breedByParentId = breedRepository.findBreedByParentId(parentBreed);

        return breedMapper.mapBreedListToBreedResponseList(breedByParentId);
    }

    public Breed getBreedById(Integer breedId) {
        return breedRepository.findById(breedId)
                .orElseThrow(() -> new ApiException(ErrorCode.BREED_NOT_FOUND)
                );
    }
}

package com.be.KKUKKKUK.domain.breed.service;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.breed.repository.BreedRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

@Service
@Transactional
@RequiredArgsConstructor
public class BreedService {
    private final BreedRepository breedRepository;
    public Breed getBreedById(Integer breedId){
        return breedRepository.findById(breedId).orElseThrow(
                () -> new ApiException(ErrorCode.INTERNAL_SERVER_ERROR)
        );
    }
}

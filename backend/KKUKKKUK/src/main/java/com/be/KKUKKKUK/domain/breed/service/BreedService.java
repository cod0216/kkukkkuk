package com.be.KKUKKKUK.domain.breed.service;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.breed.repository.BreedRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

/**
 * packageName    : com.be.KKUKKKUK.domain.breed.service<br>
 * fileName       : TokenService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-21<br>
 * description    : Breed entity 에 대한 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.21          haelim           최초 생성<br>
 */
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

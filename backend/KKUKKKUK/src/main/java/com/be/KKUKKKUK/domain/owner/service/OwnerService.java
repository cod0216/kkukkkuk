package com.be.KKUKKKUK.domain.owner.service;

import com.be.KKUKKKUK.domain.auth.dto.request.OwnerLoginRequest;
import com.be.KKUKKKUK.domain.owner.dto.mapper.OwnerMapper;
import com.be.KKUKKKUK.domain.owner.dto.request.OwnerUpdateRequest;
import com.be.KKUKKKUK.domain.owner.dto.response.OwnerInfoResponse;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.owner.repository.OwnerRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.Objects;


/**
 * packageName    : com.be.KKUKKKUK.domain.owner.service<br>
 * fileName       : OwnerService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Owner entity 에 대한 하위 레벨의 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 * 25.03.17          haelim           OwnerComplexService 와 계층화<br>
 */
@Service
@RequiredArgsConstructor
public class OwnerService {
    private final OwnerRepository ownerRepository;
    private final OwnerMapper ownerMapper;

    /**
     * 보호자 회원의 정보를 조회합니다.
     * @param ownerId 조회 요청한 보호자 ID
     * @return 조회된 보호자 정보
     */
    @Transactional(readOnly = true)
    public OwnerInfoResponse getOwnerInfo(Integer ownerId) {
        Owner owner = getOwnerById(ownerId);
        return ownerMapper.mapToOwnerInfoResponse(owner);
    }

    /**
     * 보호자 회원의 정보를 업데이트합니다.
     * @param ownerId 업데이트 요청한 보호자 ID
     * @param request 업데이트 요청
     * @return 업데이트된 보호자 정보
     */
    @Transactional
    public OwnerInfoResponse updateOwnerInfo(Integer ownerId, OwnerUpdateRequest request) {
        Owner owner = getOwnerById(ownerId);

        if(!Objects.isNull(request.getName())) owner.setName(request.getName());
        if(!Objects.isNull(request.getBirth())) owner.setBirth(request.getBirth());

        return ownerMapper.mapToOwnerInfoResponse(ownerRepository.save(owner));
    }


    /**
     * providerId 기준으로 보호자 정보를 조회하거나, 존재하지 않을 경우 회원가입을 수행하는 메서드입니다.
     *
     * @param request 로그인 요청 정보
     * @return OwnerInfo 보호자 기본 정보
     */
    @Transactional(readOnly = true)
    public OwnerInfoResponse tryLoginOrSignUp(OwnerLoginRequest request) {
        Owner owner = ownerRepository.findOwnerByProviderId(request.getProviderId())
                //.map(existingOwner -> updateOwnerInfoWithLogin(existingOwner, request))
                .orElseGet(() -> signUpOwner(request));

        return ownerMapper.mapToOwnerInfo(owner);
    }

    /**
     * 새로운 보호자를 등록하는 메서드입니다.
     *
     * @param request 회원가입 요청 정보
     * @return Owner 생성된 Owner 엔티티
     */
    @Transactional
    public Owner signUpOwner(OwnerLoginRequest request){
        return ownerRepository.save(request.toOwnerEntity());
    }

    /**
     * 보호자 ID 로 보호자를 조회합니다.
     * @param ownerId 보호자 ID
     * @return 조회된 보호자 entity
     */
    @Transactional(readOnly = true)
    public Owner getOwnerById(Integer ownerId){
        return ownerRepository.findOwnerById(ownerId)
                .orElseThrow(() -> new ApiException(ErrorCode.OWNER_NOT_FOUND));
    }
}

package com.be.KKUKKKUK.domain.owner.service;

import com.be.KKUKKKUK.domain.auth.dto.JwtTokenPair;
import com.be.KKUKKKUK.domain.auth.dto.request.OwnerLoginRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.OwnerLoginResponse;
import com.be.KKUKKKUK.domain.auth.service.TokenService;
import com.be.KKUKKKUK.domain.owner.dto.OwnerInfo;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.owner.dto.mapper.OwnerMapper;
import com.be.KKUKKKUK.domain.owner.repository.OwnerRepository;
import com.be.KKUKKKUK.domain.wallet.service.WalletService;
import com.be.KKUKKKUK.domain.wallet.dto.WalletInfo;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.stereotype.Service;

import java.util.Optional;


/**
 * packageName    : com.be.KKUKKKUK.domain.owner.service<br>
 * fileName       : OwnerService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Owner entity 에 대한 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@Service
@Slf4j
@RequiredArgsConstructor
public class OwnerService {
    private final TokenService tokenService;
    private final WalletService walletService;
    private final OwnerRepository ownerRepository;
    private final OwnerMapper ownerMapper;

    public OwnerLoginResponse loginOrSignup(OwnerLoginRequest request) {
        // 1. 사용자 정보 불러오기
        OwnerInfo ownerInfo = getOwnerInfo(request);

        // 2. 사용자 지갑 정보 요청
        WalletInfo wallet = walletService.getWalletByOwnerId(ownerInfo.getId());

        // 3. JWT 토큰 발급
        JwtTokenPair tokenPair = tokenService.generateTokens(ownerInfo.getId(), RelatedType.OWNER);

        return new OwnerLoginResponse(ownerInfo, tokenPair, wallet);
    }


    public OwnerInfo getOwnerInfo(OwnerLoginRequest request) {
        Owner owner = ownerRepository.findOwnerByProviderId(request.getProviderId())
                .map(existingOwner -> updateOwnerInfo(existingOwner, request))
                .orElseGet(() -> signUpOwner(request));

        return ownerMapper.ownerToOwnerInfo(owner);
    }


    public Owner signUpOwner(OwnerLoginRequest request){
        Owner newOwner = request.toOwnerEntity();
        log.info("newOwner: {}", newOwner);
        ownerRepository.save(newOwner);
        return newOwner;
    }

    public Owner updateOwnerInfo(Owner owner, OwnerLoginRequest request) {
        try {
            owner.setName(request.getName());
            owner.setEmail(request.getEmail());
            log.info("updated owner: {}", owner);

            return ownerRepository.save(owner);
        } catch (Exception e) {
            throw new ApiException(ErrorCode.OWNER_REGISTRATION_FAILED);
        }
    }

}

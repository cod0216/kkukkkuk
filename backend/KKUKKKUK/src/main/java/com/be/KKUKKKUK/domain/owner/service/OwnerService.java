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
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

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
@Transactional(readOnly = true)
@Service
@RequiredArgsConstructor
public class OwnerService {
    private final TokenService tokenService;
    private final WalletService walletService;
    private final OwnerRepository ownerRepository;
    private final OwnerMapper ownerMapper;

    /**
     * Owner 로그인 또는 회원가입을 처리하는 메서드입니다.
     *
     * @param request 로그인 요청 정보 (providerId, name, email 등)
     * @return OwnerLoginResponse 로그인 응답 정보 (소유자 정보, JWT 토큰, 지갑 정보)
     */
    public OwnerLoginResponse loginOrSignup(OwnerLoginRequest request) {
        // 1. 사용자 정보 불러오기
        OwnerInfo ownerInfo = getOwnerInfo(request);

        // 2. 사용자 지갑 정보 요청
        WalletInfo wallet = walletService.getWalletInfoByOwnerId(ownerInfo.getId());

        // 3. JWT 토큰 발급
        JwtTokenPair tokenPair = tokenService.generateTokens(ownerInfo.getId(), RelatedType.OWNER);

        return new OwnerLoginResponse(ownerInfo, tokenPair, wallet);
    }

    /**
     * providerId 기준으로 Owner 정보를 조회하거나, 존재하지 않을 경우 회원가입을 수행하는 메서드입니다.
     *
     * @param request 로그인 요청 정보
     * @return OwnerInfo 보호자 기본 정보
     */
    public OwnerInfo getOwnerInfo(OwnerLoginRequest request) {
        Owner owner = ownerRepository.findOwnerByProviderId(request.getProviderId())
                .map(existingOwner -> updateOwnerInfo(existingOwner, request))
                .orElseGet(() -> signUpOwner(request));

        return ownerMapper.ownerToOwnerInfo(owner);
    }

    /**
     * 새로운 Owner를 등록하는 메서드입니다.
     *
     * @param request 회원가입 요청 정보
     * @return Owner 생성된 Owner 엔티티
     */
    @Transactional
    public Owner signUpOwner(OwnerLoginRequest request){
        Owner newOwner = request.toOwnerEntity();
        ownerRepository.save(newOwner);
        return newOwner;
    }

    /**
     * 로그인 시 기존 Owner 정보를 업데이트하는 메서드입니다.
     *
     * @param owner 기존 Owner 엔티티
     * @param request 업데이트할 정보가 담긴 요청 객체
     * @return Owner 업데이트된 Owner 엔티티
     */
    @Transactional
    public Owner updateOwnerInfo(Owner owner, OwnerLoginRequest request) {
        owner.setName(request.getName());
        owner.setEmail(request.getEmail());

        return ownerRepository.save(owner);
    }

}

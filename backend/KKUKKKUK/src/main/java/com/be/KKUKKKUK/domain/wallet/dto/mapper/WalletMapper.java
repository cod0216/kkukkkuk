package com.be.KKUKKKUK.domain.wallet.dto.mapper;

import com.be.KKUKKKUK.domain.owner.dto.response.OwnerShortInfoResponse;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import com.be.KKUKKKUK.domain.wallet.dto.request.WalletUpdateRequest;
import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import com.be.KKUKKKUK.domain.wallet.entity.Wallet;
import org.mapstruct.*;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.dto.mapper<br>
 * fileName       : WalletMapper.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    :  Wallet entity 의 Map struct 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 * 25.03.28          haelim           지갑 여러 개 반환하도록 수정 <br>
 * 25.04.01          haelim           pet 도메인 삭제로 인한 변경 <br>
 */
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface WalletMapper {
    
    @Mapping(target = "id", source = "owner.id")
    @Mapping(target = "name", source = "owner.name")
    List<OwnerShortInfoResponse> mapOwnersToOwnerShortInfos(List<Owner> owners);
    
    @Mapping(target = "id", source = "owner.id")
    @Mapping(target = "name", source = "owner.name")
    OwnerShortInfoResponse mapOwnerToOwnerShortInfo(Owner owner);

    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateWalletFromRequest(@MappingTarget Wallet wallet, WalletUpdateRequest request);

    WalletInfoResponse mapToWalletInfoResponse(Wallet wallet, List<OwnerShortInfoResponse> owners);
}

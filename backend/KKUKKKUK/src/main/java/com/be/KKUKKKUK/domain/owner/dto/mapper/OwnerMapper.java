package com.be.KKUKKKUK.domain.owner.dto.mapper;

import com.be.KKUKKKUK.domain.owner.dto.OwnerDetails;
import com.be.KKUKKKUK.domain.owner.dto.response.OwnerInfoResponse;
import com.be.KKUKKKUK.domain.owner.entity.Owner;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.dto.mapper<br>
 * fileName       : OwnerMapper.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Owner entity 의 Map struct 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 */
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface OwnerMapper {
    OwnerInfoResponse mapToOwnerInfo(Owner owner);

    OwnerDetails mapToOwnerDetails(Owner owner);

    OwnerInfoResponse mapToOwnerInfoResponse(Owner owner);
}

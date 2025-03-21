package com.be.KKUKKKUK.domain.breed.dto.mapper;

import com.be.KKUKKKUK.domain.breed.dto.response.BreedResponse;
import com.be.KKUKKKUK.domain.breed.entity.Breed;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.breed.dto.mapper<br>
 * fileName       : BreedMapper.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-21<br>
 * description    :  Breed entity class 와 dto  클래스의 mapping 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.21          Fiat_lux            최초 생성<br>
 */
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface BreedMapper {
    BreedResponse mapBreedToBreedResponse(Breed breed);

    List<BreedResponse> mapBreedListToBreedResponseList(List<Breed> brredList);
}

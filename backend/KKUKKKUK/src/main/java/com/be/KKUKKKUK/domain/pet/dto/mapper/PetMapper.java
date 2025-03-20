package com.be.KKUKKKUK.domain.pet.dto.mapper;

import com.be.KKUKKKUK.domain.pet.dto.response.PetInfoResponse;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import org.mapstruct.Mapper;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.wallet.dto.mapper<br>
 * fileName       : PetMapper.java<br>
 * author         : haelim<br>
 * date           : 2025-03-19<br>
 * description    :  Pet entity 의 Map struct 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          haelim           최초생성<br>
 */
@Mapper(componentModel = "spring")
public interface PetMapper {
    PetInfoResponse mapToPetInfoResponse(Pet pet);
    List<PetInfoResponse> mapToPetInfoList(List<Pet> pets);
}

package com.be.KKUKKKUK.domain.drug.mapper;

import com.be.KKUKKKUK.domain.drug.dto.response.DrugResponse;
import com.be.KKUKKKUK.domain.drug.entity.Drug;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.drug.mapper<br>
 * fileName       : DrugRepository.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-01<br>
 * description    : Drug entity 의 mapper 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.01          eunchang           최초생성<br>
 * <br>
 */

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface DrugMapper {

    DrugResponse mapToDrugResponse(Drug drug);

    List<DrugResponse> mapDrugToDrugResponse(List<Drug> drugList);

}

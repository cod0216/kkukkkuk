package com.be.KKUKKKUK.domain.drug.mapper;

import com.be.KKUKKKUK.domain.drug.dto.response.DrugResponse;
import com.be.KKUKKKUK.domain.drug.entity.Drug;
import org.mapstruct.Mapper;
import org.mapstruct.ReportingPolicy;

import java.util.List;

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface DrugMapper {

    DrugResponse mapToDrugResponse(Drug drug);

    List<DrugResponse> mapDrugToDrugResponse(List<Drug> drugList);
}

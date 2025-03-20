package com.be.KKUKKKUK.domain.treatment.dto.mapper;

import com.be.KKUKKKUK.domain.treatment.dto.response.TreatmentResponse;
import com.be.KKUKKKUK.domain.treatment.entity.Treatment;
import org.mapstruct.Mapper;

import java.util.List;

@Mapper(componentModel = "spring")
public interface TreatmentMapper {
    List<TreatmentResponse> mapToTreatmentResponseList(List<Treatment> treatmentList);

    TreatmentResponse mapToTreatmentResponse(Treatment treatment);
}

package com.be.KKUKKKUK.domain.vaccination.dto.mapper;

import com.be.KKUKKKUK.domain.vaccination.dto.response.VaccinationResponse;
import com.be.KKUKKKUK.domain.vaccination.entity.Vaccination;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;
import org.mapstruct.ReportingPolicy;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.vaccination.dto.mapper<br>
 * fileName       : vaccinationMapper.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-07<br>
 * description    : vaccination의 Mapper 클래스입니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초생성<br>
 * <br>
 */

@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.ERROR)
public interface VaccinationMapper {
    @Mapping(target = "hospitalId", source = "hospital.id")
    VaccinationResponse mapVaccinationToVaccinationResponse(Vaccination vaccination);
    List<VaccinationResponse> mapVaccinationToVaccinationResponseList(List<Vaccination> vaccinationResponse);
}

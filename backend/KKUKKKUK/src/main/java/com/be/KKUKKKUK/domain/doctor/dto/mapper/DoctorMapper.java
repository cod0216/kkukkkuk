package com.be.KKUKKKUK.domain.doctor.dto.mapper;

import com.be.KKUKKKUK.domain.doctor.dto.response.DoctorInfoResponse;
import com.be.KKUKKKUK.domain.doctor.entity.Doctor;
import org.mapstruct.*;


@Mapper(componentModel = "spring",
        nullValueCheckStrategy = NullValueCheckStrategy.ALWAYS,
        nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.SET_TO_DEFAULT,
        unmappedTargetPolicy = ReportingPolicy.IGNORE
)
public interface DoctorMapper {

    @Mapping(target = "name", defaultValue = "익명")
    DoctorInfoResponse mapToDoctorInfo(Doctor doctor);

}

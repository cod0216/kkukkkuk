package com.be.KKUKKKUK.domain.doctor.dto.mapper;

import com.be.KKUKKKUK.domain.doctor.dto.DoctorInfo;
import com.be.KKUKKKUK.domain.doctor.entity.Doctor;
import org.mapstruct.Mapper;

import java.util.Optional;

@Mapper(componentModel = "spring")
public interface DoctorMapper {
    DoctorInfo doctorToDoctorInfo(Doctor doctor);
}

package com.be.KKUKKKUK.domain.doctor.dto.mapper;

import com.be.KKUKKKUK.domain.doctor.dto.response.DoctorInfoResponse;
import com.be.KKUKKKUK.domain.doctor.entity.Doctor;
import org.mapstruct.Mapper;

//TODO 사용하지 않은 import 문 삭제 해주세요
@Mapper(componentModel = "spring") //TODO mapstruct 설정할때 만약 mapping이 잘 이루어지지 않으면 어떻게 대처할건지도 설정하면 좋을 것 같아요
public interface DoctorMapper {
    DoctorInfoResponse doctorToDoctorInfo(Doctor doctor);
}

package com.be.KKUKKKUK.domain.hospital.dto.mapper;

import com.be.KKUKKKUK.domain.auth.dto.request.HospitalSignupRequest;
import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.dto.request.HospitalUpdateRequest;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalInfoResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalDetailInfoResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalMapInfoResponse;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import org.mapstruct.*;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.hospital.dto.mapper<br>
 * fileName       : HospitalMapper.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    :  Hospital entity 의 Map struct 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 */
@Mapper(componentModel = "spring", unmappedTargetPolicy = ReportingPolicy.IGNORE)
public interface HospitalMapper {
    HospitalInfoResponse mapToHospitalInfo(Hospital hospital);

    HospitalMapInfoResponse mapToHospitalMapInfoResponse(Hospital hospital);

    List<HospitalMapInfoResponse> mapToHospitalMapInfoList(List<Hospital> hospitalList);

    HospitalSignupResponse mapToSignupResponse(Hospital hospital);

    HospitalDetails mapToHospitalDetails(Hospital hospital);

    HospitalDetailInfoResponse mapToHospitalDetailInfoResponse(Hospital hospital);

    @Mapping(target = "password", ignore = true)
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void updateHospitalFromRequest(@MappingTarget Hospital hospital, HospitalUpdateRequest request);

    @Mapping(target = "password", ignore = true)
    @BeanMapping(nullValuePropertyMappingStrategy = NullValuePropertyMappingStrategy.IGNORE)
    void signupHospitalFromRequest(@MappingTarget Hospital hospital, HospitalSignupRequest request);
}


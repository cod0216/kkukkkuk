package com.be.KKUKKKUK.domain.hospital.dto.mapper;

import com.be.KKUKKKUK.domain.auth.dto.response.HospitalSignupResponse;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalDetails;
import com.be.KKUKKKUK.domain.hospital.dto.HospitalInfo;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalAuthorizationResponse;
import com.be.KKUKKKUK.domain.hospital.dto.response.HospitalInfoResponse;
import com.be.KKUKKKUK.domain.hospital.entity.Hospital;
import org.mapstruct.Mapper;

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
@Mapper(componentModel = "spring")
public interface HospitalMapper { //TODO 좀 가독성 좋게 메서드마다 띄어쓰기 하는건 어떨까요?
    HospitalInfo hospitalToHospitalInfo(Hospital hospital);

    HospitalAuthorizationResponse hospitalToHospitalAuthorizationRequest(Hospital hospital);

    HospitalSignupResponse hospitalToHospitalSignupRequest(Hospital hospital);

    HospitalDetails hospitalToHospitalDetails(Hospital hospital);

    HospitalInfoResponse hospitalToHospitalInfoResponse(Hospital hospital);
}


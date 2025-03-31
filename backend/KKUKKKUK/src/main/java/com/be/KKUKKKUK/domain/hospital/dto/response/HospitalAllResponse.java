package com.be.KKUKKKUK.domain.hospital.dto.response;

import lombok.Data;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Data
@Transactional
public class HospitalAllResponse {
    private List<HospitalMapInfoResponse> hospitals; //TODO  변수명 hospitalMapInfoResponseList 어떤가요?
}

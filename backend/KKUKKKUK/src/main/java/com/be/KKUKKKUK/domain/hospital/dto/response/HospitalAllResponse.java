package com.be.KKUKKKUK.domain.hospital.dto.response;

import com.be.KKUKKKUK.domain.hospital.dto.HospitalMapInfo;
import lombok.Data;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Data
@Transactional
public class HospitalAllResponse {
    List<HospitalMapInfo> hospitals;
}

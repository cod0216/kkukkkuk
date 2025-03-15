package com.be.KKUKKKUK.domain.hospital.dto.response;

import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.math.BigDecimal;

@AllArgsConstructor
@Data
public class HospitalInfoResponse {
    private Integer id;

    private String name;

    @JsonProperty("phone_number")
    private String phoneNumber;

    private String did;

    private String account;

    private String password;

    private String address;

    @JsonProperty("public_key")
    private String publicKey;

    @JsonProperty("authoriazation_number")
    private String authorizationNumber;

    @JsonProperty("x_axis")
    private BigDecimal xAxis;

    @JsonProperty("y_axis")
    private BigDecimal yAxis;

    @JsonProperty("license_number")
    private String licenseNumber;

    @JsonProperty("doctor_name")
    private String doctorName;

}

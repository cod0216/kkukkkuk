package com.be.KKUKKKUK.domain.treatment.dto.response;

import com.be.KKUKKKUK.domain.treatment.TreatState;
import com.be.KKUKKKUK.global.enumeration.Gender;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

@Data
@AllArgsConstructor
public class TreatmentResponse {
    private TreatState state;

    private Integer id;

    @JsonProperty("pet_id")
    private Integer petId;

    @JsonProperty("pet_did")
    private String petDid;

    private String name;

    private LocalDate birth;

    @JsonProperty("day_of_birth")
    private Long dayOfBirth;

    private String age;

    private Gender gender;

    @JsonProperty("flag_neutering")
    private Boolean flagNeutering;

    @JsonProperty("breed_name")
    private String breedName;

    @JsonProperty("expire_date")
    private LocalDate expireDate;

    @JsonProperty("created_at")
    private LocalDateTime createdAt;

}

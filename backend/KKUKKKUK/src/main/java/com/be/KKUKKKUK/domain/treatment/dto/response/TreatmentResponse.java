package com.be.KKUKKKUK.domain.treatment.dto.response;

import com.be.KKUKKKUK.domain.treatment.TreatState;
import com.be.KKUKKKUK.global.enumeration.Gender;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;
import java.time.LocalDateTime;

/**
 * packageName    : com.be.KKUKKKUK.domain.treatment.dto.response<br>
 * fileName       : TreatmentResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-19<br>
 * description    : Treatment 엔터티의 정보를 조회하는 DTO 클래스입니다.<br>
 *                  진료 기록에 대한 메타데이터, 진료 중인 pet 정보가 함께 제공됩니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          haelim           최초 생성<br>
 */
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

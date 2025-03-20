package com.be.KKUKKKUK.domain.pet.dto.request;

import com.be.KKUKKKUK.global.enumeration.Gender;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Getter;

import java.time.LocalDate;

/**
 * packageName    :  com.be.KKUKKKUK.domain.pet.dto.request<br>
 * fileName       :  PetRegisterRequest.java<br>
 * author         :  haelim<br>
 * date           :  2025-03-19<br>
 * description    :  Pet 등록 요청을 처리하는 request DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          haelim           최초생성<br>
 */
@Getter
public class PetUpdateRequest {
    private String did;

    private String name;

    private Gender gender;

    @JsonProperty("flag_neutering")
    private Boolean flagNeutering;

    private LocalDate birth;

    @JsonProperty("breed_id")
    private Integer breedId;
}

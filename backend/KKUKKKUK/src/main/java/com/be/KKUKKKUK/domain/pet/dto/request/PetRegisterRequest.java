package com.be.KKUKKKUK.domain.pet.dto.request;

import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.global.enumeration.Gender;
import com.fasterxml.jackson.annotation.JsonProperty;
import jakarta.validation.constraints.NotBlank;
import jakarta.validation.constraints.NotNull;
import lombok.Getter;
import lombok.ToString;

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
@ToString
public class PetRegisterRequest {
    @NotBlank
    private String did;

    @NotBlank
    private String name;

    @NotNull
    private Gender gender;

    @NotNull
    @JsonProperty("flag_neutering")
    private Boolean flagNeutering;

    @NotNull
    private LocalDate birth;

    @NotNull
    @JsonProperty("breed_id")
    private Integer breedId;

    public Pet toPetEntity() {
        return Pet.builder()
                .did(did)
                .name(name)
                .gender(gender)
                .flagNeutering(flagNeutering)
                .birth(birth)
                .build();
    }
}

package com.be.KKUKKKUK.domain.pet.dto.response;

import com.be.KKUKKKUK.global.enumeration.Gender;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;

/**
 * packageName    : com.be.KKUKKKUK.domain.pet.dto<br>
 * fileName       : PetInfoResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Pet 엔터티의 요약 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@Data
@RequiredArgsConstructor
public class PetInfoResponse {
    private Integer id;

    private String did;

    private String name;

    private Gender gender;

    @JsonProperty("flag_neutering")
    private Boolean flagNeutering;

    private LocalDate birth;

    @JsonProperty("bread_id")
    private Integer breedId;
}

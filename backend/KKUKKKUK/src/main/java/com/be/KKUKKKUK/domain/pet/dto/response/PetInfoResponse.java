package com.be.KKUKKKUK.domain.pet.dto.response;

import com.be.KKUKKKUK.global.enumeration.Gender;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import lombok.Data;
import lombok.RequiredArgsConstructor;

import java.time.LocalDate;

/**
 * packageName    : com.be.KKUKKKUK.domain.pet.dto<br>
 * fileName       : PetInfoResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-19<br>
 * description    : Pet 엔터티의 요약 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          haelim           최초 생성<br>
 */
@Data
@RequiredArgsConstructor
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PetInfoResponse {
    private Integer id;

    private String did;

    private String name;

    private Gender gender;

    private Boolean flagNeutering;

    private LocalDate birth;

    private String image;

    private Integer breedId;
}

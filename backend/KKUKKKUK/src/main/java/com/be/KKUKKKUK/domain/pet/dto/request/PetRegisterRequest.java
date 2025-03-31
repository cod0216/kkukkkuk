package com.be.KKUKKKUK.domain.pet.dto.request;

import com.be.KKUKKKUK.domain.pet.entity.Pet;
import com.be.KKUKKKUK.global.enumeration.Gender;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.databind.PropertyNamingStrategies;
import com.fasterxml.jackson.databind.annotation.JsonNaming;
import io.swagger.v3.oas.annotations.media.Schema;
import jakarta.validation.constraints.Min;
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
 * 25.03.24          haelim           swagger, JsonNaming 설정<br>
 */
@Getter
@JsonNaming(PropertyNamingStrategies.SnakeCaseStrategy.class)
public class PetRegisterRequest {
    @NotBlank
    @Schema(description = "반려동물 DID", example = "pet:0xtestpetdid")
    private String did;

    @NotBlank
    @Schema(description = "반려동물 이름", example = "권깡통")
    private String name;

    @NotNull
    @Schema(description = "반려동물 성별(MALE, FEMALE)", example = "MALE")
    private Gender gender;

    @NotNull
    @Schema(description = "중성화 여부", example = "true")
    private Boolean flagNeutering;

    @NotNull
    @Schema(description = "반려동물 생년월일 (YYYY-MM-DD)", example = "2023-01-01")
    private LocalDate birth;

    @Min(1)
    @NotNull
    @Schema(description = "반려동물 품종의 식별 ID", example = "5")
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

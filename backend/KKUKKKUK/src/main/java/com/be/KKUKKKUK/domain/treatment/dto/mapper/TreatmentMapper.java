package com.be.KKUKKKUK.domain.treatment.dto.mapper;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import com.be.KKUKKKUK.domain.treatment.dto.response.TreatmentResponse;
import com.be.KKUKKKUK.domain.treatment.entity.Treatment;
import org.mapstruct.Mapper;
import org.mapstruct.Mapping;

import java.time.LocalDate;
import java.time.Period;
import java.time.temporal.ChronoUnit;
import java.util.List;
import java.util.Objects;

/**
 * packageName    : com.be.KKUKKKUK.domain.treatment.dto.mapper<br>
 * fileName       : TreatmentMapper.java<br>
 * author         : haelim<br>
 * date           : 2025-03-20<br>
 * description    : Treatment entity 에 대한 mapper 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.20          haelim           최초 생성<br>
 */
@Mapper(componentModel = "spring")
public interface TreatmentMapper {
    @Mapping(target = "petId", source = "pet.id")
    @Mapping(target = "petDid", source = "pet.did")
    @Mapping(target = "name", source = "pet.name")
    @Mapping(target = "gender", source = "pet.gender")
    @Mapping(target = "flagNeutering", source = "pet.flagNeutering")
    @Mapping(target = "birth", source = "pet.birth")
    @Mapping(target = "dayOfBirth", expression = "java(calculateAge(treatment.getPet().getBirth()))")
    @Mapping(target = "breedName", expression = "java(formatBreed(treatment.getPet().getBreed()))")
    @Mapping(target = "age", expression = "java(formatAge(treatment.getPet().getBirth()))")
    List<TreatmentResponse> mapToTreatmentResponseList(List<Treatment> treatmentList);

    @Mapping(source = "pet.id", target = "petId")
    @Mapping(source = "pet.did", target = "petDid")
    @Mapping(source = "pet.name", target = "name")
    @Mapping(source = "pet.gender", target = "gender")
    @Mapping(source = "pet.flagNeutering", target = "flagNeutering")
    @Mapping(source = "pet.birth", target = "birth")
    @Mapping(target = "dayOfBirth", expression = "java(calculateAge(treatment.getPet().getBirth()))")
    @Mapping(target = "breedName", expression = "java(formatBreed(treatment.getPet().getBreed()))")
    @Mapping(target = "age", expression = "java(formatAge(treatment.getPet().getBirth()))")
    TreatmentResponse mapToTreatmentResponse(Treatment treatment);

    /**
     * 반려동물의 생일로부터 오늘까지의 날짜를 계산합니다.
     * @param birth 반려동물 생일
     * @return 태어난 날로부터의 일수
     */
    default Long calculateAge(LocalDate birth) {
        return (birth != null) ? ChronoUnit.DAYS.between(birth, LocalDate.now()) : null;
    }

    /**
     * 반려동물의 생일로부터 오늘까지의 날짜를 계산하고, 년, 개월, 일 형식으로 반환합니다.
     * ex)
     * 2년 3개월 (연과 월이 있는 경우)
     * 3개월 (연도 없이 월만 있는 경우)
     * 14일 (연, 월 없이 일만 있는 경우)
     * "년"이 있으면 "일"은 생략 (2년 3개월 14일 x → 2년 3개월 o)
     * @param birth 반려동물 생일
     * @return 년, 개월, 일 형식으로 계산된 나이
     */
    default String formatAge(LocalDate birth) {
        if (Objects.isNull(birth)) return null;

        LocalDate now = LocalDate.now();
        Period period = Period.between(birth, now);

        int years = period.getYears();
        int months = period.getMonths();
        int days = period.getDays();

        StringBuilder sb = new StringBuilder();

        if (years > 0) sb.append(years).append("년 ");
        if (months > 0) sb.append(months).append("개월 ");
        if (days > 0 && years == 0) sb.append(days).append("일");

        return sb.toString().trim();
    }

    /**
     * 반려동물 품종을 String 형식으로 반환합니다.
     * @param breed 반려동물의 품종 entity
     * ex) 개(리트리버), 개
     * @return 변환된 품종 이름
     */
    default String formatBreed(Breed breed) {
        if (breed == null) {
            return null;
        }
        return (breed.getParentId() != null)
                ? breed.getParentId().getName() + "(" + breed.getName() + ")"
                : breed.getName();
    }
}

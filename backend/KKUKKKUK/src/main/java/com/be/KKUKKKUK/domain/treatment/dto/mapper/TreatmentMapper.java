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

    default Long calculateAge(LocalDate birth) {
        return (birth != null) ? ChronoUnit.DAYS.between(birth, LocalDate.now()) : null;
    }

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

    default String formatBreed(Breed breed) {
        if (breed == null) {
            return null;
        }
        return (breed.getParentId() != null)
                ? breed.getParentId().getName() + "(" + breed.getName() + ")"
                : breed.getName();
    }
}

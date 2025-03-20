package com.be.KKUKKKUK.domain.treatment.repository;

import com.be.KKUKKKUK.domain.treatment.TreatStatus;
import com.be.KKUKKKUK.domain.treatment.entity.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface TreatmentRepository extends JpaRepository<Treatment, Integer> {

    List<Treatment> findTreatmentByHospitalIdAndExpireDateAfter(Integer hospitalId, LocalDate now);

    List<Treatment> findTreatmentByHospitalIdAndExpireDateBefore(Integer hospitalId, LocalDate now);

    List<Treatment> findTreatmentByHospitalIdAndStatusAndExpireDateAfter(Integer hospitalId, TreatStatus status, LocalDate now);

    List<Treatment> findTreatmentByHospitalIdAndStatusAndPetIdAndExpireDateAfter(Integer hospitalId, TreatStatus status, Integer petId, LocalDate now);

    List<Treatment> findTreatmentByHospitalIdAndPetIdAndExpireDateAfter(Integer hospitalId, Integer petId, LocalDate now);

    List<Treatment> findTreatmentByHospitalIdAndPetIdAndExpireDateBefore(Integer hospitalId, Integer petId, LocalDate now);

    List<Treatment> findTreatmentByHospitalIdAndStatusAndPetIdAndExpireDateBefore(Integer hospitalId, TreatStatus status, Integer petId, LocalDate now);

    List<Treatment> findTreatmentByHospitalIdAndStatusAndExpireDateBefore(Integer hospitalId, TreatStatus status, LocalDate now);

    List<Treatment> findTreatmentByHospitalId(Integer hospitalId);

    List<Treatment> findTreatmentByHospitalIdAndStatus(Integer hospitalId, TreatStatus status);

    List<Treatment> findTreatmentByHospitalIdAndPetId(Integer hospitalId, Integer petId);

    List<Treatment> findTreatmentByHospitalIdAndStatusAndPetId(Integer hospitalId, TreatStatus status, Integer petId);

}


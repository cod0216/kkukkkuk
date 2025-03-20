package com.be.KKUKKKUK.domain.treatment.repository;

import com.be.KKUKKKUK.domain.treatment.TreatState;
import com.be.KKUKKKUK.domain.treatment.entity.Treatment;
import org.springframework.data.jpa.repository.JpaRepository;

import java.time.LocalDate;
import java.util.List;

public interface TreatmentRepository extends JpaRepository<Treatment, Integer> {

    List<Treatment> findByHospitalIdAndExpireDateAfter(Integer hospitalId, LocalDate now);

    List<Treatment> findByHospitalIdAndExpireDateBefore(Integer hospitalId, LocalDate now);

    List<Treatment> findByHospitalIdAndStateAndExpireDateAfter(Integer hospitalId, TreatState status, LocalDate now);

    List<Treatment> findByHospitalIdAndStateAndPetIdAndExpireDateAfter(Integer hospitalId, TreatState status, Integer petId, LocalDate now);

    List<Treatment> findByHospitalIdAndPetIdAndExpireDateAfter(Integer hospitalId, Integer petId, LocalDate now);

    List<Treatment> findByHospitalIdAndPetIdAndExpireDateBefore(Integer hospitalId, Integer petId, LocalDate now);

    List<Treatment> findByHospitalIdAndStateAndPetIdAndExpireDateBefore(Integer hospitalId, TreatState status, Integer petId, LocalDate now);

    List<Treatment> findByHospitalIdAndStateAndExpireDateBefore(Integer hospitalId, TreatState status, LocalDate now);

    List<Treatment> findTByHospitalId(Integer hospitalId);

    List<Treatment> findByHospitalIdAndState(Integer hospitalId, TreatState status);

    List<Treatment> findByHospitalIdAndPetId(Integer hospitalId, Integer petId);

    List<Treatment> findByHospitalIdAndStateAndPetId(Integer hospitalId, TreatState status, Integer petId);

}


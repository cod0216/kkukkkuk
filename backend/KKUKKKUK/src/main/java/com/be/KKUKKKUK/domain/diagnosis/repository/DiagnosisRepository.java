package com.be.KKUKKKUK.domain.diagnosis.repository;

import com.be.KKUKKKUK.domain.diagnosis.entity.Diagnosis;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

public interface DiagnosisRepository extends JpaRepository<Diagnosis, Integer> {
    List<Diagnosis> getDiagnosesByHospitalId(Integer hospitalId);
    Optional<Diagnosis> getDiagnosisById(Integer diagnosisId);
}

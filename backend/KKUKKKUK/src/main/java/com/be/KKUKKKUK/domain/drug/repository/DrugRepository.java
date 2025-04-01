package com.be.KKUKKKUK.domain.drug.repository;


import com.be.KKUKKKUK.domain.drug.entity.Drug;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.drug.repository<br>
 * fileName       : DrugRepository.java<br>
 * author         : eunchang <br>
 * date           : 2025-04-01<br>
 * description    : Drug entity 의 repository 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.01          eunchang           최초생성<br>
 * 25.04.02          eunchang           최초생성<br>
 * <br>
 */

public interface DrugRepository extends JpaRepository<Drug, Integer> {
    List<Drug> findAll();
    Drug findByNameKrOrNameEn(String kr, String en);
    List<Drug> findByNameKrContainingIgnoreCaseOrNameEnContainingIgnoreCase(String kr, String en);
}

package com.be.KKUKKKUK.domain.drug.repository;


import com.be.KKUKKKUK.domain.drug.entity.Drug;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.drug.repository<br>
 * fileName       : PetRepository.java<br>
 * author         : eunchang <br>
 * date           : 2025-03-19<br>
 * description    : Drug entity 의 repository 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          eunchang           최초생성<br>
 * <br>
 */
public interface DrugRepository extends JpaRepository<Drug, Integer> {
    List<Drug> findAll();
}

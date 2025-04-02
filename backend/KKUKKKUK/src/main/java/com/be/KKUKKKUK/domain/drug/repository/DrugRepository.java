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
    List<Drug> findAll(); //TODO 이미 JpaRepository 에서 정의가 되어 있는데 여기에 다시 정의한 이유가 있을까요?
    Drug findByNameKrOrNameEn(String kr, String en); //TODO 만약 Drug 가 null 이면 어떤식으로 대처 할건가요?
    List<Drug> findByNameKrContainingIgnoreCaseOrNameEnContainingIgnoreCase(String kr, String en);
}

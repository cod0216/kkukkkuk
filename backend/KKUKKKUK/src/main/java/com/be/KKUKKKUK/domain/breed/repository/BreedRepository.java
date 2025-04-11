package com.be.KKUKKKUK.domain.breed.repository;

import com.be.KKUKKKUK.domain.breed.entity.Breed;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;
import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.breed.repository<br>
 * fileName       : BreedRepository.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-21<br>
 * description    :  Breed entity repository 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.21          Fiat_lux            최초 생성<br>
 */
public interface BreedRepository extends JpaRepository<Breed, Integer> {
    List<Breed> findBreedByParentIdIsNull();

    List<Breed> findBreedByParentId(Breed parent);

    Optional<Breed> findByIdAndParentIdIsNull(Integer id);
}

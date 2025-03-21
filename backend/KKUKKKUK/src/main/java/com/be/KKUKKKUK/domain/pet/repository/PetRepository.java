package com.be.KKUKKKUK.domain.pet.repository;
import com.be.KKUKKKUK.domain.pet.entity.Pet;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.List;

/**
 * packageName    : com.be.KKUKKKUK.domain.Pet.repository<br>
 * fileName       : PetRepository.java<br>
 * author         : haelim <br>
 * date           : 2025-03-19<br>
 * description    : Pet entity 의 repository 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.19          haelim           최초생성<br>
 * <br>
 */
public interface PetRepository extends JpaRepository<Pet, Integer> {
    List<Pet> findByWalletId(Integer walletId);
}
package com.be.KKUKKKUK.domain.owner.repository;

import com.be.KKUKKKUK.domain.owner.entity.Owner;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.repository<br>
 * fileName       : OwnerRepository.java<br>
 * author         : haelim <br>
 * date           : 2025-03-13<br>
 * description    : Owner entity 의 repository 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초생성<br>
 * <br>
 */
public interface OwnerRepository extends JpaRepository<Owner, Integer> {
    Optional<Owner> findOwnerByProviderId(String providerId);
}

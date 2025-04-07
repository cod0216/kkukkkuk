package com.be.KKUKKKUK.domain.s3.repository;

import com.be.KKUKKKUK.domain.s3.entity.S3;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

/**
 * packageName    : com.be.KKUKKKUK.domain.s3.repository<br>
 * fileName       : S3Repository.java<br>
 * author         : haelim <br>
 * date           : 2025-03-30<br>
 * description    : S3 entity 의 repository 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.30          haelim           최초생성<br>
 * <br>
 */
public interface S3Repository extends JpaRepository<S3, Integer> {
    Optional<S3> findByRelatedIdAndRelatedType(Integer relativeId, RelatedType relatedType);

    void deleteByRelatedIdAndRelatedType(Integer relativeId, RelatedType relatedType);
}
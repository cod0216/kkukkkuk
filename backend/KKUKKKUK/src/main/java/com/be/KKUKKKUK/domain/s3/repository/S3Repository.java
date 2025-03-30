package com.be.KKUKKKUK.domain.s3.repository;

import com.be.KKUKKKUK.domain.s3.entity.S3;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import org.springframework.data.jpa.repository.JpaRepository;

import java.util.Optional;

public interface S3Repository extends JpaRepository<S3, Integer> {

    Optional<S3> findByRelatedIdAndRelatedType(Integer ownerId, RelatedType relatedType);
}
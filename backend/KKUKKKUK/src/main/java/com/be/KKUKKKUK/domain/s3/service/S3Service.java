package com.be.KKUKKKUK.domain.s3.service;

import com.be.KKUKKKUK.domain.s3.entity.S3;
import com.be.KKUKKKUK.domain.s3.repository.S3Repository;
import com.be.KKUKKKUK.global.enumeration.RelatedType;
import com.be.KKUKKKUK.global.s3.S3Uploader;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.multipart.MultipartFile;

import java.time.LocalDateTime;

@Service
@Transactional
@RequiredArgsConstructor
public class S3Service {
    private final S3Repository s3Repository;
    private final S3Uploader s3Uploader;


    public String uploadImage(Integer relativeId, RelatedType relatedType, MultipartFile imageFile) {
        // 1. 기존 이미지 있으면 삭제
        s3Repository.findByRelatedIdAndRelatedType(relativeId, relatedType).ifPresent(s3 -> {
            s3Uploader.deleteImage(s3.getUrl());
        });

        // 2. 새로운 이미지 업로드
        String image = s3Uploader.uploadPermanent(imageFile, relatedType.name());

        // 3. 새로운 이미지 저장
        return s3Repository.save(new S3(relativeId, relatedType, image, LocalDateTime.now())).getUrl();
    }
}

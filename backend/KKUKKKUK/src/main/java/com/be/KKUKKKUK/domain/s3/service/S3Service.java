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
import java.util.Objects;

/**
 * packageName    : com.be.KKUKKKUK.domain.s3.service<br>
 * fileName       : S3Service.java<br>
 * author         : haelim <br>
 * date           : 2025-03-30<br>
 * description    : S3 entity 의 service 클래스입니다. <br>
 *                  S3Uploader 로 이미지를 S3 에 업로드하고, S3 테이블에 이미지 url 을 저장합니다.
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.30          haelim           최초생성<br>
 * <br>
 */
@Service
@Transactional
@RequiredArgsConstructor
public class S3Service {
    private final S3Repository s3Repository;
    private final S3Uploader s3Uploader;

    /**
     * 이미지를 S3에 업로드하고, 기존 이미지는 삭제합니다.
     * @param relativeId 식별자 ID
     * @param relatedType 연관된 테이블 타입(Owner, Hospital, Pet...)
     * @param imageFile 이미지 파일
     * @return 저장된 이미지 url
     */
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

    /**
     * 연관된 이미지를 조회합니다.
     * @param relativeId 식별자 ID
     * @param relatedType 연관된 테이블 타입(Owner, Hospital, Pet...)
     * @return 이미지 URL, 이미지가 없다면 null
     */
    public String getImage(Integer relativeId, RelatedType relatedType) {
        return s3Repository.findByRelatedIdAndRelatedType(relativeId, relatedType)
                .map(S3::getUrl)
                .orElse(null);
    }

    /**
     * 연관된 이미지를 삭제합니다.
     * @param relativeId 식별자 ID
     * @param relatedType 연관된 테이블 타입(Owner, Hospital, Pet...)
     */
    public void deleteImage(Integer relativeId, RelatedType relatedType) {
        String s3Image = getImage(relativeId, relatedType);
        if(Objects.nonNull(s3Image)) {
            s3Uploader.deleteImage(s3Image);
        }
        s3Repository.deleteByRelatedIdAndRelatedType(relativeId, relatedType);
    }
}

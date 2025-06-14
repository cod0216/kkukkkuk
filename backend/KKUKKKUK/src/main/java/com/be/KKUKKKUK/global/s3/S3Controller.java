package com.be.KKUKKKUK.global.s3;

import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestPart;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.multipart.MultipartFile;

/**
 * packageName    : com.KKUKKKUK.global.S3<br>
 * fileName       : S3Controller.java<br>
 * author         : Fiat_lux<br>
 * date           : 25. 3. 16.<br>
 * description    : S3 controller 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.16          Fiat_lux           최초생성<br>
 */
@RestController
@RequestMapping("/api/images")
@RequiredArgsConstructor
public class S3Controller {
    private final S3Uploader s3Uploader;

    public static final String PART_CREATE_BABY_DATA = "domain";
    public static final String PART_CREATE_BABY_IMAGE = "image";

    /**
     * AWS S3에 이미지를 업로드합니다.
     *
     * <p>이 엔드포인트는 멀티파트 폼 데이터를 받아서 S3에 업로드하고,
     * 업로드된 이미지의 URL을 반환합니다.</p>
     *
     * @param image  업로드할 이미지 파일 (MultipartFile 형식)
     * @param domain 이미지가 속하는 도메인 정보 (예: "profile", "product" 등)
     * @return 업로드된 이미지의 URL을 포함한 {@link ResponseEntity} 객체
     */
    @PostMapping(consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<String> uploadImage(@RequestPart(PART_CREATE_BABY_IMAGE) MultipartFile image,
                                              @RequestPart(PART_CREATE_BABY_DATA) String domain) {

        String upload = s3Uploader.upload(image, domain);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(upload);
    }

    /**
     * AWS S3에 영구적으로 저장될 이미지를 업로드합니다.
     *
     * <p>이 메서드는 일반 업로드와 달리 삭제되지 않는 영구적인 저장을 지원합니다.</p>
     *
     * @param image  업로드할 이미지 파일 (MultipartFile 형식)
     * @param domain 이미지가 속하는 도메인 정보 (예: "profile", "product" 등)
     * @return 업로드된 이미지의 URL을 포함한 {@link ResponseEntity} 객체
     */
    @PostMapping(value = "/permanent", consumes = {MediaType.MULTIPART_FORM_DATA_VALUE})
    public ResponseEntity<String> uploadPermanentImage(@RequestPart(PART_CREATE_BABY_IMAGE) MultipartFile image,
                                                       @RequestPart(PART_CREATE_BABY_DATA) String domain) {

        String upload = s3Uploader.uploadPermanent(image, domain);

        return ResponseEntity
                .status(HttpStatus.CREATED)
                .body(upload);
    }
}

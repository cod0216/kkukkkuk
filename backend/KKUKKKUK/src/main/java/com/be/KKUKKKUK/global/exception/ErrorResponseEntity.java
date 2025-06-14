package com.be.KKUKKKUK.global.exception;

import com.be.KKUKKKUK.global.api.StatusEnum;
import com.fasterxml.jackson.annotation.JsonProperty;
import lombok.*;
import org.springframework.http.ResponseEntity;

/**
 * packageName    : com.be.KKUKKKUK.global.exception<br>
 * fileName       : ErrorResponseEntity.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-10<br>
 * description    : ErrorCode(ENUM)을 사용하여 에러에 대한 일괄적인 ResponseEntity 를 반환하는 객체입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.10          Fiat_lux           최초생성<br>
 * 25.03.14          haelim           JsonProperty 추가, statusEnum -> status, status -> http_code<br>
 */
@Setter
@Getter
@AllArgsConstructor
@NoArgsConstructor
@ToString
@Builder
public class ErrorResponseEntity {
    @JsonProperty("status")
    private StatusEnum statusEnum;
    @JsonProperty("http_code")
    private int status;
    private String name;
    private String code;
    private String message;

    /**
     * 지정된 에러 코드를 기반으로 HTTP 응답 엔티티를 생성합니다.
     *
     * <p>
     * 이 메서드는 {@link ErrorCode} 객체를 사용하여 HTTP 상태 코드와 에러 정보를 포함한
     * {@link ResponseEntity} 객체를 생성하고 반환합니다.
     * </p>
     *
     * @param e 응답에 사용될 에러 코드
     * @return 에러 정보를 포함한 HTTP 응답 엔티티
     */
    public static ResponseEntity<ErrorResponseEntity> toResponseEntity(ErrorCode e) {
        return ResponseEntity
                .status(e.getHttpStatus())
                .body(ErrorResponseEntity.builder()
                        .statusEnum(StatusEnum.FAILURE)
                        .status(e.getHttpStatus().value())
                        .name(e.name())
                        .code(e.getCode())
                        .message(e.getMessage())
                        .build());
    }

    /**
     * 지정된 에러 코드와 사용자 정의 메시지를 기반으로 HTTP 응답 엔티티를 생성합니다.
     *
     * <p>
     * 이 메서드는 {@link ErrorCode} 객체와 추가 메시지를 사용하여 HTTP 상태 코드와
     * 에러 정보를 포함한 {@link ResponseEntity} 객체를 생성하고 반환합니다.
     * 사용자 정의 메시지는 응답 본문에 포함된 에러 메시지로 설정됩니다.
     * </p>
     *
     * @param e       응답에 사용될 에러 코드
     * @param message 사용자 정의 에러 메시지
     * @return 에러 정보를 포함한 HTTP 응답 엔티티
     */
    public static ResponseEntity<ErrorResponseEntity> toResponseEntity(ErrorCode e, String message) {
        return ResponseEntity
                .status(e.getHttpStatus())
                .body(ErrorResponseEntity.builder()
                        .statusEnum(StatusEnum.FAILURE)
                        .status(e.getHttpStatus().value())
                        .name(e.name())
                        .code(e.getCode())
                        .message(message)
                        .build());
    }
}

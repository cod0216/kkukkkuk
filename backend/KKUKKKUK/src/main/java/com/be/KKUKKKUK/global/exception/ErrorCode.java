package com.be.KKUKKKUK.global.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;
import org.springframework.http.HttpStatus;

/**
 * packageName    : com.be.KKUKKKUK.global.exception<br>
 * fileName       : ErrorCode.java<br>
 * author         : Fiat_lux<br>
 * date           : 25. 3. 10.<br>
 * description    : Exception 관리를 위한 ENUM 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.10          Fiat_lux           최초생성<br>
 */
@Getter
@AllArgsConstructor
public enum ErrorCode {
    INVALID_INPUT_VALUE(HttpStatus.BAD_REQUEST, "COMMON-001", "유효성 검증에 실패했습니다."),
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "COMMON-002", "서버에서 처리할 수 없습니다.");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

}

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
 * 25.03.14          haelim             AUTH 관련 Error 작성
 */
@Getter
@AllArgsConstructor
public enum ErrorCode {
    INVALID_INPUT_VALUE(HttpStatus.BAD_REQUEST, "COMMON-001", "유효성 검증에 실패했습니다."),
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "COMMON-002", "서버에서 처리할 수 없습니다."),

    OWNER_REGISTRATION_FAILED(HttpStatus.BAD_REQUEST, "AUTH-001", "사용자 정보 업데이트에 실패했습니다."),

    ACCOUNT_NOT_FOUND(HttpStatus.BAD_REQUEST, "AUTH-002", "입력하신 계정 정보가 존재하지 않습니다."),
    PASSWORD_NOT_MATCH(HttpStatus.BAD_REQUEST, "AUTH-003", "비밀번호가 올바르지 않습니다. 다시 확인해주세요."),
    HOSPITAL_NOT_FOUND(HttpStatus.BAD_REQUEST, "AUTH-004", "병원 정보를 찾을 수 없습니다."),
    HOSPITAL_DUPLICATED(HttpStatus.BAD_REQUEST, "AUTH-005", "이미 존재하는 계정입니다."),
    NO_ACCESS_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH-006", "Access token 토큰이 필요합니다."),
    INVALID_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH-007", "유효하지 않은 토큰입니다."),
    TOKEN_STORAGE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "AUTH-008", "토큰 저장 중 오류가 발생했습니다."),
    ACCOUNT_NOT_AVAILABLE(HttpStatus.BAD_REQUEST, "AUTH-009", "등록할 수 없는 계정입니다."),
    LICENSE_NOT_AVAILABLE(HttpStatus.BAD_REQUEST, "AUTH-010", "사용 불가능한 라이센스입니다."),

    ;


    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

}

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
 * 25.03.17          haelim             의사, 지갑 관련 Error 작성
 * 25.03.18          haelim             라이센스 관련 Error 삭제, 이메일 관련 Error 작성
 * 25.03.19          haelim             반려동물 관련 Error 작성
 * 25.03.20          haelim             COMMON-003, COMMON-004 작성, Endpoint 관련 Error 작성
 * 25.03.21          Fiat_lux           Breed 관련 Error 작성
 * 25.03.27          haelim             인증 관련 Error 추가
 * 25.03.28          haelim             리소스를 찾을 수 없는 경우 NOT_FOUND 반환
 */
@Getter
@AllArgsConstructor
public enum ErrorCode {
    INVALID_INPUT_VALUE(HttpStatus.BAD_REQUEST, "COMMON-001", "유효성 검증에 실패했습니다."),
    INTERNAL_SERVER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "COMMON-002", "서버 내부 오류가 발생했습니다."),
    NO_ENDPOINT(HttpStatus.NOT_FOUND, "COMMON-003", "존재하지 않는 엔드포인트입니다."),
    METHOD_NOT_ALLOWED(HttpStatus.METHOD_NOT_ALLOWED, "COMMON-004", "허용되지 않는 메소드입니다."),

    OWNER_REGISTRATION_FAILED(HttpStatus.CONFLICT, "AUTH-001", "사용자 정보 업데이트에 실패했습니다."),

    ACCOUNT_NOT_FOUND(HttpStatus.NOT_FOUND, "AUTH-002", "입력하신 계정 정보가 존재하지 않습니다."),
    PASSWORD_NOT_MATCHED(HttpStatus.UNAUTHORIZED, "AUTH-003", "비밀번호가 올바르지 않습니다. 다시 확인해주세요."),
    HOSPITAL_DUPLICATED(HttpStatus.CONFLICT, "AUTH-004", "이미 가입된 동물병원 계정입니다."),
    NO_ACCESS_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH-005", "액세스 토큰이 필요합니다."),
    INVALID_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH-006", "유효하지 않은 토큰입니다."),
    TOKEN_STORAGE_FAILED(HttpStatus.INTERNAL_SERVER_ERROR, "AUTH-007", "토큰 저장 중 오류가 발생했습니다."),
    ACCOUNT_NOT_AVAILABLE(HttpStatus.CONFLICT, "AUTH-008", "등록할 수 없는 계정입니다."),
    NO_REFRESH_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH-009", "리프레시 토큰이 필요합니다."),
    AUTH_CODE_EXPIRED(HttpStatus.UNAUTHORIZED, "AUTH-010", "인증 코드가 만료되었습니다."),
    AUTH_CODE_NOT_MATCHED(HttpStatus.UNAUTHORIZED, "AUTH-011", "인증 코드가 일치하지 않습니다."),
    NO_USER_TYPE(HttpStatus.UNAUTHORIZED, "AUTH-012", "유효하지 않은 회원 유형입니다."),
    NO_AUTH_TOKEN(HttpStatus.UNAUTHORIZED, "AUTH-013", "인증 토큰이 필요합니다."),

    HOSPITAL_NOT_FOUND(HttpStatus.NOT_FOUND, "HOSPITAL-001", "병원 정보를 찾을 수 없습니다."),
    HOSPITAL_NOT_ALLOWED(HttpStatus.FORBIDDEN, "HOSPITAL-002", "병원에 대한 권한이 없습니다."),

    DOCTOR_NOT_FOUND(HttpStatus.NOT_FOUND, "DOCTOR-001", "의사 정보를 찾을 수 없습니다."),
    DOCTOR_NOT_ALLOWED(HttpStatus.FORBIDDEN, "DOCTOR-002", "의사에 대한 권한이 없습니다."),
    DOCTOR_MINIMUM_LIMIT(HttpStatus.CONFLICT, "DOCTOR-003", "의사는 반드시 한 명 이상이어야 합니다."),

    WALLET_NOT_FOUND(HttpStatus.NOT_FOUND, "WALLET-001", "지갑 정보를 찾을 수 없습니다."),
    WALLET_ALREADY_EXIST(HttpStatus.CONFLICT, "WALLET-002", "이미 등록된 지갑입니다."),
    WALLET_NOT_ALLOWED(HttpStatus.FORBIDDEN, "WALLET-003", "지갑에 대한 권한이 없습니다."),

    OWNER_NOT_FOUND(HttpStatus.NOT_FOUND, "OWNER-001", "보호자 정보를 찾을 수 없습니다."),

    UNABLE_TO_SEND_EMAIL(HttpStatus.INTERNAL_SERVER_ERROR, "EMAIL-001", "이메일을 전송할 수 없습니다."),
    EMAIL_DUPLICATED(HttpStatus.CONFLICT, "EMAIL-002", "이미 사용 중인 이메일입니다."),
    EMAIL_NOT_MATCHED(HttpStatus.NOT_FOUND, "EMAIL-003", "이메일과 아이디에 일치하는 계정을 찾을 수 없습니다."),

    PET_NOT_FOUND(HttpStatus.NOT_FOUND, "PET-001", "해당 반려동물을 찾을 수 없습니다."),
    PET_NOT_ALLOWED(HttpStatus.FORBIDDEN, "PET-002", "반려동물에 대한 권한이 없습니다."),

    BREED_NOT_FOUND(HttpStatus.NOT_FOUND, "BREED-001", "해당하는 품종을 찾을 수 없습니다."),

    DRUG_NOT_FOUND(HttpStatus.NOT_FOUND, "DRUG-001", "해당 약품을 찾을 수 없습니다."),

    TOO_MANY_REQUESTS(HttpStatus.TOO_MANY_REQUESTS, "OCR-001", "많은 요청을 보내고 있습니다."),
    GPT_API_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "OCR-002", "GPT API 호출 중 오류가 발생했습니다."),
    GPT_JSON_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "OCR-003", "OpenAI API 응답 파싱을 실패하였습니다."),
    GPT_MAPPER_ERROR(HttpStatus.INTERNAL_SERVER_ERROR, "OCR-004", "GPT 결과를 OcrResponse로 매핑하는 데 실패했습니다."),
    GPT_INPUT_ERROR(HttpStatus.BAD_REQUEST, "OCR-005", "입력한 데이터가 제공되지 않았습니다."),

    DIA_AUTH_ERROR(HttpStatus.FORBIDDEN,"DIG-001","해당 병원에서 입력한 진료가 아닙니다."),
    DIA_NOT_FOUND(HttpStatus.NOT_FOUND,"DIG-002","해당 진료 품목을 제거 할 수 없습니다..");

    private final HttpStatus httpStatus;
    private final String code;
    private final String message;

}

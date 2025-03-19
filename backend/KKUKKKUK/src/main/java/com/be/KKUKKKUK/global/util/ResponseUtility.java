package com.be.KKUKKKUK.global.util;

import com.be.KKUKKKUK.global.api.ApiResponse;
import com.be.KKUKKKUK.global.api.StatusEnum;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

/**
 * packageName    : com.be.KKUKKKUK.global.util<br>
 * fileName       : ResponseUtility.java<br>
 * author         : haelim <br>
 * date           : 2025-03-14<br>
 * description    : 봉투형 응답을 위한 유틸 클래스입니다. <br>
 * 객체 생성 없이 호출할 수 있도록 static 으로 선언하고 생성자 없이 동작합니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 2025-03-14        haelim            최초생성<br>
 * 2025-03-16        haelim            final로 변경 및 상태 코드 커스텀 메소드 추가<br>
 */
public final class ResponseUtility {

    /**
     * 요청이 성공했을 때 기본 메시지와 함께 200 OK 응답을 반환합니다.
     *
     * @param data 응답 데이터
     * @param <T>  응답 데이터의 타입
     * @return 200 OK 응답을 포함한 {@link ResponseEntity}
     */
    public static <T> ResponseEntity<ApiResponse<T>> success(T data) {
        return ResponseEntity.ok(new ApiResponse<>(StatusEnum.SUCCESS, "Request successful", data));
    }

    /**
     * 요청이 성공했을 때 커스텀 메시지와 함께 200 OK 응답을 반환합니다.
     *
     * @param message 응답 메시지
     * @param data    응답 데이터
     * @param <T>     응답 데이터의 타입
     * @return 200 OK 응답을 포함한 {@link ResponseEntity}
     */
    public static <T> ResponseEntity<ApiResponse<T>> success(String message, T data) {
        return ResponseEntity.ok(new ApiResponse<>(StatusEnum.SUCCESS, message, data));
    }

    /**
     * 요청이 성공했을 때 커스텀 메시지와 특정 HTTP 상태 코드와 함께 응답을 반환합니다.
     *
     * @param message 응답 메시지
     * @param data    응답 데이터
     * @param status  HTTP 상태 코드
     * @param <T>     응답 데이터의 타입
     * @return 지정된 HTTP 상태 코드를 포함한 {@link ResponseEntity}
     */
    public static <T> ResponseEntity<ApiResponse<T>> success(String message, T data, HttpStatus status) {
        return ResponseEntity.status(status).body(new ApiResponse<>(StatusEnum.SUCCESS, message, data));
    }

    /**
     * 요청이 실패했을 때 특정 메시지와 HTTP 상태 코드와 함께 응답을 반환합니다.
     *
     * @param message 실패 메시지
     * @param status  HTTP 상태 코드
     * @return 지정된 HTTP 상태 코드를 포함한 {@link ResponseEntity}
     */
    public static ResponseEntity<ApiResponse<Object>> error(String message, HttpStatus status) {
        return ResponseEntity.status(status).body(new ApiResponse<>(StatusEnum.FAILURE, message, null));
    }

    /**
     * 객체 생성을 방지하기 위한 private 생성자.
     */
    private ResponseUtility() {
        throw new UnsupportedOperationException("Utility Class");
    }
}

package com.be.KKUKKKUK.global.util;

import com.be.KKUKKKUK.global.api.ApiResponse;
import com.be.KKUKKKUK.global.api.StatusEnum;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;

import java.security.SecureRandom;
import java.util.Collections;
import java.util.Map;
import java.util.Set;

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
 * 2025-03-16        haelim            final 로 변경 및 상태 코드 커스텀 메소드 추가<br>
 * 2025-03-29        haelim            emptyResponse 메소드 추가<br>
 * 2025-03-31        haelim            안쓰는 메서드 정리 <br>
 *
 */
public final class ResponseUtility {

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
     * 삭제 요청 시 No Content 대신 빈 객체를 반환합니다.
     *
     * @param message 응답 메시지
     * @return 200 OK 응답을 포함한 {@link ResponseEntity}
     */
    public static ResponseEntity<ApiResponse<Object>> emptyResponse(String message) {
        return ResponseEntity.ok(new ApiResponse<>(StatusEnum.SUCCESS, message, Collections.emptyMap()));
    }

    /**
     * 객체 생성을 방지하기 위한 private 생성자.
     */
    private ResponseUtility() {
        throw new UnsupportedOperationException("Utility Class");
    }
}

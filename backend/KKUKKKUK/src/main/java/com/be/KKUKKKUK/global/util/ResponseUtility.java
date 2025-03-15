package com.be.KKUKKKUK.global.util;

import com.be.KKUKKKUK.global.api.ApiResponse;
import com.be.KKUKKKUK.global.api.StatusEnum;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

/**
 * packageName    : com.be.KKUKKKUK.global.util<br>
 * fileName       : ResponseUtility.java<br>
 * author         : haelim <br>
 * date           : 2025-03-14<br>
 * description    : 봉투형 응답을 위한 유틸 클래스입니다. <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 2025-03-14        haelim            최초생성<br>
 */
@Component
public class ResponseUtility {

    public static <T> ResponseEntity<ApiResponse<T>> success(T data) {
        return ResponseEntity.ok(new ApiResponse<>(StatusEnum.SUCCESS, "Request successful", data));
    }

    public static <T> ResponseEntity<ApiResponse<T>> success(String message, T data) {
        return ResponseEntity.ok(new ApiResponse<>(StatusEnum.SUCCESS, message, data));
    }

    public static ResponseEntity<ApiResponse<Object>> error(String message, HttpStatus status) {
        return ResponseEntity.status(status).body(new ApiResponse<>(StatusEnum.FAILURE, message, null));
    }
}

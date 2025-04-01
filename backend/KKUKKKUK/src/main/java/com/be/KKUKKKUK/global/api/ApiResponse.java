package com.be.KKUKKKUK.global.api;

import com.fasterxml.jackson.annotation.JsonInclude;
import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.global.util<br>
 * fileName       : ApiResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-14<br>
 * description    : 봉투형 응답을 위한 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.14          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
@JsonInclude(JsonInclude.Include.NON_NULL)
public class ApiResponse<T> {
    private StatusEnum status;
    private String message;
    private T data;
}
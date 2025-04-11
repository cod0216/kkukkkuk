package com.be.KKUKKKUK.global.exception;

import lombok.AllArgsConstructor;
import lombok.Getter;

/**
 * packageName    : com.be.KKUKKKUK.global.exception<br>
 * fileName       : ApiException.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-10<br>
 * description    :  Exception custom class 입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.10          Fiat_lux           최초생성<br>
 */
@AllArgsConstructor
@Getter
public class ApiException extends RuntimeException {
    private final ErrorCode errorCode;
}

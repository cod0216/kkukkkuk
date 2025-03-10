package com.be.KKUKKKUK.global.api;

import org.springframework.http.HttpStatus;

import java.lang.annotation.ElementType;
import java.lang.annotation.Retention;
import java.lang.annotation.RetentionPolicy;
import java.lang.annotation.Target;

/**
 * packageName    : com.be.KKUKKKUK.global.api<br>
 * fileName       : ApiResponseWrapper.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-10<br>
 * description    : <p>API 응답을 통일된 형식으로 감싸기 위한 어노테이션입니다.</p>
 *
 * <p>이 어노테이션을 메서드에 적용하면, AOP를 통해 해당 메서드의 응답이 {@link ApiResult} 형식으로 자동 변환됩니다.</p>
 *
 * <h3>기능</h3>
 *  <ul>
 *      <li>컨트롤러의 반환 값을 {@link ApiResult} 객체로 변환</li>
 *      <li>응답 상태 코드 및 메시지를 설정 가능</li>
 *      <li>AOP {@link ApiResponseAspect}에서 이 어노테이션을 감지하여 자동으로 응답 변환</li>
 *  </ul><br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.10          Fiat_lux            최초생성<br>
 */
@Target(ElementType.METHOD)
@Retention(RetentionPolicy.RUNTIME)
public @interface ApiResponseWrapper {
    HttpStatus status() default HttpStatus.OK;

    String message() default "Request processed successfully";
}
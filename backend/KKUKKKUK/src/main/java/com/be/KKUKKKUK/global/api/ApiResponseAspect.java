package com.be.KKUKKKUK.global.api;

import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.ProceedingJoinPoint;
import org.aspectj.lang.annotation.Around;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.reflect.MethodSignature;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Component;

import java.lang.reflect.Method;

/**
 * packageName    : com.be.KKUKKKUK.global.api<br>
 * fileName       : ApiResponseAspect.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-10<br>
 * description    :  <p>API 응답을 일관된 형식으로 감싸는 AOP 클래스입니다.</p>
 * <p>
 * {@link ApiResponseWrapper} 어노테이션이 적용된 메서드를 대상으로 실행되며,
 * 모든 응답을 {@link ApiResult} 형태로 변환하여 반환합니다.
 * </p>
 *
 * <h3>기능</h3>
 *  <ul>
 *      <li>컨트롤러에서 반환하는 데이터를 {@link ApiResult} 객체로 감싸서 응답</li>
 *      <li>이미 {@link ResponseEntity}를 반환하는 경우 내부 데이터를 추출하여 변환</li>
 *      <li>예외 발생 시 {@link ApiException}을 던져 일관된 에러 처리 수행</li>
 *  </ul>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.10          Fiat_lux           최초생성<br>
 */
@Aspect
@Component
@Slf4j
public class ApiResponseAspect {

    @Around("@annotation(com.be.KKUKKKUK.global.api.ApiResponseWrapper)")
    public ResponseEntity<?> wrapApiResponse(ProceedingJoinPoint joinPoint) {
        try {
            MethodSignature signature = (MethodSignature) joinPoint.getSignature();
            Method method = signature.getMethod();
            ApiResponseWrapper annotation = method.getAnnotation(ApiResponseWrapper.class);

            Object result = joinPoint.proceed();

            HttpStatus status = annotation.status();
            String message = annotation.message();

            if (result instanceof ResponseEntity<?>) {
                ResponseEntity<?> responseEntity = (ResponseEntity<?>) result;
                Object body = responseEntity.getBody();

                ApiResult<Object> apiResult = ApiResult.<Object>builder()
                        .status(StatusEnum.SUCCESS)
                        .message(message)
                        .data(body)
                        .build();

                return ResponseEntity.status(responseEntity.getStatusCode()).body(apiResult);
            }

            ApiResult<Object> apiResult = ApiResult.<Object>builder()
                    .status(StatusEnum.SUCCESS)
                    .message(message)
                    .data(result)
                    .build();

            return ResponseEntity.status(status).body(apiResult);
        } catch (Throwable e) {
            log.error("Error in API response handling", e);
            throw new ApiException(ErrorCode.INTERNAL_SERVER_ERROR);
        }
    }
}

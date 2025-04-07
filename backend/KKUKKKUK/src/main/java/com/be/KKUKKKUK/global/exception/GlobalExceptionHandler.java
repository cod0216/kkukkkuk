package com.be.KKUKKKUK.global.exception;

import jakarta.validation.ConstraintViolationException;
import lombok.extern.slf4j.Slf4j;
import org.springframework.beans.TypeMismatchException;
import org.springframework.http.ResponseEntity;
import org.springframework.http.converter.HttpMessageNotReadableException;
import org.springframework.validation.BindException;
import org.springframework.validation.BindingResult;
import org.springframework.web.HttpRequestMethodNotSupportedException;
import org.springframework.web.bind.MethodArgumentNotValidException;
import org.springframework.web.bind.MissingPathVariableException;
import org.springframework.web.bind.MissingServletRequestParameterException;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RestControllerAdvice;
import org.springframework.web.method.annotation.MethodArgumentTypeMismatchException;
import org.springframework.web.multipart.support.MissingServletRequestPartException;
import org.springframework.web.servlet.resource.NoResourceFoundException;



/**
 * packageName    : com.be.KKUKKKUK.global.exception<br>
 * fileName       : GlobalExceptionHandler.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-10<br>
 * description    :  Exception 처리를 관리하는 GlobalExceptionHandler 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.10          Fiat_lux           최초생성<br>
 * 25.03.21          haelim             NoResourceFoundException, HttpRequestMethodNotSupportedException, 추가 <br>
 * 25.03.27          haelim             HttpMessageNotReadableException 추가<br>
 *
 */
@RestControllerAdvice
@Slf4j
public class GlobalExceptionHandler {

    /**
     * 비즈니스 예외를 처리합니다.
     *
     * <p>
     * 이 메서드는 애플리케이션에서 발생한 {@link ApiException}을 처리하며,
     * 에러 코드에 따라 적절한 응답을 생성하여 반환합니다.
     * </p>
     *
     * @param e 처리할 비즈니스 예외
     * @return 에러 코드에 기반한 HTTP 응답 엔터티
     */
    @ExceptionHandler(ApiException.class)
    private ResponseEntity<ErrorResponseEntity> handleBusinessException(final ApiException e) {
        return ErrorResponseEntity.toResponseEntity(e.getErrorCode());
    }


    /**
     * 일반적인 예외를 처리합니다.
     *
     * <p>
     * 이 메서드는 {@link ApiException} 외에 발생하는 예외를 처리하며,
     * 내부 서버 에러 코드를 포함한 HTTP 응답을 생성하여 반환합니다.
     * 처리 과정에서 발생한 예외 정보는 로그로 기록됩니다.
     * </p>
     *
     * @param e 처리할 예외
     * @return 내부 서버 에러를 나타내는 HTTP 응답 엔터티
     */
    @ExceptionHandler(Exception.class)
    private ResponseEntity<ErrorResponseEntity> handleException(Exception e) {
        log.error("handle not business exception", e);
        return ErrorResponseEntity.toResponseEntity(ErrorCode.INTERNAL_SERVER_ERROR);
    }

    /**
     * 사용자 입력값 검증 예외를 처리합니다.
     *
     * <p>
     * 요청 바디에서 입력값 검증 실패 시 발생하는 {@link MethodArgumentNotValidException},
     * {@link ConstraintViolationException}, {@link HttpMessageNotReadableException}을 처리합니다.
     * 필드별 에러 메시지를 조합하여 응답에 포함합니다.
     * </p>
     *
     * <p>
     * - {@link MethodArgumentNotValidException}: @Valid 검증 실패 시 발생
     * - {@link ConstraintViolationException}: @Validated 검증 실패 시 발생
     * - {@link HttpMessageNotReadableException}: JSON 파싱 오류 등 요청 바디를 읽을 수 없는 경우 발생
     * </p>
     *
     * @param e 입력값 검증 예외
     * @return 검증 실패에 대한 HTTP 응답 엔터티
     */
    @ExceptionHandler({MethodArgumentNotValidException.class, ConstraintViolationException.class, HttpMessageNotReadableException.class})
    private ResponseEntity<ErrorResponseEntity> handleValidException(Exception e) {
        String errorMessages;

        if (e instanceof MethodArgumentNotValidException) {
            BindingResult bindingResult = ((MethodArgumentNotValidException) e).getBindingResult();
            errorMessages = bindingResult.getFieldErrors().stream()
                    .map(fieldError -> String.format("[%s](은)는 %s", fieldError.getField(), fieldError.getDefaultMessage()))
                    .reduce((message1, message2) -> message1 + ". " + message2)
                    .orElse("입력값 검증 오류가 발생했습니다.");
        } else if (e instanceof ConstraintViolationException constraintViolationException) {
            errorMessages = constraintViolationException.getConstraintViolations().stream()
                    .map(violation -> String.format("[%s](은)는 %s",
                            violation.getPropertyPath(),
                            violation.getMessage()))
                    .reduce((message1, message2) -> message1 + ". " + message2)
                    .orElse("입력값 검증 오류가 발생했습니다.");
        } else if (e instanceof HttpMessageNotReadableException) {
            errorMessages = "요청 body 를 읽을 수 없습니다. JSON 형식을 확인해주세요.";
        } else {
            errorMessages = "알 수 없는 검증 오류가 발생했습니다.";
        }

        return ErrorResponseEntity.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE, errorMessages);
    }

    /**
     * 클라이언트의 요청에 해당하는 엔드포인트(endpoint)가 없을 때 발생하는 예외를 처리합니다.
     * @param e 처리할 엔드포인트 관련 예외
     * @return 엔드포인트 예외에 대한 HTTP 응답 엔터티
     */
    @ExceptionHandler(NoResourceFoundException.class)
    private ResponseEntity<ErrorResponseEntity> handleNoResourceFoundException(NoResourceFoundException e) {
        String errorMessages = String.format("[%s] 에 해당하는 엔드포인트를 찾을 수 없습니다.", e.getResourcePath());
        return ErrorResponseEntity.toResponseEntity(ErrorCode.NO_ENDPOINT, errorMessages);
    }

    /**
     * 클라이언트의 요청에 해당하는 엔드포인트(endpoint)가 있지만, 메서드(method)를 지원하지 않을 때 예외를 처리합니다.
     * @param e 처리할 메서드 예외
     * @return 메서드 예외에 대한 HTTP 응답 엔터티
     */
    @ExceptionHandler(HttpRequestMethodNotSupportedException.class)
    private ResponseEntity<ErrorResponseEntity> handleMethodNotSupportedException(HttpRequestMethodNotSupportedException e) {
        String errorMessages = String.format("[%s] 는 허용되지 않는 메소드입니다.", e.getMethod());
        return ErrorResponseEntity.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE, errorMessages);
    }

    /**
     * 요청 파라미터의 타입이 일치하지 않을 경우 발생하는 예외를 처리합니다.
     * @param e 타입이 일치하지 않아 발생한 예외
     * @return 잘못된 타입의 요청 파라미터에 대한 응답
     */
    @ExceptionHandler(MethodArgumentTypeMismatchException.class)
    private ResponseEntity<ErrorResponseEntity> handleMissingServletRequestParameterException(MethodArgumentTypeMismatchException e) {
        String paramName = e.getName();
        String providedValue = e.getValue() != null ? e.getValue().toString() : "null";
        String requiredType = e.getRequiredType() != null ? e.getRequiredType().getSimpleName() : "알 수 없음";

        String errorMessages = String.format(
                "요청 파라미터 [%s]의 값 [%s]는 허용되지 않습니다. 올바른 형식: %s",
                paramName, providedValue, requiredType
        );

        return ErrorResponseEntity.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE, errorMessages);
    }

    /**
     * 요청 파라미터가 누락된 경우 발생하는 예외를 처리합니다.
     * @param e MissingServletRequestParameterException
     * @return 적절한 에러 응답
     */
    @ExceptionHandler(MissingServletRequestParameterException.class)
    private ResponseEntity<ErrorResponseEntity> handleMissingServletRequestParameter(MissingServletRequestParameterException e) {
        String errorMessages = String.format("필수 요청 파라미터 [%s] 가 누락되었습니다.", e.getParameterName());
        return ErrorResponseEntity.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE, errorMessages);
    }

    /**
     * 경로 변수 누락 시 발생하는 예외를 처리합니다.
     * @param e MissingPathVariableException
     * @return 적절한 에러 응답
     */
    @ExceptionHandler(MissingPathVariableException.class)
    private ResponseEntity<ErrorResponseEntity> handleMissingPathVariable(MissingPathVariableException e) {
        String errorMessages = String.format("필수 경로 변수 [%s] 가 누락되었습니다.", e.getVariableName());
        return ErrorResponseEntity.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE, errorMessages);
    }

    /**
     * 타입 불일치 (형변환 실패) 예외를 처리합니다.
     * @param e TypeMismatchException
     * @return 적절한 에러 응답
     */
    @ExceptionHandler(TypeMismatchException.class)
    private ResponseEntity<ErrorResponseEntity> handleTypeMismatch(TypeMismatchException e) {
        String errorMessages = String.format("파라미터 [%s] 값이 잘못되었습니다. 필요한 타입: [%s]", e.getPropertyName(), e.getRequiredType());
        return ErrorResponseEntity.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE, errorMessages);
    }


    /**
     * Multipart 요청에서 파일 등 필요한 part 가 누락된 경우 처리합니다.
     */
    @ExceptionHandler(MissingServletRequestPartException.class)
    private ResponseEntity<ErrorResponseEntity> handleMissingServletRequestPart(MissingServletRequestPartException e) {
        String errorMessages = String.format("요청에 필요한 part [%s] 가 누락되었습니다.", e.getRequestPartName());
        return ErrorResponseEntity.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE, errorMessages);
    }


    /**
     * RequestParam 등에서 바인딩 실패 시 발생
     */
    @ExceptionHandler(BindException.class)
    private ResponseEntity<ErrorResponseEntity> handleBindException(BindException e) {
        String errorMessages = e.getBindingResult().getFieldErrors().stream()
                .map(fieldError -> String.format("[%s](은)는 %s", fieldError.getField(), fieldError.getDefaultMessage()))
                .reduce((msg1, msg2) -> msg1 + ". " + msg2)
                .orElse("요청 파라미터 바인딩 중 오류가 발생했습니다.");
        return ErrorResponseEntity.toResponseEntity(ErrorCode.INVALID_INPUT_VALUE, errorMessages);
    }




}

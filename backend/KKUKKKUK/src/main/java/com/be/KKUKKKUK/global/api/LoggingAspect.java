package com.be.KKUKKKUK.global.api;

import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;
import org.aspectj.lang.JoinPoint;
import org.aspectj.lang.annotation.AfterReturning;
import org.aspectj.lang.annotation.Aspect;
import org.aspectj.lang.annotation.Before;
import org.aspectj.lang.annotation.Pointcut;
import org.aspectj.lang.reflect.CodeSignature;
import org.springframework.stereotype.Component;
import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

import java.util.HashMap;
import java.util.Map;

/**
 * packageName    : com.be.KKUKKKUK.global.api<br>
 * fileName       : LoggingAspect.java<br>
 * author         : haelim<br>
 * date           : 2025-03-14<br>
 * description    : request, response 객체 로깅을 위한 Aspect 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.15          haelim           최초 생성<br>
 * 25.03.19          haelim           Service 로깅 추가 <br>
 */
@Slf4j
//@Aspect
//@Component
public class LoggingAspect {

    /**
     * 로그를 적용할 포인트컷을 정의합니다
     * `com.be.KKUKKKUK.domain.*.controller` 패키지의 모든 메서드 실행 시 적용됩니다.
     */
    @Pointcut("execution(* com.be.KKUKKKUK.domain.*.controller.*.*(..))")
    private void onRequest() {}

    /**
     * 로그를 적용할 포인트컷을 정의합니다
     * `com.be.KKUKKKUK.domain.*.service` 패키지의 모든 메서드 실행 시 적용됩니다.
     */
    @Pointcut("execution(* com.be.KKUKKKUK.domain.*.service.*.*(..))")
    private void onService() {}

    /** 컨트롤러 & 서비스 둘 다 로깅합니다. */
    @Pointcut("onRequest() || onService()")
    private void onExecution() {}

    /** 메서드 실행 전 로깅 */
    @Before("onExecution()")
    public void beforeLog(JoinPoint joinPoint) {
        log.info("[Before] Method: {} Args: {}",
                joinPoint.getSignature().toShortString(),
                params(joinPoint));
    }

    /**
     * 메서드 호출 전에 요청 파라미터 및 HTTP 정보를 로그로 기록합니다.
     * <p>
     * 요청 메서드(GET, POST 등), URI, 파라미터를 로그로 기록하여
     * 요청에 대한 정보를 로깅합니다.
     * </p>
     *
     * @param joinPoint 호출된 메서드의 정보를 제공하는 JoinPoint 객체
     */
    @Before("onRequest()")
    public void beforeParameterLog(JoinPoint joinPoint) {
        HttpServletRequest request =
                ((ServletRequestAttributes) RequestContextHolder.currentRequestAttributes()).getRequest();

        log.info("[Request] : {} {} {}", request.getMethod(), request.getRequestURI(), params(joinPoint).toString());
    }

    /**
     * 응답 객체를 로그로 기록합니다.
     * @param joinPoint 호출된 메서드의 정보를 제공하는 JoinPoint 객체
     * @param returnObj 메서드 실행 후 반환된 객체
     */
    @AfterReturning(value = "onRequest()", returning = "returnObj")
    public void afterReturnLog(JoinPoint joinPoint, Object returnObj) {
        log.info("[Response] : {}", returnObj);
    }

    /**
     * 메서드의 파라미터 이름과 값을 매핑하여, 로깅을 위한 파라미터 정보를 생성합니다.
     * @param joinPoint 호출된 메서드의 정보를 제공하는 JoinPoint 객체
     * @return 파라미터 이름과 값의 쌍을 포함하는 맵
     */
    private Map<String, Object> params(JoinPoint joinPoint) {
        CodeSignature codeSignature = (CodeSignature) joinPoint.getSignature();
        String[] parameterNames = codeSignature.getParameterNames();
        Object[] args = joinPoint.getArgs();
        Map<String, Object> params = new HashMap<>();
        for (int i = 0; i < parameterNames.length; i++) {
            params.put(parameterNames[i], args[i]);
        }
        return params;
    }
}

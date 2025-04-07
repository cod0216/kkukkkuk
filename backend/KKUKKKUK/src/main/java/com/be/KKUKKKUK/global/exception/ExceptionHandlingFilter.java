package com.be.KKUKKKUK.global.exception;

import com.be.KKUKKKUK.global.api.StatusEnum;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import org.springframework.http.MediaType;
import org.springframework.stereotype.Component;
import org.springframework.web.filter.OncePerRequestFilter;

import java.io.IOException;

/**
 * packageName    : com.be.KKUKKKUK.global.exception<br>
 * fileName       : ExceptionHandlingFilter.java<br>
 * author         : haelim<br>
 * date           : 2025-04-06<br>
 * description    : Filter 에서의 Exception 처리를 관리하는 ExceptionHandlingFilter 클래스입니다.<br>
 *                  Spring Filter 단계에서 발생하는 예외를 감지하여 JSON 형식의 에러 응답으로 변환합니다.<br>
 *                  ApiException 과 일반적인 Exception 을 구분하여 처리합니다.<br>
 *                  OncePerRequestFilter 를 상속하여 요청당 한 번만 실행되도록 보장합니다.<br>
 *                  Spring Security Filter 보다 먼저 실행되며, 이후 필터 혹은 DispatcherServlet 으로 전달됩니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.06          haelim           최초생성<br>
 */

@Slf4j
@Component
@RequiredArgsConstructor
public class ExceptionHandlingFilter extends OncePerRequestFilter {
    private final ObjectMapper objectMapper;

    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        try {
            filterChain.doFilter(request, response);
        } catch (ApiException e) {
            log.error("[ExceptionHandlingFilter] ApiException");
            log.error(e.getMessage(), e);
            setErrorResponse(response, e.getErrorCode());
        } catch (Exception e) {
            log.error("[ExceptionHandlingFilter] Exception");
            log.error(e.getMessage(), e);
            setErrorResponse(response, ErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    private void setErrorResponse(HttpServletResponse response, ErrorCode errorCode) throws IOException {
        response.setStatus(errorCode.getHttpStatus().value());
        response.setContentType(MediaType.APPLICATION_JSON_VALUE);
        ErrorResponseEntity errorBody = ErrorResponseEntity.builder()
                .statusEnum(StatusEnum.FAILURE)
                .status(errorCode.getHttpStatus().value())
                .name(errorCode.name())
                .code(errorCode.getCode())
                .message(errorCode.getMessage())
                .build();

        response.getWriter().write(objectMapper.writeValueAsString(errorBody));
    }
}

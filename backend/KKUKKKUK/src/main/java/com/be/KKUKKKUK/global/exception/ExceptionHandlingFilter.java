package com.be.KKUKKKUK.global.exception;

import com.be.KKUKKKUK.global.api.StatusEnum;
import com.fasterxml.jackson.databind.ObjectMapper;
import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.RequiredArgsConstructor;
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
 *                  이 Filter 는 Filter Chain 의 가장 첫번째로 사용되어야 합니다.  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.06          haelim           최초생성<br>
 */

@Component
@RequiredArgsConstructor
public class ExceptionHandlingFilter extends OncePerRequestFilter {
    private final ObjectMapper objectMapper;


    /**
     * 실제 필터링 로직이 수행되는 메서드입니다.<br>
     * 요청 처리 중 ApiException 또는 일반적인 예외(Exception)가 발생하면
     * {@link #setErrorResponse(HttpServletResponse, ErrorCode)} 를 호출하여 에러 응답을 생성합니다.
     *
     * @param request     클라이언트의 HTTP 요청
     * @param response    서버가 클라이언트에게 보낼 HTTP 응답
     * @param filterChain 현재 필터 체인
     * @throws ServletException 서블릿 예외 발생 시
     * @throws IOException      입출력 예외 발생 시
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request,
                                    HttpServletResponse response,
                                    FilterChain filterChain) throws ServletException, IOException {
        try {
            filterChain.doFilter(request, response);
        } catch (ApiException e) {
            setErrorResponse(response, e.getErrorCode());
        } catch (Exception e) {
            setErrorResponse(response, ErrorCode.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 예외 상황에 따라 적절한 에러 정보를 JSON 형태로 클라이언트에 응답하는 메서드입니다.
     *
     * @param response   클라이언트에게 반환할 응답 객체
     * @param errorCode  발생한 예외에 대한 ErrorCode
     * @throws IOException JSON 변환 중 예외 발생 시
     */
    private void setErrorResponse(HttpServletResponse response, ErrorCode errorCode) throws IOException {
        response.setStatus(errorCode.getHttpStatus().value());
        response.setContentType("application/json; charset=UTF-8");

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

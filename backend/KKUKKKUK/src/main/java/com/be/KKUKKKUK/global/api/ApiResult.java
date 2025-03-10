package com.be.KKUKKKUK.global.api;

import lombok.Builder;
import lombok.Getter;
import lombok.NoArgsConstructor;

/**
 * packageName    : com.be.KKUKKKUK.global.api<br>
 * fileName       : ApiResult.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-10<br>
 * description    : <p>API 응답을 표준화하기 위한 DTO 클래스입니다.</p>
 * <p>모든 API 응답은 이 클래스를 통해 래핑되며,
 * 응답의 상태, 메시지, 데이터를 포함합니다.</p>
 *
 * <h3>기능</h3>
 *  <ul>
 *      <li>응답의 상태({@link StatusEnum})를 저장</li>
 *      <li>응답 메시지를 포함하여 클라이언트에게 전달</li>
 *      <li>제네릭 {@code T}를 활용하여 다양한 데이터 타입을 처리 가능</li>
 *  </ul><br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.10          Fiat_lux            최초생성<br>
 */
@Getter
@NoArgsConstructor
public class ApiResult<T> {
    private StatusEnum status;
    private String message;
    private T data;

    @Builder
    public ApiResult(StatusEnum status, String message, T data) {
        this.status = status;
        this.message = message;
        this.data = data;
    }


}

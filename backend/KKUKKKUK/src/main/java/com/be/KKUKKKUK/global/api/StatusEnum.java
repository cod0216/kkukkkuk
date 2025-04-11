package com.be.KKUKKKUK.global.api;

/**
 * packageName    : com.be.KKUKKKUK.global.api<br>
 * fileName       : StatusEnum.java<br>
 * author         : Fiat_lux<br>
 * date           : 2025-03-10<br>
 * description    : <p>API 응답의 상태를 나타내는 열거형(Enum)입니다.</p>
 * <p>모든 API 응답은 {@link ApiResult} 객체를 통해 반환되며,
 * 해당 응답의 성공 또는 실패 여부를 나타내기 위해 이 열거형을 사용합니다.</p>
 * <h3>상태 값</h3>
 * <ul>
 *  <li>{@link #SUCCESS} - 요청이 정상적으로 처리되었음을 나타냄</li>
 *  <li>{@link #FAILURE} - 요청이 실패했음을 나타냄</li>
 * </ul><br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.10          Fiat_lux            최초생성<br>
 */
public enum StatusEnum {
    SUCCESS,
    FAILURE
}

package com.be.KKUKKKUK.domain.auth.dto.response;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * packageName    : com.be.KKUKKKUK.domain.auth.dto.response<br>
 * fileName       : AccountFoundRequest.java<br>
 * author         : haelim<br>
 * date           : 2025-03-27<br>
 * description    : account 찾기를 위한 response DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.27          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
public class AccountFindResponse {
    private String account;
}

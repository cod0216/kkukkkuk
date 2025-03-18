package com.be.KKUKKKUK.domain.owner.dto.response;

import com.be.KKUKKKUK.domain.wallet.dto.response.WalletInfoResponse;
import lombok.AllArgsConstructor;
import lombok.Data;

import java.time.LocalDate;

/**
 * packageName    : com.be.KKUKKKUK.domain.owner.dto<br>
 * fileName       : OwnerInfoResponse.java<br>
 * author         : haelim<br>
 * date           : 2025-03-13<br>
 * description    : Owner 엔터티의 요약 정보를 조회하는 DTO 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.13          haelim           최초 생성<br>
 */
@Data
@AllArgsConstructor
public class OwnerInfoResponse {
    private Integer id;
    private String did;
    private String name;
    private String email;
    private LocalDate birth;
}

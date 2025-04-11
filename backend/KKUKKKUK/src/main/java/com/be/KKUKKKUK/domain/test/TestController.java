package com.be.KKUKKKUK.domain.test;

import com.be.KKUKKKUK.global.api.ApiResponseWrapper;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * packageName    : com.be.KKUKKKUK.domain.test<br>
 * fileName       : null.java<br>
 * author         : SSAFY<br>
 * date           : 2025-03-10<br>
 * description    :  <br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * <br>
 * <br>
 */
@RestController
public class TestController {

    @GetMapping("/api/test")
    @ApiResponseWrapper
    public Object test() {
        return "test";
    }
}

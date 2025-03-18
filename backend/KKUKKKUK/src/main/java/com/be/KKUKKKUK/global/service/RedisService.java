package com.be.KKUKKKUK.global.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;
import java.time.Duration;

/**
 * packageName    : com.be.KKUKKKUK.global.service<br>
 * fileName       : RedisService.java<br>
 * author         : haelim<br>
 * date           : 2025-03-18<br>
 * description    : Redis 접근을 위한 Service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.03.18          haelim           최초 생성<br>
 */
@Service
@RequiredArgsConstructor
public class RedisService {
    private final RedisTemplate<String, String> redisTemplate;

    /**
     * Redis 에 특정 키와 값을 저장합니다.
     * @param key      저장할 키 값
     * @param value    해당 키에 저장할 데이터 값
     * @param duration 데이터의 유효 기간으로, 지정된 시간이 지나면 자동으로 만료됩니다.
     */
    public void setValues(String key, String value, Duration duration) {
        redisTemplate.opsForValue().set(key, value, duration);
    }

    /**
     * Redis 에서 특정 키에 대한 값을 조회합니다.
     * @param key 조회할 키 값
     * @return 해당 키에 저장된 값을 반환합니다. 존재하지 않을 경우 null 반환
     */
    public String getValues(String key) {
        return redisTemplate.opsForValue().get(key);
    }

    /**
     * Redis 에서 특정 키를 삭제합니다.
     * @param key 삭제할 키 값
     */
    public void deleteValues(String key) {
        redisTemplate.delete(key);
    }
}

package com.be.KKUKKKUK.domain.drug.service;

import lombok.RequiredArgsConstructor;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.stereotype.Service;

import java.util.Set;

/**
 * packageName    : com.be.KKUKKKUK.domain.drug.service<br>
 * fileName       : RedisSortedSetService.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-01<br>
 * description    : 약품 데이터를 Redis에 저장하고 조회하는 service 클래스입니다..<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.01          eunchang           최초 생성<br>
 */

@Service
@RequiredArgsConstructor
public class RedisSortedSetService {
    private final RedisTemplate<String, String> redisTemplate;
    private String key = "autocorrect";
    private int score = 0; //TODO score 가 뭔지 잘 모르겠습니다.


    /**
     * 단어를 Redis Sorted Set에 저장합니다.
     *
     * @param keyword 저장할 단어
     */
    public void addToSortedSet(String keyword) {
        redisTemplate.opsForZSet().add(key, keyword, score);
    }

    /**
     * Redis Sorted Set에서 주어진 키워드의 인덱스를 조회합니다.
     *
     * @param keyword 조회할 단어
     * @return 키워드의 정렬 순위
     */
    public Long findFromSortedSet(String keyword) {
        return redisTemplate.opsForZSet().rank(key, keyword);
    }

    /**
     * 키워드로 조회한 인덱스로부터 자동완성 최대 200개를 반환합니다.
     *
     * @param index 조회를 시작할 인덱스
     * @return 키워드로 시작하는 단어 최대 200개 반환
     */
    public Set<String> findAllValuesAfterIndexFromSortedSet(Long index) {
        return redisTemplate.opsForZSet().range(key, index, index + 200); //TODO 200 이라는 값도 상수로 관리하는 건 어떨까요?
    }
}

package com.be.KKUKKKUK.domain.diagnosis.service;

import com.be.KKUKKKUK.domain.diagnosis.entity.Diagnosis;
import com.be.KKUKKKUK.domain.diagnosis.repository.DiagnosisRepository;
import com.be.KKUKKKUK.global.service.RedisService;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import jakarta.annotation.PostConstruct;
import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * packageName    : com.be.KKUKKKUK.domain.diagnosis.service<br>
 * fileName       : DiagnosisAutoCompleteService.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-07<br>
 * description    : 검사 자동 완성 기능을 제공하는 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초 생성<br>
 */

@Service
@RequiredArgsConstructor
public class DiagnosisAutoCompleteService { //TODO 이름에 redis 서비스라는 것을 명시 하면 좋지 않을까요?

    private final DiagnosisRepository diagnosisRepository;
    private final RedisService redisService;
    private static final String SUFFIX = "*";
    private static final int MAX_SIZE = 100;

    /**
     * 서버 기동 시 DB에 저장된 모든 검사 항목을 Redis의 자동완성용 Sorted Set에 저장합니다.
     */
    @PostConstruct
    public void init() {
        List<Diagnosis> diagnoses = diagnosisRepository.findAll();
        for (Diagnosis diagnosis : diagnoses) { //TODO 처음에 서버 build 할때 한번에 데이터를 넣는것 같은데 만약 redis 에서 데이터가 유실된다면 어떻게 조치 하실 건가요?
            addDiagnosisToRedis(diagnosis);
        }
    }

    /**
     * 검사 항목 하나를 Redis에 저장합니다.
     *
     * @param diagnosis 저장할 검사 항목
     */
    public void addDiagnosisToRedis(Diagnosis diagnosis) {
        Integer hospitalId = diagnosis.getHospital().getId();
        String redisKey = "autocorrect:diagnosis:" + hospitalId; //TODO 이런 값도 상수로 두는건 어떨까요?

        String name = diagnosis.getName();
        if (name == null || name.isEmpty()) return;
        redisService.addToSortedSet(redisKey, name + SUFFIX);
        for (int i = name.length(); i > 0; i--) {
            redisService.addToSortedSet(redisKey, name.substring(0, i));
        }
    }

    /**
     * 입력한 키워드에 대해 Redis에서 자동완성 결과를 조회합니다.
     *
     * @param keyword 검색어
     * @return 검색어로 시작하는 검사 항목 목록
     */
    public List<String> autocorrectKeyword(Integer hospitalId, String keyword) {
        String redisKey = "autocorrect:diagnosis:" + hospitalId; //TODO 이런 값도 상수로 두는건 어떨까요?
        Long keywordIndex = redisService.findFromSortedSet(redisKey, keyword);
        if (Objects.isNull(keywordIndex)) {
            return Collections.emptyList();
        }
        Set<String> allValues = redisService.findAllValuesAfterIndexFromSortedSet(redisKey, keywordIndex);
        return allValues.stream()
                .filter(value -> value.endsWith(SUFFIX) && value.startsWith(keyword))
                .map(value -> StringUtils.removeEnd(value, SUFFIX))
                .sorted()
                .limit(MAX_SIZE)
                .collect(Collectors.toList());
    }
}

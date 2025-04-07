package com.be.KKUKKKUK.domain.vaccination.service;

import com.be.KKUKKKUK.domain.vaccination.entity.Vaccination;
import com.be.KKUKKKUK.domain.vaccination.repository.VaccinationRepository;
import com.be.KKUKKKUK.global.service.RedisService;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;

import java.util.Collections;
import java.util.List;
import java.util.Objects;
import java.util.Set;
import java.util.stream.Collectors;

/**
 * packageName    : com.be.KKUKKKUK.domain.vaccination.service<br>
 * fileName       : vaccinationAutoCompleteService.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-07<br>
 * description    : 접종 자동 완성 기능을 제공하는 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.07          eunchang           최초 생성<br>
 */

@Service
@RequiredArgsConstructor
public class VaccinationAutoCompleteService {

    private final VaccinationRepository vaccinationRepository;
    private final RedisService redisService;
    private static final String SUFFIX = "*";
    private static final int MAX_SIZE = 100;

    /**
     * 서버 기동 시 DB에 저장된 모든 예방 접종 항목을 Redis의 자동완성용 Sorted Set에 저장합니다.
     */
    @PostConstruct
    public void init() {
        List<Vaccination> vaccinations = vaccinationRepository.findAll();
        for (Vaccination vaccination : vaccinations) {
            addvaccinationToRedis(vaccination);
        }
    }

    /**
     * 예방 접종 항목 하나를 Redis에 저장합니다.
     *
     * @param vaccination 저장할 예방 접종 항목
     */
    public void addvaccinationToRedis(Vaccination vaccination) {
        Integer hospitalId = vaccination.getHospital().getId();
        String redisKey = "autocorrect:vaccination:" + hospitalId;

        String name = vaccination.getName();
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
     * @return 검색어로 시작하는 예방 접종 항목 목록
     */
    public List<String> autocorrectKeyword(Integer hospitalId, String keyword) {
        String redisKey = "autocorrect:vaccination:" + hospitalId;
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

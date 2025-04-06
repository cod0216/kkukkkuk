//package com.be.KKUKKKUK.domain.diagnosis.service;
//
//import com.be.KKUKKKUK.domain.drug.dto.response.DrugResponse;
//import com.be.KKUKKKUK.domain.drug.service.DrugService;
//import com.be.KKUKKKUK.global.service.RedisService;
//import jakarta.annotation.PostConstruct;
//import lombok.RequiredArgsConstructor;
//import org.apache.commons.lang3.StringUtils;
//import org.springframework.stereotype.Service;
//
//import java.util.Collections;
//import java.util.List;
//import java.util.Objects;
//import java.util.Set;
//
//@Service
//@RequiredArgsConstructor
//public class DiagnosisAutoCorrectService {
//    private final DiagnosisService diagnosisService;
//    private final RedisService redisService;
//    private static final String SUFFIX = "*";
//    private static final int MAX_SIZE = 100;
//
//    /**
//     * 서버 실행 시 약품을 조회해서 redis에 저장합니다.
//     */
//    @PostConstruct
//    public void init() {
//        saveAllSubstring(diagnosisService.getDiagnoses());
//    }
//
//    /**
//     * MySQL에 저장된 모든 약품을 음절 단위로 잘라 Redis에 저장합니다.
//     *
//     * @param drugs 조회된 약품들
//     */
//    private void saveAllSubstring(List<DrugResponse> drugs){
//        for(DrugResponse drug : drugs){
//            redisService.addToSortedSet(drug.getNameKr() + SUFFIX);
//            String kr = drug.getNameKr();
//            String en = drug.getNameEn();
//
//            for(int i = kr.length(); i > 0; --i) {
//                redisService.addToSortedSet(kr.substring(0, i));
//            }
//            for(int i = en.length(); i > 0; --i) {
//                redisService.addToSortedSet(en.substring(0, i));
//            }
//        }
//    }
//
//    /**
//     * 입력한 키워드로 자동완성 조회를 합니다.
//     *
//     * @param keyword 검색어
//     * @return 일치한 String 단어를 사전순으로 반환
//     */
//    public List<String> autocorrectKeyword(String keyword) {
//        Long keywordIndex = redisService.findFromSortedSet(keyword);
//
//        if(Objects.isNull(keywordIndex)){
//            return Collections.emptyList();
//        }
//
//        Set<String> allValuesAfterIndexFromSortedSet = redisService.findAllValuesAfterIndexFromSortedSet(keywordIndex);
//
//        return allValuesAfterIndexFromSortedSet.stream()
//                .filter(value -> value.endsWith(SUFFIX) && value.startsWith(keyword))
//                .map(value -> StringUtils.removeEnd(value, SUFFIX))
//                .limit(MAX_SIZE)
//                .toList();
//    }
//}

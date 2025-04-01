package com.be.KKUKKKUK.domain.drug.service;

import com.be.KKUKKKUK.domain.drug.dto.response.DrugResponse;
import com.be.KKUKKKUK.domain.drug.entity.Drug;
import com.be.KKUKKKUK.domain.drug.mapper.DrugMapper;
import com.be.KKUKKKUK.domain.drug.repository.DrugRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import jakarta.annotation.PostConstruct;
import lombok.RequiredArgsConstructor;
import org.apache.commons.lang3.StringUtils;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

/**
 * packageName    : com.be.KKUKKKUK.domain.drug.service<br>
 * fileName       : DrugService.java<br>
 * author         : eunchang<br>
 * date           : 2025-04-01<br>
 * description    : 약품에 관한 service 클래스입니다.<br>
 * ===========================================================<br>
 * DATE              AUTHOR             NOTE<br>
 * -----------------------------------------------------------<br>
 * 25.04.01          eunchang           최초 생성<br>
 */

@Service
@RequiredArgsConstructor
@Transactional(readOnly = true)
public class DrugService {
    private final DrugRepository drugRepository;
    private final RedisSortedSetService redisSortedSetService;
    private final DrugMapper drugMapper;

    private String SUFFIX = "*";
    private int MAXSIZE = 10;

    /**
     * 서버 실행 시 약품을 조회해서 redis에 저장합니다.
     */
    @PostConstruct
    public void init() {
        saveAllSubstring(drugRepository.findAll());
    }

    /**
     * MySQL에 저장된 모든 약품을 음절 단위로 잘라 Redis에 저장합니다.
     *
     * @param drugs 조회된 약품들
     */
    private void saveAllSubstring(List<Drug> drugs){
        for(Drug drug : drugs){
            redisSortedSetService.addToSortedSet(drug.getNameKr() + SUFFIX);
            String kr = drug.getNameKr();
            String en = drug.getNameEn();

            for(int i = kr.length(); i > 0; --i) {
                redisSortedSetService.addToSortedSet(kr.substring(0, i));
            }
            for(int i = en.length(); i > 0; --i) {
                redisSortedSetService.addToSortedSet(en.substring(0, i));
            }
        }
    }

    /**
     * 입력한 키워드로 자동완성 조회를 합니다.
     *
     * @param keyword 검색어
     * @return 일치한 String 단어를 사전순으로 반환
     */
    public List<String> autocorrect(String keyword) {
        Long index = redisSortedSetService.findFromSortedSet(keyword);

        if(Objects.isNull(index)){
            return new ArrayList<>();
        }

        Set<String> allValuesAfterIndexFromSortedSet = redisSortedSetService.findAllValuesAfterIndexFromSortedSet(index);

        return allValuesAfterIndexFromSortedSet.stream()
                .filter(value -> value.endsWith(SUFFIX) && value.startsWith(keyword))
                .map(value -> StringUtils.removeEnd(value, SUFFIX))
                .limit(MAXSIZE)
                .toList();
    }

    /**
     * 전체 Drug 데이터를 조회합니다.
     * @return Drug Entity 리스트
     * @throws ApiException 조회된 데이터가 없는 경우 예외 발생
     */
    public List<Drug> getAllDrugs() {return  drugRepository.findAll();}

    /**
     * 단어가 포함된 Drug 데이터를 조회힙니다.
     * @param keyword 검색된 단어
     * @return 던어가 포함된 Drug Entity 리스트
     * @throws ApiException 조회된 약품이 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public List<DrugResponse> searchDrugResponses(String keyword) {
        List<Drug> drugs = Optional.ofNullable(drugRepository.findByNameKrContainingIgnoreCaseOrNameEnContainingIgnoreCase(keyword, keyword))
                .filter(list -> !list.isEmpty())
                .orElseThrow(() -> new ApiException(ErrorCode.DRUG_NOT_FOUND));
        return drugMapper.mapDrugToDrugResponse(drugs);
    }


    /**
     * 검색한 단어로 약품을 조회입니다.
     *
     * @param name 약품 이름
     * @return 해당 약품 Entity
     * @throws ApiException 검색한 약품이 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public DrugResponse getDrug(String name){
        Drug drug = Optional.ofNullable(drugRepository.findByNameKrOrNameEn(name, name))
                .orElseThrow(() -> new ApiException(ErrorCode.DRUG_NOT_FOUND));
        return drugMapper.mapToDrugResponse(drug);
    }
}

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
@Transactional(readOnly = true) //TODO 다른 메서드들 이미 readOnly= true 로 설정해놨는데 클래스에 다시 설정한 이유가 있을까요?
public class DrugService { //TODO 이 비즈니스 service 클래스는 MySQL, Redis 둘다 통신을 하는 것 같은데 분리하는 건 어떨까요?
    private final DrugRepository drugRepository;
    private final RedisSortedSetService redisSortedSetService;
    private final DrugMapper drugMapper;

    private String SUFFIX = "*"; //TODO 이런 값들은 상수인 것 같은데 상수일땐 어떤 키워드를 사용해야 할까요?
    private int MAXSIZE = 10;

    /**
     * 서버 실행 시 약품을 조회해서 redis에 저장합니다.
     */
    @PostConstruct
    public void init() { //TODO 처음에 빈 생성할때 모든 Drug 값을 Redis에 저장하려고 하는 것 같은데 이게 맞을까요? Redis 를 사용하는 이유가 뭘까요? Redis를 사용하지 않으면 안될까요? 이런 생각을 좀 깊게 해보셨으면 좋겠습니다.
        saveAllSubstring(drugRepository.findAll());//TODO Redis 는  인메모리 데이터베이스 로 휘발성 데이터 이니까 만약 유실되었을때 Redis 에서 찾는다고 하면 어떻게 될까요?
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
    public List<String> autocorrect(String keyword) { //TODO 메서드 명 좀 더 신경써주세요
        Long index = redisSortedSetService.findFromSortedSet(keyword); //TODO 어떤 index 인지 명확하게 작성해주세요

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
     * @throws ApiException 조회된 데이터가 없는 경우 예외 발생 //TODO 예외가 발생할까요?
     */
    public List<Drug> getAllDrugs() {return  drugRepository.findAll();}

    /**
     * 단어가 포함된 Drug 데이터를 조회힙니다.
     * @param keyword 검색된 단어
     * @return 던어가 포함된 Drug Entity 리스트
     * @throws ApiException 조회된 약품이 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)//TODO 검색을 통해서 조회를 하는건데 이게 관점이 예외 처리하는게 맞는지 모르겠습니다. 제 생각으로는 없으면 그냥 빈 리스트라도 반환을 해주는 게 맞지 않을까요?
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
        Drug drug = Optional.ofNullable(drugRepository.findByNameKrOrNameEn(name, name)) //TODO 여기에서 Optional로 감싸서 처리하는 것 보단 조회할때 Optional로 가져오는 건 어떨까요?
                .orElseThrow(() -> new ApiException(ErrorCode.DRUG_NOT_FOUND));
        return drugMapper.mapToDrugResponse(drug);
    }
}

package com.be.KKUKKKUK.domain.drug.service;

import com.be.KKUKKKUK.domain.drug.dto.response.DrugResponse;
import com.be.KKUKKKUK.domain.drug.entity.Drug;
import com.be.KKUKKKUK.domain.drug.dto.mapper.DrugMapper;
import com.be.KKUKKKUK.domain.drug.repository.DrugRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
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
 * 25.04.01          eunchang           redis 사용하는 서비스 분리<br>
 */

@Service
@Transactional
@RequiredArgsConstructor
public class DrugService {
    private final DrugRepository drugRepository;
    private final DrugMapper drugMapper;

    /**
     * 전체 Drug 데이터를 조회합니다.
     * @return Drug Entity 리스트
     */
    @Transactional(readOnly = true)
    public List<DrugResponse> getAllDrugs() {
        List<Drug> drugs = drugRepository.findAll();
        return drugMapper.mapToDrugResponseList(drugs);
    }

    /**
     * 단어가 포함된 Drug 데이터를 조회힙니다.
     * @param keyword 검색된 단어
     * @return 던어가 포함된 Drug Entity 리스트
     */
    @Transactional(readOnly = true)
    public List<DrugResponse> searchDrugResponses(String keyword) {
        List<Drug> drugs = drugRepository.findByNameKrContainingIgnoreCaseOrNameEnContainingIgnoreCase(keyword, keyword);
        return drugMapper.mapToDrugResponseList(drugs);
    }

    /**
     * 검색한 단어로 약품을 조회입니다.
     *
     * @param name 약품 이름
     * @return 해당 약품 Entity
     * @throws ApiException 검색한 약품이 없는 경우 예외 발생
     */
    @Transactional(readOnly = true) //TODO 사용하지 않은건 삭제 해주세요
    public DrugResponse getDrug(String name){
        Drug drug = drugRepository.findByNameKrOrNameEn(name, name)
                .orElseThrow(() -> new ApiException(ErrorCode.DRUG_NOT_FOUND));
        return drugMapper.mapToDrugResponse(drug);
    }
}

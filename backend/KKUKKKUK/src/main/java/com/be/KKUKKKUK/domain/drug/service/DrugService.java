package com.be.KKUKKKUK.domain.drug.service;

import com.be.KKUKKKUK.domain.drug.dto.response.DrugResponse;
import com.be.KKUKKKUK.domain.drug.entity.Drug;
import com.be.KKUKKKUK.domain.drug.mapper.DrugMapper;
import com.be.KKUKKKUK.domain.drug.repository.DrugRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;
import java.util.Optional;

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
public class DrugService {
    private final DrugRepository drugRepository;
    private final DrugMapper drugMapper;

    /**
     * 전체 Drug 데이터를 조회합니다.
     * @return Drug Entity 리스트
     * @throws ApiException 조회된 데이터가 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public List<Drug> getAllDrugs() {return  drugRepository.findAll();}

    /**
     * 단어가 포함된 Drug 데이터를 조회힙니다.
     * @param keyword 검색된 단어
     * @return 던어가 포함된 Drug Entity 리스트
     * @throws ApiException 조회된 데이터가 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public List<DrugResponse> searchDrugResponses(String keyword) {
        List<Drug> drugs = Optional.ofNullable(drugRepository.findByNameKrContainingIgnoreCaseOrNameEnContainingIgnoreCase(keyword, keyword))
                .filter(list -> !list.isEmpty())
                .orElseThrow(() -> new ApiException(ErrorCode.DRUG_NOT_FOUND));
        return drugMapper.mapDrugToDrugResponse(drugs);
    }

}

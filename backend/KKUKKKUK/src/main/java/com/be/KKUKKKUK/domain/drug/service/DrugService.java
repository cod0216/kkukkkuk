package com.be.KKUKKKUK.domain.drug.service;

import com.be.KKUKKKUK.domain.drug.entity.Drug;
import com.be.KKUKKKUK.domain.drug.repository.DrugRepository;
import com.be.KKUKKKUK.global.exception.ApiException;
import com.be.KKUKKKUK.global.exception.ErrorCode;
import lombok.RequiredArgsConstructor;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.List;

@Service
@RequiredArgsConstructor
public class DrugService {
    private final DrugRepository drugRepository;

    /**
     * 전체 Drug 데이터를 조회합니다.
     * @return Drug Entity 리스트
     * @throws ApiException 조회된 데이터가 없는 경우 예외 발생
     */
    @Transactional(readOnly = true)
    public List<Drug> getAllDrugs() {return  drugRepository.findAll();}
}

import React, { FC, useState, useEffect, useRef } from 'react';
import { PlusCircle, Loader, Search } from 'lucide-react';
import { TreatmentType, ExaminationTreatment, MedicationTreatment, VaccinationTreatment } from '@/interfaces/blockChain';
import { getDrugAutoComplete, searchDrugs } from '@/services/drugSearchService';

/**
 * @module PrescriptionSection
 * @file PrescriptionSection.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 반려동물 진단 처방을 관리하는 UI 컴포넌트입니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         처방 정보 표시 방식 개선 (key 필드 사용)
 * 2025-04-02        seonghun         엔터를 이용한 처방 추가 기능, null과 undefined 처리 개선
 * 2025-04-05        youName          약품 자동완성 기능 추가
 */


/**
 * PrescriptionSection 컴포넌트의 Props 타입 정의
 */
interface PrescriptionSectionProps {
    prescriptions: any; // 현재 처방 목록
    setPrescriptions: React.Dispatch<any>; // 처방 목록을 업데이트하는 함수
    treatmentType: TreatmentType; // 현재 선택된 치료 유형
    setTreatmentType: React.Dispatch<React.SetStateAction<TreatmentType>>; // 치료 유형 변경 함수
    prescriptionType: string; // 입력된 처방 항목명
    setPrescriptionType: React.Dispatch<React.SetStateAction<string>>; // 처방 항목명 변경 함수
    prescriptionDosage: string; // 입력된 처방 용량
    setPrescriptionDosage: React.Dispatch<React.SetStateAction<string>>; // 처방 용량 변경 함수
    petSpecies?: string; // 반려동물 종류 (자동완성 필터링용)
}

/**
 * PrescriptionSection - 반려동물 처방을 관리하는 컴포넌트입니다
 */
const PrescriptionSection: FC<PrescriptionSectionProps> = ({
    prescriptions, setPrescriptions, treatmentType, setTreatmentType,
    prescriptionType, setPrescriptionType, prescriptionDosage, setPrescriptionDosage,
    petSpecies = ''
}) => {
    // 자동완성 관련 상태
    const [autoCompleteResults, setAutoCompleteResults] = useState<string[]>([]);
    const [_drugSearchResults, setDrugSearchResults] = useState<any[]>([]);
    const [showAutoComplete, setShowAutoComplete] = useState(false);
    const [isSearching, setIsSearching] = useState(false);
    const [selectedIndex, setSelectedIndex] = useState(-1);
    const autoCompleteRef = useRef<HTMLDivElement>(null);
    const inputRef = useRef<HTMLInputElement>(null);

    // 외부 클릭 감지하여 자동완성 닫기
    useEffect(() => {
        const handleClickOutside = (event: MouseEvent) => {
            if (autoCompleteRef.current && !autoCompleteRef.current.contains(event.target as Node) && 
                inputRef.current && !inputRef.current.contains(event.target as Node)) {
                setShowAutoComplete(false);
            }
        };

        document.addEventListener('mousedown', handleClickOutside);
        return () => {
            document.removeEventListener('mousedown', handleClickOutside);
        };
    }, []);

    // 약품 자동완성 검색
    useEffect(() => {
        const fetchAutoComplete = async () => {
            if (treatmentType === TreatmentType.MEDICATION && prescriptionType.trim().length > 1) {
                setIsSearching(true);
                try {
                    console.log(`[UI] 약품 자동완성 요청 시작: "${prescriptionType}" (동물종류: ${petSpecies || '없음'})`);
                    // petSpecies 정보를 자동완성 API에 전달 (동물별 필터링용)
                    const result = await getDrugAutoComplete(prescriptionType, petSpecies);
                    if (result.status === "SUCCESS") {
                        console.log(`[UI] 약품 자동완성 결과 수신: ${result.data?.length || 0}개`);
                        setAutoCompleteResults(result.data || []);
                        setShowAutoComplete(true);
                    } else {
                        console.warn(`[UI] 약품 자동완성 오류: ${result.message}`);
                    }
                } catch (error) {
                    console.error("[UI] 자동완성 검색 오류:", error);
                } finally {
                    setIsSearching(false);
                }
            } else {
                setShowAutoComplete(false);
            }
        };

        const timer = setTimeout(fetchAutoComplete, 300); // 입력 디바운싱
        return () => clearTimeout(timer);
    }, [prescriptionType, treatmentType, petSpecies]); // petSpecies 의존성 추가

    // 약품 상세 정보 검색
    const fetchDrugDetails = async (drugName: string) => {
        try {
            console.log(`[UI] 약품 상세 정보 검색: "${drugName}"`);
            const result = await searchDrugs(drugName);
            if (result.status === "SUCCESS" && result.data) {
                console.log(`[UI] 약품 검색 결과: ${result.data.length}개 항목`);
                setDrugSearchResults(result.data);
                
                // 동물 종류에 맞는 약품 찾기
                if (petSpecies && result.data.length > 0) {
                    console.log(`[UI] '${petSpecies}'에 적합한 약품 찾는 중...`);
                    const matchingDrug = result.data.find((drug: any) => 
                        drug.apply_animal && drug.apply_animal.toLowerCase().includes(petSpecies.toLowerCase())
                    );
                    
                    if (matchingDrug) {
                        console.log(`[UI] '${petSpecies}'에 적합한 약품 찾음:`, matchingDrug.name_kr);
                        return matchingDrug;
                    } else {
                        console.log(`[UI] '${petSpecies}'에 적합한 약품을 찾지 못함`);
                    }
                }
                
                // 첫 번째 결과 반환
                console.log(`[UI] 첫 번째 약품 결과 사용:`, result.data[0].name_kr);
                return result.data[0];
            }
        } catch (error) {
            console.error("약품 정보 검색 오류:", error);
        }
        return null;
    };

    // 약품 선택 핸들러
    const handleDrugSelect = async (drugName: string) => {
        console.log(`[UI] 약품 선택: "${drugName}"`);
        setPrescriptionType(drugName);
        setShowAutoComplete(false);
        setSelectedIndex(-1);
        
        // 선택한 약품의 상세 정보 조회
        const drugInfo = await fetchDrugDetails(drugName);
        
        if (drugInfo) {
            // 동물 적용 정보를 용량 필드에 자동 제안
            let suggestion = drugInfo.apply_animal ? `적용 동물: ${drugInfo.apply_animal}` : '';
            console.log(`[UI] 약품 용량 자동 제안: "${suggestion}"`);
            setPrescriptionDosage(suggestion);
            
            // 포커스를 용량 필드로 이동
            const dosageInput = document.querySelector<HTMLInputElement>('input[placeholder="용량/결과"]');
            if (dosageInput) {
                dosageInput.focus();
            }
        } else {
            console.warn(`[UI] 약품 상세 정보를 찾지 못함: "${drugName}"`);
        }
    };

    // 키보드 이벤트 핸들러 - 화살표 위/아래로 자동완성 항목 선택
    const handleKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
        // 엔터키 처리
        if (e.key === 'Enter') {
            e.preventDefault();
            
            // 자동완성 열려있고 항목 선택되어 있으면 해당 항목 선택
            if (showAutoComplete && selectedIndex >= 0 && selectedIndex < autoCompleteResults.length) {
                handleDrugSelect(autoCompleteResults[selectedIndex]);
            } else {
                addPrescription();
            }
            return;
        }
        
        // 자동완성 목록이 열려있을 때만 화살표 키 처리
        if (showAutoComplete) {
            if (e.key === 'ArrowDown') {
                // 아래 화살표 - 다음 항목 선택
                e.preventDefault();
                setSelectedIndex(prev => 
                    prev < autoCompleteResults.length - 1 ? prev + 1 : prev
                );
            } else if (e.key === 'ArrowUp') {
                // 위 화살표 - 이전 항목 선택
                e.preventDefault();
                setSelectedIndex(prev => (prev > 0 ? prev - 1 : 0));
            } else if (e.key === 'Escape') {
                // ESC - 자동완성 닫기
                setShowAutoComplete(false);
                setSelectedIndex(-1);
            }
        }
    };

    /**
     * 처방을 추가하는 함수입니다. 
     * 사용자가 입력한 처방 항목명과 용량이 비어 있지 않다면, 해당 치료 유형에 맞는 배열에 추가합니다. 
     */
    const addPrescription = () => {
        if (prescriptionType.trim() && prescriptionDosage.trim()) {
            const newPrescription = {
                type: treatmentType,
                key: prescriptionType,
                value: prescriptionDosage
            };

            // 기존 처방 목록을 복사
            const updatedPrescriptions = { ...prescriptions };

            // 치료 유형에 따라 해당 배열에 추가
            if (treatmentType === TreatmentType.EXAMINATION) {
                updatedPrescriptions.examinations.push(newPrescription as ExaminationTreatment);
            } else if (treatmentType === TreatmentType.MEDICATION) {
                updatedPrescriptions.medications.push(newPrescription as MedicationTreatment);
            } else if (treatmentType === TreatmentType.VACCINATION) {
                updatedPrescriptions.vaccinations.push(newPrescription as VaccinationTreatment);
            }

            console.log('처방 추가:', newPrescription, '업데이트된 처방:', updatedPrescriptions);
            
            // 상태 업데이트 및 입력값 초기화
            setPrescriptions(updatedPrescriptions);
            setPrescriptionType('');
            setPrescriptionDosage('');
            setShowAutoComplete(false);
            setSelectedIndex(-1);
        }
    };

    /**
     * 처방을 삭제하는 함수입니다. 
     * 특정 인덱스의 처방 항목을 해당 치료 유형의 목록에서 제거합니다. 
     * @param index 삭제할 처방 항목의 인덱스
     * @param type 삭제할 처방 항목이 속한 치료 유형
     */
    const removePrescription = (index: number, type: TreatmentType) => {
        const updatedPrescriptions = { ...prescriptions };
        if (type === TreatmentType.EXAMINATION) {
            updatedPrescriptions.examinations.splice(index, 1);
        } else if (type === TreatmentType.MEDICATION) {
            updatedPrescriptions.medications.splice(index, 1);
        } else if (type === TreatmentType.VACCINATION) {
            updatedPrescriptions.vaccinations.splice(index, 1);
        }
        setPrescriptions(updatedPrescriptions);
    };

    return (
        <div className= "flex-1 w-full h-full">
        <div className="flex gap-2 flex-col w-full h-full">
            {/* 처방 입력 필드 */}
            <div className="flex flex-wrap gap-1 items-center w-full">
                {/* 치료 유형 선택 */}
                <div className="flex-1 min-w-16 max-w-20">
                    <select
                        value={treatmentType}
                        onChange={(e) => setTreatmentType(e.target.value as TreatmentType)}
                        className="text-xs border rounded py-1 px-1 w-full"
                    >
                        {Object.values(TreatmentType).map((type) => (
                            <option key={type} value={type}>{type}</option>
                        ))}
                    </select>
                </div>

                {/* 처방 항목명 입력 - 약물일 때 자동완성 활성화 */}
                <div className="flex-1 min-w-20 relative">
                    <div className="relative">
                        <input
                            ref={inputRef}
                            type="text"
                            value={prescriptionType}
                            onChange={(e) => setPrescriptionType(e.target.value)}
                            onKeyDown={handleKeyDown}
                            placeholder={treatmentType === TreatmentType.MEDICATION ? "약품명 검색..." : "항목명"}
                            className="border rounded px-2 py-1 text-xs w-full"
                            onFocus={() => {
                                if (treatmentType === TreatmentType.MEDICATION && 
                                    prescriptionType.trim().length > 1 && 
                                    autoCompleteResults.length > 0) {
                                    setShowAutoComplete(true);
                                }
                            }}
                        />
                        {treatmentType === TreatmentType.MEDICATION && isSearching && (
                            <span className="absolute right-2 top-1">
                                <Loader className="w-3 h-3 animate-spin text-gray-400" />
                            </span>
                        )}
                        {treatmentType === TreatmentType.MEDICATION && !isSearching && (
                            <span className="absolute right-2 top-1">
                                <Search className="w-3 h-3 text-gray-400" />
                            </span>
                        )}
                    </div>
                    
                    {/* 자동완성 드롭다운 */}
                    {treatmentType === TreatmentType.MEDICATION && showAutoComplete && autoCompleteResults.length > 0 && (
                        <div 
                            ref={autoCompleteRef}
                            className="absolute z-10 mt-1 w-full bg-white border rounded-md shadow-lg max-h-40 overflow-y-auto text-xs"
                        >
                            {autoCompleteResults.map((item, index) => (
                                <div
                                    key={index}
                                    className={`p-2 hover:bg-gray-100 cursor-pointer ${
                                        selectedIndex === index ? 'bg-primary-50 text-primary-700' : ''
                                    }`}
                                    onClick={() => handleDrugSelect(item)}
                                >
                                    {item}
                                </div>
                            ))}
                        </div>
                    )}
                </div>

                {/* 처방 용량 입력 */}
                <div className="flex-1 min-w-20">
                    <input
                        type="text"
                        value={prescriptionDosage}
                        onChange={(e) => setPrescriptionDosage(e.target.value)}
                        onKeyDown={(e) => {
                            if (e.key === 'Enter') {
                                e.preventDefault();
                                addPrescription();
                            }
                        }}
                        placeholder="용량/결과"
                        className="border rounded px-2 py-1 text-xs w-full"
                    />
                </div>

                {/* 처방 추가 버튼 */}
                <button
                    onClick={addPrescription}
                    className="p-1 text-xs text-gray-500 h-6 w-6 flex-shrink-0"
                >
                    <PlusCircle className="w-4 h-4" />
                </button>
            </div>

            {/* 기존 처방 목록 표시 */}
            <div className="flex gap-1 flex-col text-xs p-2 w-full flex-1 overflow-y-auto max-h-[240px]">
                {prescriptions.examinations.length > 0 && (
                    <div className="font-bold text-xs mt-1">검사</div>
                )}
                {prescriptions.examinations.map((item: any, index: number) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg">
                        <div className="truncate mr-1 max-w-[40%]">{item.key}</div>
                        <div className="truncate mr-1 max-w-[40%]">{item.value}</div>
                        <button onClick={() => removePrescription(index, TreatmentType.EXAMINATION)} className="text-primary-500 text-xs flex-shrink-0">x</button>
                    </div>
                ))}

                {prescriptions.medications.length > 0 && (
                    <div className="font-bold text-xs mt-1">약물</div>
                )}
                {prescriptions.medications.map((item: any, index: number) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg">
                        <div className="truncate mr-1 max-w-[40%]">{item.key}</div>
                        <div className="truncate mr-1 max-w-[40%]">{item.value}</div>
                        <button onClick={() => removePrescription(index, TreatmentType.MEDICATION)} className="text-primary-500 text-xs flex-shrink-0">x</button>
                    </div>
                ))}
                {prescriptions.vaccinations.length > 0 && (
                    <div className="font-bold text-xs mt-1">접종</div>
                )}
                {prescriptions.vaccinations.map((item: any, index: number) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg">
                        <div className="truncate mr-1 max-w-[40%]">{item.key}</div>
                        <div className="truncate mr-1 max-w-[40%]">{item.value}</div>
                        <button onClick={() => removePrescription(index, TreatmentType.VACCINATION)} className="text-primary-500 text-xs flex-shrink-0">x</button>
                    </div>
                ))}
            </div>
        </div>
        </div>
    );
};

export default PrescriptionSection;

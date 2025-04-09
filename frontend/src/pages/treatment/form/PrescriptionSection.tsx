import React, { FC, useState, useEffect, useRef } from 'react';
import { PlusCircle, Loader, Search, Trash2 } from 'lucide-react';
import { TreatmentType, ExaminationTreatment, MedicationTreatment, VaccinationTreatment } from '@/interfaces/blockChain';
import { getDrugAutoComplete } from '@/services/drugSearchService';

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

// 입력 상태 타입 정의
interface InputState {
    key: string;
    value: string;
}

// PrescriptionSection Props 타입 정의 (불필요한 props 제거)
interface PrescriptionSectionProps {
    prescriptions: {
        examinations: ExaminationTreatment[];
        medications: MedicationTreatment[];
        vaccinations: VaccinationTreatment[];
    };
    setPrescriptions: React.Dispatch<React.SetStateAction<{
        examinations: ExaminationTreatment[];
        medications: MedicationTreatment[];
        vaccinations: VaccinationTreatment[];
    }>>;
    petSpecies?: string; // 약물 자동완성용
}

/**
 * PrescriptionSection - 반려동물 처방을 관리하는 컴포넌트입니다
 */
const PrescriptionSection: FC<PrescriptionSectionProps> = ({
    prescriptions, setPrescriptions, petSpecies = ''
}) => {
    // 1. 섹션별 입력 상태 정의
    const [examinationInput, setExaminationInput] = useState<InputState>({ key: '', value: '' });
    const [medicationInput, setMedicationInput] = useState<InputState>({ key: '', value: '' });
    const [vaccinationInput, setVaccinationInput] = useState<InputState>({ key: '', value: '' });

    // 2. 약물 자동완성 관련 상태 및 Ref
    const [autoCompleteResults, setAutoCompleteResults] = useState<string[]>([]);
    const [showAutoComplete, setShowAutoComplete] = useState(false);
    const [isSearching, setIsSearching] = useState(false);
    const [selectedIndex, setSelectedIndex] = useState(-1);
    const autoCompleteRef = useRef<HTMLDivElement>(null);
    const medicationKeyInputRef = useRef<HTMLInputElement>(null);
    const medicationValueInputRef = useRef<HTMLInputElement>(null);
    // 다른 섹션 Ref (필요 시)
    const examinationKeyInputRef = useRef<HTMLInputElement>(null);
    const examinationValueInputRef = useRef<HTMLInputElement>(null);
    const vaccinationKeyInputRef = useRef<HTMLInputElement>(null);
    const vaccinationValueInputRef = useRef<HTMLInputElement>(null);

    // 3. 약물 자동완성 로직 (useEffect, handlers - 이전과 유사하게 유지)
    useEffect(() => { // 외부 클릭 감지
        const handleClickOutside = (event: MouseEvent) => {
            if (autoCompleteRef.current && !autoCompleteRef.current.contains(event.target as Node) &&
                medicationKeyInputRef.current && !medicationKeyInputRef.current.contains(event.target as Node)) {
                setShowAutoComplete(false);
            }
        };
        document.addEventListener('mousedown', handleClickOutside);
        return () => document.removeEventListener('mousedown', handleClickOutside);
    }, []);

    useEffect(() => { // 자동완성 API 호출
        const fetchAutoComplete = async () => {
            if (medicationInput.key.trim().length > 1) {
                setIsSearching(true);
                try {
                    const result = await getDrugAutoComplete(medicationInput.key, petSpecies);
                    setAutoCompleteResults(result.status === "SUCCESS" ? (result.data || []) : []);
                    setShowAutoComplete(result.status === "SUCCESS" && (result.data?.length || 0) > 0);
                } catch (error) {
                    console.error("[UI] 자동완성 검색 오류:", error);
                    setAutoCompleteResults([]); setShowAutoComplete(false);
                } finally { setIsSearching(false); }
            } else {
                setAutoCompleteResults([]); setShowAutoComplete(false);
            }
        };
        const timer = setTimeout(fetchAutoComplete, 300);
        return () => clearTimeout(timer);
    }, [medicationInput.key, petSpecies]);

    const handleDrugSelect = (drugName: string) => { // 약물 선택 시
        setMedicationInput(prev => ({ ...prev, key: drugName }));
        setShowAutoComplete(false);
        setSelectedIndex(-1);
        medicationValueInputRef.current?.focus(); // 값 필드로 포커스
    };

    const handleMedicationKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => { // 약물 키 입력 이벤트
        if (showAutoComplete) { // 자동완성 활성화 시
            if (e.key === 'ArrowDown') { e.preventDefault(); setSelectedIndex(prev => Math.min(prev + 1, autoCompleteResults.length - 1)); }
            else if (e.key === 'ArrowUp') { e.preventDefault(); setSelectedIndex(prev => Math.max(prev - 1, 0)); }
            else if (e.key === 'Enter') {
                e.preventDefault();
                if (selectedIndex >= 0 && selectedIndex < autoCompleteResults.length) {
                    handleDrugSelect(autoCompleteResults[selectedIndex]);
                } else { medicationValueInputRef.current?.focus(); } // 자동완성 미선택 시 값 필드로
            }
            else if (e.key === 'Escape') { setShowAutoComplete(false); setSelectedIndex(-1); }
        } else if (e.key === 'Enter') { // 자동완성 비활성화 시 Enter
            e.preventDefault();
            medicationValueInputRef.current?.focus(); // 값 필드로 이동
        }
    };

    // 4. 처방 추가 함수 (type별로 분기)
    const addPrescription = (type: TreatmentType) => {
        let inputState: InputState, setInputState: React.Dispatch<React.SetStateAction<InputState>>, listKey: keyof typeof prescriptions, keyInputRef: React.RefObject<HTMLInputElement | null>;

        if (type === TreatmentType.EXAMINATION) { [inputState, setInputState, listKey, keyInputRef] = [examinationInput, setExaminationInput, 'examinations', examinationKeyInputRef]; }
        else if (type === TreatmentType.MEDICATION) { [inputState, setInputState, listKey, keyInputRef] = [medicationInput, setMedicationInput, 'medications', medicationKeyInputRef]; }
        else if (type === TreatmentType.VACCINATION) { [inputState, setInputState, listKey, keyInputRef] = [vaccinationInput, setVaccinationInput, 'vaccinations', vaccinationKeyInputRef]; }
        else { return; }

        if (inputState.key.trim() && inputState.value.trim()) {
            const newPrescription = { key: inputState.key.trim(), value: inputState.value.trim() };
            setPrescriptions(prev => ({ ...prev, [listKey]: [...prev[listKey], newPrescription as any] }));
            setInputState({ key: '', value: '' }); // 입력 초기화
            if(type === TreatmentType.MEDICATION) { setShowAutoComplete(false); setSelectedIndex(-1); } // 약물 자동완성 닫기
            keyInputRef?.current?.focus(); // 해당 섹션 key 필드로 포커스
        }
    };

    // 5. 처방 삭제 함수 (이전과 동일)
    const removePrescription = (index: number, type: TreatmentType) => {
        let listKey: keyof typeof prescriptions;
        if (type === TreatmentType.EXAMINATION) listKey = 'examinations';
        else if (type === TreatmentType.MEDICATION) listKey = 'medications';
        else if (type === TreatmentType.VACCINATION) listKey = 'vaccinations';
        else return;
        setPrescriptions(prev => ({ ...prev, [listKey]: prev[listKey].filter((_, i) => i !== index) }));
    };

    // 6. 섹션 렌더링 함수 (UI 구성)
    const renderSection = (
        type: TreatmentType,
        title: string,
        inputState: InputState,
        setInputState: React.Dispatch<React.SetStateAction<InputState>>,
        list: any[],
        bgColor: string,
        keyPlaceholder: string,
        valuePlaceholder: string,
        keyInputRef: React.RefObject<HTMLInputElement | null>,
        valueInputRef: React.RefObject<HTMLInputElement | null>
    ) => {
        const handleLocalKeyDown = (e: React.KeyboardEvent<HTMLInputElement>, field: 'key' | 'value') => {
                            if (e.key === 'Enter') {
                                e.preventDefault();
                if (field === 'key') { valueInputRef?.current?.focus(); }
                else { addPrescription(type); }
            }
        };

        const keyKeyDownHandler = type === TreatmentType.MEDICATION ? handleMedicationKeyDown : (e: React.KeyboardEvent<HTMLInputElement>) => handleLocalKeyDown(e, 'key');

        return (
            // 섹션 컨테이너 - mb-4 유지
            <div className="mb-4">
                {/* 입력 행: Grid 구조 변경 (제목 추가), items-center 추가 */}
                <div className={`grid grid-cols-[auto_minmax(0,1fr)_minmax(0,1fr)_auto] gap-x-2 items-center w-full mb-2`}>
                    {/* 제목 컬럼 */}
                    <h4 className="font-bold text-sm text-gray-700 w-12 text-right pr-2">{title}</h4>

                    {/* 항목명 입력 컬럼 */}
                    <div className={`${type === TreatmentType.MEDICATION ? 'relative' : ''}`}>
                         <div className="relative">
                            <input
                                ref={keyInputRef}
                                type="text"
                                value={inputState.key}
                                onChange={(e) => setInputState(prev => ({ ...prev, key: e.target.value }))}
                                onKeyDown={keyKeyDownHandler}
                                placeholder={keyPlaceholder}
                                className="border p-2 text-sm rounded-md w-full"
                                onFocus={() => { if (type === TreatmentType.MEDICATION && autoCompleteResults.length > 0) { setShowAutoComplete(true); } }}
                            />
                            {type === TreatmentType.MEDICATION && isSearching && <span className="absolute right-2 top-1/2 -translate-y-1/2"><Loader className="w-4 h-4 animate-spin text-gray-400" /></span>}
                            {type === TreatmentType.MEDICATION && !isSearching && inputState.key.length > 0 && !showAutoComplete && <span className="absolute right-2 top-1/2 -translate-y-1/2"><Search className="w-4 h-4 text-gray-400" /></span>}
                        </div>
                        {type === TreatmentType.MEDICATION && showAutoComplete && autoCompleteResults.length > 0 && (
                            <div ref={autoCompleteRef} className="absolute z-10 mt-1 w-full bg-white border rounded-md shadow-lg max-h-40 overflow-y-auto text-xs">
                                {autoCompleteResults.map((item, index) => (
                                    <div key={index}
                                        className={`p-2 hover:bg-gray-100 cursor-pointer ${selectedIndex === index ? 'bg-primary-50 text-primary-700 font-semibold' : ''}`}
                                        onClick={() => handleDrugSelect(item)}
                                        onMouseEnter={() => setSelectedIndex(index)}>
                                        {item}
                                    </div>
                                ))}
                            </div>
                        )}
                </div>
                    {/* 용량/결과 입력 컬럼 */}
                    <input
                        ref={valueInputRef}
                        type="text"
                        value={inputState.value}
                        onChange={(e) => setInputState(prev => ({ ...prev, value: e.target.value }))}
                        onKeyDown={(e) => handleLocalKeyDown(e, 'value')}
                        placeholder={valuePlaceholder}
                        className="border p-2 text-sm rounded-md w-full"
                    />
                    {/* 추가 버튼 컬럼 */}
                    <button onClick={() => addPrescription(type)}
                        className="p-2 text-gray-500 flex-shrink-0 rounded-md flex items-center justify-center hover:bg-gray-100">
                        <PlusCircle className="w-5 h-5" />
                    </button>
                </div>

                {/* 목록 표시 영역 - 제목 너비만큼 왼쪽에 마진 추가, 한 줄 레이아웃 복원 */}
                <div className="ml-14 flex gap-1 flex-col w-auto max-h-[150px] overflow-y-auto">
                    {list.length === 0 ? (
                        <div className="text-center text-gray-400 text-xs py-2">추가된 {title} 항목이 없습니다.</div>
                    ) : (
                        list.map((item, index) => (
                            // 목록 아이템 - Grid 구조 변경 (한 줄 표시), py-1.5 유지
                            <div key={`${type}-${index}`} className={`grid grid-cols-[minmax(0,1fr)_minmax(0,auto)_auto] gap-x-2 items-center py-1.5 px-2 ${bgColor} rounded-md mb-1`}>
                                {/* 항목명 */}
                                <span className="truncate text-xs font-medium" title={item.key}>{item.key}</span>
                                {/* 결과/용량 (오른쪽 정렬) */}
                                <span className="truncate text-xs text-gray-700 text-right" title={item.value}>{item.value}</span> {/* text-right 복원 */}
                                {/* 삭제 버튼 */}
                                <button onClick={() => removePrescription(index, type)} className="text-red-500 hover:text-red-700 text-xs font-bold flex-shrink-0 w-5 h-5 flex items-center justify-center justify-self-end">
                                    <Trash2 className="w-4 h-4" />
                </button>
            </div>
                        ))
                    )}
                    </div>
            </div>
        );
    };

    // 7. 최종 JSX 반환 (이전과 동일, 제목 변경됨)
    return (
        <div className="flex-1 w-full h-full flex flex-col">
            {renderSection(
                TreatmentType.EXAMINATION, "검사", examinationInput, setExaminationInput, prescriptions.examinations, "bg-blue-50",
                "검사항목", "결과", examinationKeyInputRef, examinationValueInputRef
            )}
            {renderSection(
                TreatmentType.MEDICATION, "약물", medicationInput, setMedicationInput, prescriptions.medications, "bg-green-50",
                "약품명 검색...", "용량/횟수", medicationKeyInputRef, medicationValueInputRef
            )}
            {renderSection(
                TreatmentType.VACCINATION, "접종", vaccinationInput, setVaccinationInput, prescriptions.vaccinations, "bg-yellow-50",
                "백신명", "접종일/차수 등", vaccinationKeyInputRef, vaccinationValueInputRef
            )}
        </div>
    );
};

export default PrescriptionSection;

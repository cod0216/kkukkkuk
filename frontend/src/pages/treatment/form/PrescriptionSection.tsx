import React, { FC, useState, useEffect, useRef } from "react";
import { PlusCircle, Loader, Search, Trash2 } from "lucide-react";
import {
  TreatmentType,
  ExaminationTreatment,
  MedicationTreatment,
  VaccinationTreatment,
} from "@/interfaces/blockChain";
import { getDrugAutoComplete } from "@/services/drugSearchService";
import { autoCorrectDiagnosis as getExamAutoComplete } from "@/services/diagnosisSearchService";
import { autoCorrectVaccination as getVaccinationAutoComplete } from "@/services/vaccinationSearchService";

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
 * 2025-04-05        eunchang          접종 및 검사 자동완성 기능 추가
 */

// 입력 상태 타입 정의

// 입력 상태 타입 정의
interface InputState {
  key: string;
  value: string;
}

interface PrescriptionSectionProps {
  prescriptions: {
    examinations: ExaminationTreatment[];
    medications: MedicationTreatment[];
    vaccinations: VaccinationTreatment[];
  };
  setPrescriptions: React.Dispatch<
    React.SetStateAction<{
      examinations: ExaminationTreatment[];
      medications: MedicationTreatment[];
      vaccinations: VaccinationTreatment[];
    }>
  >;
  petSpecies?: string;
}

const PrescriptionSection: FC<PrescriptionSectionProps> = ({
  prescriptions,
  setPrescriptions,
  petSpecies = "",
}) => {
  // 섹션별 입력 상태
  const [examinationInput, setExaminationInput] = useState<InputState>({
    key: "",
    value: "",
  });
  const [medicationInput, setMedicationInput] = useState<InputState>({
    key: "",
    value: "",
  });
  const [vaccinationInput, setVaccinationInput] = useState<InputState>({
    key: "",
    value: "",
  });

  // 약물 자동완성 상태 및 Ref
  const [autoCompleteResults, setAutoCompleteResults] = useState<string[]>([]);
  const [showAutoComplete, setShowAutoComplete] = useState(false);
  const [isSearching, setIsSearching] = useState(false);
  const [selectedIndex, setSelectedIndex] = useState(-1);
  const [skipMedicationAutoComplete, setSkipMedicationAutoComplete] =
    useState(false);
  const autoCompleteRef = useRef<HTMLDivElement>(null);
  const medicationKeyInputRef = useRef<HTMLInputElement>(null);
  const medicationValueInputRef = useRef<HTMLInputElement>(null);

  // 검사 자동완성 상태 및 Ref
  const [autoCompleteResultsExam, setAutoCompleteResultsExam] = useState<
    string[]
  >([]);
  const [showAutoCompleteExam, setShowAutoCompleteExam] = useState(false);
  const [isSearchingExam, setIsSearchingExam] = useState(false);
  const [selectedIndexExam, setSelectedIndexExam] = useState(-1);
  const [skipExamAutoComplete, setSkipExamAutoComplete] = useState(false);
  const autoCompleteRefExam = useRef<HTMLDivElement>(null);
  const examinationKeyInputRef = useRef<HTMLInputElement>(null);
  const examinationValueInputRef = useRef<HTMLInputElement>(null);

  // 접종 자동완성 상태 및 Ref
  const [autoCompleteResultsVacc, setAutoCompleteResultsVacc] = useState<
    string[]
  >([]);
  const [showAutoCompleteVacc, setShowAutoCompleteVacc] = useState(false);
  const [isSearchingVacc, setIsSearchingVacc] = useState(false);
  const [selectedIndexVacc, setSelectedIndexVacc] = useState(-1);
  const [skipVaccAutoComplete, setSkipVaccAutoComplete] = useState(false);
  const autoCompleteRefVacc = useRef<HTMLDivElement>(null);
  const vaccinationKeyInputRef = useRef<HTMLInputElement>(null);
  const vaccinationValueInputRef = useRef<HTMLInputElement>(null);

  // 외부 클릭 시 모든 자동완성 드롭다운 닫기
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      if (
        autoCompleteRef.current &&
        !autoCompleteRef.current.contains(event.target as Node) &&
        medicationKeyInputRef.current &&
        !medicationKeyInputRef.current.contains(event.target as Node) &&
        autoCompleteRefExam.current &&
        !autoCompleteRefExam.current.contains(event.target as Node) &&
        examinationKeyInputRef.current &&
        !examinationKeyInputRef.current.contains(event.target as Node) &&
        autoCompleteRefVacc.current &&
        !autoCompleteRefVacc.current.contains(event.target as Node) &&
        vaccinationKeyInputRef.current &&
        !vaccinationKeyInputRef.current.contains(event.target as Node)
      ) {
        setShowAutoComplete(false);
        setShowAutoCompleteExam(false);
        setShowAutoCompleteVacc(false);
      }
    };
    document.addEventListener("mousedown", handleClickOutside);
    return () => document.removeEventListener("mousedown", handleClickOutside);
  }, []);

  // 약물 자동완성 API 호출
  useEffect(() => {
    const fetchAutoComplete = async () => {
      if (skipMedicationAutoComplete) return; // skip 상태이면 API 호출 건너뜀
      if (medicationInput.key.trim().length >= 1) {
        setIsSearching(true);
        try {
          const result = await getDrugAutoComplete(
            medicationInput.key,
            petSpecies
          );
          setAutoCompleteResults(
            result.status === "SUCCESS" ? result.data || [] : []
          );
          setShowAutoComplete(
            result.status === "SUCCESS" && (result.data?.length || 0) > 0
          );
        } catch (error) {
          console.error("[UI] 자동완성 검색 오류 (약물):", error);
          setAutoCompleteResults([]);
          setShowAutoComplete(false);
        } finally {
          setIsSearching(false);
        }
      } else {
        setAutoCompleteResults([]);
        setShowAutoComplete(false);
      }
    };
    fetchAutoComplete();
  }, [medicationInput.key, petSpecies, skipMedicationAutoComplete]);

  // 검사 자동완성 API 호출
  useEffect(() => {
    const fetchAutoCompleteExam = async () => {
      if (skipExamAutoComplete) return;
      if (examinationInput.key.trim().length >= 1) {
        setIsSearchingExam(true);
        try {
          const result = await getExamAutoComplete(
            examinationInput.key,
            petSpecies
          );
          setAutoCompleteResultsExam(
            result.status === "SUCCESS" ? result.data || [] : []
          );
          setShowAutoCompleteExam(
            result.status === "SUCCESS" && (result.data?.length || 0) > 0
          );
        } catch (error) {
          console.error("[UI] 자동완성 검색 오류 (검사):", error);
          setAutoCompleteResultsExam([]);
          setShowAutoCompleteExam(false);
        } finally {
          setIsSearchingExam(false);
        }
      } else {
        setAutoCompleteResultsExam([]);
        setShowAutoCompleteExam(false);
      }
    };
    fetchAutoCompleteExam();
  }, [examinationInput.key, petSpecies, skipExamAutoComplete]);

  // 접종 자동완성 API 호출
  useEffect(() => {
    const fetchAutoCompleteVacc = async () => {
      if (skipVaccAutoComplete) return;
      if (vaccinationInput.key.trim().length >= 1) {
        setIsSearchingVacc(true);
        try {
          const result = await getVaccinationAutoComplete(
            vaccinationInput.key,
            petSpecies
          );
          setAutoCompleteResultsVacc(
            result.status === "SUCCESS" ? result.data || [] : []
          );
          setShowAutoCompleteVacc(
            result.status === "SUCCESS" && (result.data?.length || 0) > 0
          );
        } catch (error) {
          console.error("[UI] 자동완성 검색 오류 (접종):", error);
          setAutoCompleteResultsVacc([]);
          setShowAutoCompleteVacc(false);
        } finally {
          setIsSearchingVacc(false);
        }
      } else {
        setAutoCompleteResultsVacc([]);
        setShowAutoCompleteVacc(false);
      }
    };
    fetchAutoCompleteVacc();
  }, [vaccinationInput.key, petSpecies, skipVaccAutoComplete]);

  // onChange 이벤트에서 skip 플래그 초기화
  const handleMedicationChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setMedicationInput((prev) => ({ ...prev, key: e.target.value }));
    setSkipMedicationAutoComplete(false);
  };
  const handleExamChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setExaminationInput((prev) => ({ ...prev, key: e.target.value }));
    setSkipExamAutoComplete(false);
  };
  const handleVaccChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    setVaccinationInput((prev) => ({ ...prev, key: e.target.value }));
    setSkipVaccAutoComplete(false);
  };

  // 약물 선택 핸들러
  const handleDrugSelect = (drugName: string) => {
    setMedicationInput((prev) => ({ ...prev, key: drugName }));
    setShowAutoComplete(false);
    setSelectedIndex(-1);
    medicationValueInputRef.current?.focus();
  };

  // 검사 선택 핸들러
  const handleExamSelect = (examName: string) => {
    setExaminationInput((prev) => ({ ...prev, key: examName }));
    setShowAutoCompleteExam(false);
    setSelectedIndexExam(-1);
    examinationValueInputRef.current?.focus();
  };

  // 접종 선택 핸들러
  const handleVaccSelect = (vaccName: string) => {
    setVaccinationInput((prev) => ({ ...prev, key: vaccName }));
    setShowAutoCompleteVacc(false);
    setSelectedIndexVacc(-1);
    vaccinationValueInputRef.current?.focus();
  };

  const handleMedicationKeyDown = (
    e: React.KeyboardEvent<HTMLInputElement>
  ) => {
    if (showAutoComplete) {
      if (e.key === "ArrowDown") {
        e.preventDefault();
        setSelectedIndex((prev) =>
          Math.min(prev + 1, autoCompleteResults.length - 1)
        );
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        setSelectedIndex((prev) => Math.max(prev - 1, 0));
      } else if (e.key === "Enter") {
        e.preventDefault();
        // 엔터 입력 시 선택된 항목이 있으면 해당 항목 반영하고 skip 플래그 설정하여 API 재호출 방지
        setShowAutoComplete(false);
        setSelectedIndex(-1);
        setSkipMedicationAutoComplete(true);
        if (selectedIndex >= 0 && selectedIndex < autoCompleteResults.length) {
          handleDrugSelect(autoCompleteResults[selectedIndex]);
        } else {
          medicationValueInputRef.current?.focus();
        }
      } else if (e.key === "Escape") {
        setShowAutoComplete(false);
        setSelectedIndex(-1);
      }
    } else if (e.key === "Enter") {
      e.preventDefault();
      medicationValueInputRef.current?.focus();
    }
  };

  const handleExamKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (showAutoCompleteExam) {
      if (e.key === "ArrowDown") {
        e.preventDefault();
        setSelectedIndexExam((prev) =>
          Math.min(prev + 1, autoCompleteResultsExam.length - 1)
        );
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        setSelectedIndexExam((prev) => Math.max(prev - 1, 0));
      } else if (e.key === "Enter") {
        e.preventDefault();
        setShowAutoCompleteExam(false);
        setSelectedIndexExam(-1);
        setSkipExamAutoComplete(true);
        if (
          selectedIndexExam >= 0 &&
          selectedIndexExam < autoCompleteResultsExam.length
        ) {
          handleExamSelect(autoCompleteResultsExam[selectedIndexExam]);
        } else {
          examinationValueInputRef.current?.focus();
        }
      } else if (e.key === "Escape") {
        setShowAutoCompleteExam(false);
        setSelectedIndexExam(-1);
      }
    } else if (e.key === "Enter") {
      e.preventDefault();
      examinationValueInputRef.current?.focus();
    }
  };

  const handleVaccKeyDown = (e: React.KeyboardEvent<HTMLInputElement>) => {
    if (showAutoCompleteVacc) {
      if (e.key === "ArrowDown") {
        e.preventDefault();
        setSelectedIndexVacc((prev) =>
          Math.min(prev + 1, autoCompleteResultsVacc.length - 1)
        );
      } else if (e.key === "ArrowUp") {
        e.preventDefault();
        setSelectedIndexVacc((prev) => Math.max(prev - 1, 0));
      } else if (e.key === "Enter") {
        e.preventDefault();
        setShowAutoCompleteVacc(false);
        setSelectedIndexVacc(-1);
        setSkipVaccAutoComplete(true);
        if (
          selectedIndexVacc >= 0 &&
          selectedIndexVacc < autoCompleteResultsVacc.length
        ) {
          handleVaccSelect(autoCompleteResultsVacc[selectedIndexVacc]);
        } else {
          vaccinationValueInputRef.current?.focus();
        }
      } else if (e.key === "Escape") {
        setShowAutoCompleteVacc(false);
        setSelectedIndexVacc(-1);
      }
    } else if (e.key === "Enter") {
      e.preventDefault();
      vaccinationValueInputRef.current?.focus();
    }
  };

  const addPrescription = (type: TreatmentType) => {
    let inputState: InputState,
      setInputState: React.Dispatch<React.SetStateAction<InputState>>,
      listKey: keyof typeof prescriptions,
      keyInputRef: React.RefObject<HTMLInputElement | null>;

    if (type === TreatmentType.EXAMINATION) {
      [inputState, setInputState, listKey, keyInputRef] = [
        examinationInput,
        setExaminationInput,
        "examinations",
        examinationKeyInputRef,
      ];
    } else if (type === TreatmentType.MEDICATION) {
      [inputState, setInputState, listKey, keyInputRef] = [
        medicationInput,
        setMedicationInput,
        "medications",
        medicationKeyInputRef,
      ];
    } else if (type === TreatmentType.VACCINATION) {
      [inputState, setInputState, listKey, keyInputRef] = [
        vaccinationInput,
        setVaccinationInput,
        "vaccinations",
        vaccinationKeyInputRef,
      ];
    } else {
      return;
    }

    if (inputState.key.trim() && inputState.value.trim()) {
      const newPrescription = {
        key: inputState.key.trim(),
        value: inputState.value.trim(),
      };
      setPrescriptions((prev) => ({
        ...prev,
        [listKey]: [...prev[listKey], newPrescription as any],
      }));
      setInputState({ key: "", value: "" });
      if (type === TreatmentType.MEDICATION) {
        setShowAutoComplete(false);
        setSelectedIndex(-1);
      } else if (type === TreatmentType.EXAMINATION) {
        setShowAutoCompleteExam(false);
        setSelectedIndexExam(-1);
      } else if (type === TreatmentType.VACCINATION) {
        setShowAutoCompleteVacc(false);
        setSelectedIndexVacc(-1);
      }
      keyInputRef?.current?.focus();
    }
  };

  const removePrescription = (index: number, type: TreatmentType) => {
    let listKey: keyof typeof prescriptions;
    if (type === TreatmentType.EXAMINATION) listKey = "examinations";
    else if (type === TreatmentType.MEDICATION) listKey = "medications";
    else if (type === TreatmentType.VACCINATION) listKey = "vaccinations";
    else return;
    setPrescriptions((prev) => ({
      ...prev,
      [listKey]: prev[listKey].filter((_, i) => i !== index),
    }));
  };

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
    const handleLocalKeyDown = (
      e: React.KeyboardEvent<HTMLInputElement>,
      field: "key" | "value"
    ) => {
      if (e.key === "Enter") {
        e.preventDefault();
        if (field === "key") {
          valueInputRef?.current?.focus();
        } else {
          addPrescription(type);
        }
      }
    };

    const keyKeyDownHandler =
      type === TreatmentType.MEDICATION
        ? handleMedicationKeyDown
        : type === TreatmentType.EXAMINATION
        ? handleExamKeyDown
        : type === TreatmentType.VACCINATION
        ? handleVaccKeyDown
        : (e: React.KeyboardEvent<HTMLInputElement>) =>
            handleLocalKeyDown(e, "key");

    return (
      <div className="mb-4">
        <div
          className={`grid grid-cols-[auto_minmax(0,1fr)_minmax(0,1fr)_auto] gap-x-2 items-center w-full mb-2`}
        >
          <h4 className="font-bold text-sm text-gray-700 w-12 text-right pr-2">
            {title}
          </h4>
          <div className="relative">
            <div className="relative">
              <input
                ref={keyInputRef}
                type="text"
                value={inputState.key}
                onChange={(e) => {
                  setInputState((prev) => ({ ...prev, key: e.target.value }));
                  // onChange 시 skip 플래그 초기화
                  if (type === TreatmentType.MEDICATION)
                    setSkipMedicationAutoComplete(false);
                  else if (type === TreatmentType.EXAMINATION)
                    setSkipExamAutoComplete(false);
                  else if (type === TreatmentType.VACCINATION)
                    setSkipVaccAutoComplete(false);
                }}
                onKeyDown={keyKeyDownHandler}
                placeholder={keyPlaceholder}
                className="border p-2 text-sm rounded-md w-full"
                onFocus={() => {
                  if (
                    type === TreatmentType.MEDICATION &&
                    autoCompleteResults.length > 0
                  ) {
                    setShowAutoComplete(true);
                  }
                  if (
                    type === TreatmentType.EXAMINATION &&
                    autoCompleteResultsExam.length > 0
                  ) {
                    setShowAutoCompleteExam(true);
                  }
                  if (
                    type === TreatmentType.VACCINATION &&
                    autoCompleteResultsVacc.length > 0
                  ) {
                    setShowAutoCompleteVacc(true);
                  }
                }}
              />
              {type === TreatmentType.MEDICATION && isSearching && (
                <span className="absolute right-2 top-1/2 -translate-y-1/2">
                  <Loader className="w-4 h-4 animate-spin text-gray-400" />
                </span>
              )}
              {type === TreatmentType.MEDICATION &&
                !isSearching &&
                inputState.key.length > 0 &&
                !showAutoComplete && (
                  <span className="absolute right-2 top-1/2 -translate-y-1/2">
                    <Search className="w-4 h-4 text-gray-400" />
                  </span>
                )}
              {/* 검사 자동완성 드롭다운 */}
              {type === TreatmentType.EXAMINATION &&
                showAutoCompleteExam &&
                autoCompleteResultsExam.length > 0 && (
                  <div
                    ref={autoCompleteRefExam}
                    className="absolute z-10 mt-1 w-full bg-white border rounded-md shadow-lg max-h-40 overflow-y-auto text-xs"
                  >
                    {autoCompleteResultsExam.map((item, index) => (
                      <div
                        key={index}
                        className={`p-2 hover:bg-gray-100 cursor-pointer ${
                          selectedIndexExam === index
                            ? "bg-primary-50 text-primary-700 font-semibold"
                            : ""
                        }`}
                        onClick={() => handleExamSelect(item)}
                        onMouseEnter={() => setSelectedIndexExam(index)}
                      >
                        {item}
                      </div>
                    ))}
                  </div>
                )}
              {/* 접종 자동완성 드롭다운 */}
              {type === TreatmentType.VACCINATION &&
                showAutoCompleteVacc &&
                autoCompleteResultsVacc.length > 0 && (
                  <div
                    ref={autoCompleteRefVacc}
                    className="absolute z-10 mt-1 w-full bg-white border rounded-md shadow-lg max-h-40 overflow-y-auto text-xs"
                  >
                    {autoCompleteResultsVacc.map((item, index) => (
                      <div
                        key={index}
                        className={`p-2 hover:bg-gray-100 cursor-pointer ${
                          selectedIndexVacc === index
                            ? "bg-primary-50 text-primary-700 font-semibold"
                            : ""
                        }`}
                        onClick={() => handleVaccSelect(item)}
                        onMouseEnter={() => setSelectedIndexVacc(index)}
                      >
                        {item}
                      </div>
                    ))}
                  </div>
                )}
            </div>
          </div>
          <input
            ref={valueInputRef}
            type="text"
            value={inputState.value}
            onChange={(e) =>
              setInputState((prev) => ({ ...prev, value: e.target.value }))
            }
            onKeyDown={(e) => handleLocalKeyDown(e, "value")}
            placeholder={valuePlaceholder}
            className="border p-2 text-sm rounded-md w-full"
          />
          <button
            onClick={() => addPrescription(type)}
            className="p-2 text-gray-500 flex-shrink-0 rounded-md flex items-center justify-center hover:bg-gray-100"
          >
            <PlusCircle className="w-5 h-5" />
          </button>
        </div>
        <div className="ml-14 flex gap-1 flex-col w-auto max-h-[150px] overflow-y-auto">
          {list.length === 0 ? (
            <div className="text-center text-gray-400 text-xs py-2">
              추가된 {title} 항목이 없습니다.
            </div>
          ) : (
            list.map((item, index) => (
              <div
                key={`${type}-${index}`}
                className={`grid grid-cols-[minmax(0,1fr)_minmax(0,auto)_auto] gap-x-2 items-center py-1.5 px-2 ${bgColor} rounded-md mb-1`}
              >
                <span className="truncate text-xs font-medium" title={item.key}>
                  {item.key}
                </span>
                <span
                  className="truncate text-xs text-gray-700 text-right"
                  title={item.value}
                >
                  {item.value}
                </span>
                <button
                  onClick={() => removePrescription(index, type)}
                  className="text-red-500 hover:text-red-700 text-xs font-bold flex-shrink-0 w-5 h-5 flex items-center justify-center"
                >
                  <Trash2 className="w-4 h-4" />
                </button>
              </div>
            ))
          )}
        </div>
      </div>
    );
  };

  return (
    <div className="flex-1 w-full h-full flex flex-col">
      {renderSection(
        TreatmentType.EXAMINATION,
        "검사",
        examinationInput,
        setExaminationInput,
        prescriptions.examinations,
        "bg-blue-50",
        "검사항목 검색...",
        "결과",
        examinationKeyInputRef,
        examinationValueInputRef
      )}
      {renderSection(
        TreatmentType.MEDICATION,
        "약물",
        medicationInput,
        setMedicationInput,
        prescriptions.medications,
        "bg-green-50",
        "약품명 검색...",
        "용량/횟수",
        medicationKeyInputRef,
        medicationValueInputRef
      )}
      {renderSection(
        TreatmentType.VACCINATION,
        "접종",
        vaccinationInput,
        setVaccinationInput,
        prescriptions.vaccinations,
        "bg-yellow-50",
        "백신명 검색...",
        "접종일/차수 등",
        vaccinationKeyInputRef,
        vaccinationValueInputRef
      )}
    </div>
  );
};

export default PrescriptionSection;

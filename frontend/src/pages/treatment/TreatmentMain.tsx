import React, { useEffect, useState } from "react";
import TreatmentHeader from "@/pages/treatment/layout/TreatmentHeader";
import TreatmentSidebar from "@/pages/treatment/layout/TreatmentSidebar";
import RecordDetail from "@/pages/treatment/history/RecordDetail";
import TreatmentForm from "@/pages/treatment/form/TreatmentForm";
import { getTreatments } from "@/services/treatmentService";
import { ApiResponse, ResponseStatus } from "@/types";
import { Treatment, TreatmentState, TreatmentResponse, Doctor, BlockChainRecord } from '@/interfaces';
import { getDoctors } from '@/services/doctorService';
import TreatmentHistoryList from "@/pages/treatment/history/TreatmentHistoryList";

/**
 * @module TreatmentMain
 * @file TreatmentMain.tsx
 * @author haelim
 * @date 2025-03-26
 * @description 진단 페이지의 메인 컴포넌트입니다.  
 *              
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */


/**
 * 진단 페이지의 메인 컴포넌트 
 */
const TreatmentMain: React.FC = () => {
  const [treatments, setTreatments] = useState<Treatment[]>([]);
  const [selectedPetIndex, setSelectedPetIndex] = useState(0);
  const [isFormVisible, setIsFormVisible] = useState(false);
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  const [selectedRecordIndex, setSelectedRecordIndex] = useState(0);

  /**
   * 샘플 데이터 
   * @type {BlockChainRecord[]}
   */
  const records: BlockChainRecord[] = [
    {
      diagnosis: "감기",
      treatments: {
        examinations: [
          { key: "혈액 검사", value: "백혈구 수치 확인" },
          { key: "X-ray", value: "폐 상태 확인" }
        ],
        medications: [
          { key: "타이레놀", value: "3" },
          { key: "항생제", value: "2" }
        ],
        vaccinations: [
          { key: "독감 예방 접종", value: "1" }
        ]
      },
      doctorName: "김의사",
      notes: "휴식과 수분 섭취 권장",
      hospitalAddress: "hospital:0xexampleaddress",
      hospitalName: "서울 중앙 병원",
      createdAt: "2025.03.26",
      isDeleted: false,
      pictures: [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg"
      ]
    }
  ];

  /**
   * 병원에 등록된 의사를 조회합니다. 
   */
  useEffect(() => {
    const fetchData = async () => {
      const response: ApiResponse<Doctor[]> = await getDoctors();
      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setDoctors(response.data);
      }
    };
    fetchData();
  }, []);

  /**
   * 진료중인 동물 목록을 조회합니다. 
   */
  useEffect(() => {
    const fetchData = async () => {
      const response: ApiResponse<TreatmentResponse> = await getTreatments({ expired: "", petId: "", state: "" });
      if (response.status === ResponseStatus.SUCCESS && response.data?.treatments) {
        setTreatments(response.data.treatments);
      }
    };
    fetchData();
  }, []);

  /**
   * 동물 상태에 따라 화면에 보여줄 스타일을 반환합니다.
   * @param {TreatmentState} state - 진료 상태 enum
   * @returns {string} 진료 상태에 따른 tailwind class
   */
  const getStateBadgeColor = (state: TreatmentState): string => {
    switch (state) {
      case TreatmentState.IN_PROGRESS:
        return "text-primary-500 border border-primary-500";
      case TreatmentState.WAITING:
        return "text-secondary-300 border border-secondary-300";
      case TreatmentState.COMPLETED:
        return "bg-gray-200 text-gray-700 border border-gray-400";
      default:
        return "bg-gray-200 text-gray-700 border border-gray-400";
    }
  };

  /**
   * 현재 진료기록의 상태에 따라 필요한 CSS 요소를 반환합니다.
   * @param {TreatmentState} state - 진료 상태 enum
   * @returns {string} state 상태에 따른 CSS 태그 
   */
  const getStateColor = (state: TreatmentState): string => {
    switch (state) {
      case TreatmentState.IN_PROGRESS:
        return "bg-primary-50 border-primary-500 hover:bg-primary-100";
      case TreatmentState.WAITING:
        return "bg-secondary-50 border-secondary-300 hover:bg-secondary-100";
      case TreatmentState.COMPLETED:
        return "bg-gray-50 border border-gray-200";
      default:
        return "bg-gray-50 text-gray-700 border-gray-200";
    }
  };

  /**
   * 현재 진료기록의 상태에 따라 필요한 CSS 요소를 반환합니다.
   * @param {TreatmentState} state - 진료 상태 enum
   * @returns {string} state 상태에 따른 CSS 태그 
   */
  const handleSaveTreatment = (): void => {
    setIsFormVisible(true);
  };

  
  /**
   * 반료동물의 의료 기록 입력을 위한한 폼을 열고 닫고의 동작을 수행합니다. 
   */
  const onSelected = (): void => {
    setIsFormVisible((before) => !before);
  };

  return (
    <div className="w-full py-5 px-4 mx-auto sm:px-6 lg:px-8 flex">
      {/* 사이드바 */}
      <TreatmentSidebar
        treatments={treatments}
        getStateBadgeColor={getStateBadgeColor}
        getStateColor={getStateColor}
        selectedPetIndex={selectedPetIndex}
        setSelectedPetIndex={setSelectedPetIndex}
      />
      
      {/* 메인 */}
      <div className="flex flex-1 gap-5">
        <div className="flex flex-col flex-1">
          <TreatmentHeader
            treatment={treatments[selectedPetIndex] ?? null}
            getStateBadgeColor={getStateBadgeColor}
            isFormVisible={isFormVisible}
            onSelected={onSelected}
          />

          {isFormVisible ? (
            <TreatmentHistoryList records={records} setSelectedRecordIndex={setSelectedRecordIndex} />
          ) : (
            <TreatmentForm doctors={doctors} onSave={handleSaveTreatment} />
          )}
        </div>

        {isFormVisible && (<RecordDetail record={records[selectedRecordIndex]} />)}
      </div>
    </div>
  );
};

export default TreatmentMain;

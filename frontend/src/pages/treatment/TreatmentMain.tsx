import React, { useEffect, useState, useCallback } from "react";
import TreatmentHeader from "@/pages/treatment/layout/TreatmentHeader";
import TreatmentSidebar from "@/pages/treatment/layout/TreatmentSidebar";
import TreatmentForm from "@/pages/treatment/form/TreatmentForm";
import { getTreatments } from "@/services/treatmentService";
import { ApiResponse, ResponseStatus } from "@/types";
import {
  Treatment,
  TreatmentState,
  TreatmentResponse,
  Doctor,
} from "@/interfaces";
import { getDoctors } from "@/services/doctorService";
import TreatmentHistoryList from "@/pages/treatment/history/TreatmentHistoryList";
import { connectWallet } from "@/services/blockchainAuthService";

/**
 * @module TreatmentMain
 * @file TreatmentMain.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 진단 페이지의 메인 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         TreatmentForm에 onCancel 콜백 추가 및 UI 변경경
 * 2025-03-26        eunchang         MetaMask 확장프로그램 설치 URL
 */

/**
 * 진단 페이지의 메인 컴포넌트
 */
const TreatmentMain: React.FC = () => {
  const [treatments, setTreatments] = useState<Treatment[]>([]);
  const [blockchainPets, setBlockchainPets] = useState<Treatment[]>([]);
  const [allPets, setAllPets] = useState<Treatment[]>([]);
  const [selectedPetId, setSelectedPetId] = useState<string>('');
  const [isFormVisible, setIsFormVisible] = useState(true);
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  const [connectionError, setConnectionError] = useState<string | null>(null);
  
  // 선택된 반려동물 정보
  const selectedPet = allPets.find(pet => {
    if (pet.petDid) {
      return pet.petDid === selectedPetId;
    } else {
      return pet.id.toString() === selectedPetId;
    }
  });

  /**
   * 블록체인 네트워크 연결을 시도합니다.
   */
  useEffect(() => {
    const initializeBlockchain = async () => {
      try {
        await connectWallet();
        setConnectionError(null);
      } catch (error: any) {
        console.error("블록체인 연결 실패:", error);
        setConnectionError(error.message || "블록체인 연결에 실패했습니다.");
      }
    };

    initializeBlockchain();
  }, []);

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
      const response: ApiResponse<TreatmentResponse> = await getTreatments({
        expired: "",
        petId: "",
        state: "",
      });
      if (
        response.status === ResponseStatus.SUCCESS &&
        response.data?.treatments
      ) {
        setTreatments(response.data.treatments);
      }
    };
    fetchData();
  }, []);

  /**
   * API와 블록체인에서 가져온 반려동물 목록을 병합합니다.
   */
  useEffect(() => {
    setAllPets([...treatments, ...blockchainPets]);
  }, [treatments, blockchainPets]);

  /**
   * 블록체인에서 가져온 반려동물 목록을 처리합니다.
   */
  const handleBlockchainPetsLoad = useCallback((pets: Treatment[]) => {
    setBlockchainPets(pets);
  }, []);

  /**
   * 반려동물의 상태가 변경되었을 때 호출되는 함수입니다.
   */
  const handlePetStateChanged = useCallback((petId: string, newState: TreatmentState, isCancelled: boolean) => {
    // 블록체인 반려동물 목록 업데이트
    setBlockchainPets(prev => 
      prev.map(pet => 
        pet.petDid === petId 
          ? { ...pet, calculatedState: newState, isCancelled } 
          : pet
      )
    );
    
    // 선택된 반려동물이 취소된 경우 상태 업데이트
    if (selectedPetId === petId && isCancelled) {
      // 취소 후 필요한 추가 로직이 있다면 여기에 작성
      console.log('선택된 반려동물 취소됨:', petId);
    }
  }, [selectedPetId]);
  
  /**
   * 취소 처리가 완료된 후 호출되는 함수입니다.
   */
  const handleCancellationComplete = useCallback(() => {
    if (!selectedPet?.petDid) return;
    
    // 선택된 반려동물 상태를 취소로 변경
    handlePetStateChanged(selectedPet.petDid, TreatmentState.CANCELLED, true);
    
    // 추가 작업이 필요한 경우 여기에 작성
  }, [selectedPet, handlePetStateChanged]);

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
      case TreatmentState.CANCELLED:
        return "bg-red-200 text-red-700 border border-red-400";
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
      case TreatmentState.CANCELLED:
        return "bg-red-50 border border-red-200";
      default:
        return "bg-gray-50 text-gray-700 border-gray-200";
    }
  };

  /**
   * 현재 진료기록의 상태에 따라 필요한 CSS 요소를 반환합니다.
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

  // 연결 오류 표시
  if (connectionError) {
    return (
      <div className="flex items-center justify-center h-screen">
        <div className="bg-red-50 border border-red-200 rounded-lg p-6 max-w-md">
          <h2 className="text-xl font-bold text-red-700 mb-2">
            블록체인 연결 오류
          </h2>

          <p className="text-gray-700 mb-4">{connectionError}</p>

          <div className="mb-4 border-t border-gray-200 pt-3">
            <h3 className="font-bold text-gray-800 mb-2">연결 가이드</h3>
            <ul className="text-gray-700 list-disc pl-5 space-y-1 text-sm">
              <li>
                메타마스크{" "}
                <a
                  href="https://chromewebstore.google.com/detail/nkbihfbeogaeaoehlefnkodbefgpgknn?utm_source=item-share-cb"
                  target="_blank"
                  rel="noopener noreferrer"
                  className="text-blue-600 underline"
                >
                  확장프로그램
                </a>
                이 설치되어 있는지 확인하세요.
              </li>
              <li>메타마스크에 로그인이 되어 있는지 확인하세요.</li>
              <li>
                메타마스크에 다음 네트워크 정보를 추가했는지 확인하세요:
                <ul className="pl-4 mt-1 space-y-1 text-xs">
                  <li>네트워크 이름: SSAFY</li>
                  <li>RPC URL: https://rpc.ssafy-blockchain.com</li>
                  <li>체인 ID: 31221</li>
                  <li>통화 기호: ETH</li>
                </ul>
              </li>
              <li>
                네트워크에 연결했더라도 공유받지 않은 반려동물 정보는 보이지
                않습니다.
              </li>
              <li>
                테스트를 원할 경우 앱에서 메타마스크 계정으로 반려동물 정보를
                공유받으세요.
              </li>
            </ul>
          </div>

          <button
            className="px-4 py-2 bg-primary-500 text-white rounded-md"
            onClick={() => window.location.reload()}
          >
            다시 시도
          </button>
        </div>
      </div>
    );
  }

  return (
    <div className="w-full py-5 px-4 mx-auto sm:px-6 lg:px-8 flex">
      {/* 사이드바 */}
      <TreatmentSidebar
        treatments={treatments}
        getStateBadgeColor={getStateBadgeColor}
        getStateColor={getStateColor}
        selectedPetId={selectedPetId}
        setSelectedPetId={setSelectedPetId}
        onBlockchainPetsLoad={handleBlockchainPetsLoad}
        onStateChanged={handlePetStateChanged}
      />

      {/* 메인 */}
      <div className="flex flex-1">
        <div className="flex flex-col flex-1">
          <TreatmentHeader
            treatment={selectedPet}
            getStateBadgeColor={getStateBadgeColor}
            isFormVisible={isFormVisible}
            onSelected={onSelected}
            onCancelled={handleCancellationComplete}
          />

          {isFormVisible ? (
            <TreatmentHistoryList selectedPetDid={selectedPet?.petDid} />
          ) : (
            <TreatmentForm
              doctors={doctors}
              onSave={handleSaveTreatment}
              onCancel={() => setIsFormVisible(true)}
              petDID={selectedPet?.petDid || ""}
            />
          )}
        </div>
      </div>
    </div>
  );
};

export default TreatmentMain;

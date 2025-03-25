import React, { useEffect, useState } from "react";
import { Treatment, TreatmentState, TreatmentResponse } from "@/interfaces/treatment";
import TreatmentHeader from "@/pages/treatment/TreatmentHeader";
import TreatmentForm from "@/pages/treatment/TreatmentForm";
import TreatmentSidebar from "@/pages/treatment/TreatmentSidebar";
import TreatmentHistory from "@/pages/treatment/TreatmentHistory";
import { getTreatments } from "@/services/treatmentService";
import { ApiResponse, ResponseStatus } from "@/types";

const TreatmentMain: React.FC = () => {
  const [treatments, setTreatments] = useState<Treatment[]>([]);
  const [selectedPetIndex, setSelectedPetIndex] = useState(0);
  const [isFormVisible, setIsFormVisible] = useState(true);

  useEffect(() => {
    const fetchData = async () => {
      const response: ApiResponse<TreatmentResponse> = await getTreatments({ expired: false });
      if(response.status === ResponseStatus.SUCCESS && response.data ){
        setTreatments(response.data.treatments);
      }
    };

    fetchData();
  }, []);

  
  const getStateBadgeColor = (state: TreatmentState) => {
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

  const getStateColor = (state: TreatmentState) => {
    switch (state) {
      case TreatmentState.IN_PROGRESS:
        return "bg-primary-50 border-primary-500 hover:bg-primary-100";
      case TreatmentState.WAITING:
          return "bg-secondary-50 border-secondary-300 hover:bg-secondary-100";
      case TreatmentState.COMPLETED:
            return "bg-gray-50 border border-gray-400";
      default:
        return "bg-gray-50 text-gray-700 border border-gray-400";
    }
  };

  const toggleTreatmentForm = () => {
    setIsFormVisible((before) => !before);
  };

  const handleSaveTreatment = () => {
    // 저장 로직 추가 가능
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

      {/* 메인 진료 영역 */}
      <div className="flex-1 flex flex-col">
        <TreatmentHeader
          treatment={treatments[selectedPetIndex] ?? null}
          getStateBadgeColor={getStateBadgeColor}
          toggleTreatmentForm={toggleTreatmentForm}
        />
          
        {isFormVisible ? (
            <TreatmentForm onSave={handleSaveTreatment} />
        ) : (
              <></>
              // <TreatmentHistory treatments={treatments[selectedPetIndex].treatments} />
        )}
      
      </div>
    </div>
  );
};

export default TreatmentMain;

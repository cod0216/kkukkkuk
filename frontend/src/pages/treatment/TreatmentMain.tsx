import React, { useState } from 'react';
import { TreatmentState } from '@/interfaces/treatment';
import { normalizePets } from '@/interfaces/pet';

import TreatmentHeader from '@/pages/treatment/TreatmentHeader';
import TreatmentForm from '@/pages/treatment/TreatmentForm';
import TreatmentSidebar from '@/pages/treatment/TreatmentSidebar';
import TreatmentHistory from '@/pages/treatment/TreatmentHistory';

const TreatmentMain: React.FC = () => {
  const [selectedPetIndex, setSelectedPetIndex] = useState(0);
  const [isFormVisible, setIsFormVisible] = useState(true); 
  
  // 샘플 데이터
  const petData = [
    { 
      id: 1,
      name: "깡통", 
      breed: "고양이(코리안숏헤어)", 
      age: 10, 
      weight: 10, 
      gender: "수컷", 
      flagNeutered: true, 
      state: TreatmentState.IN_PROGRESS, 
      owner: "권해림", 
      phone: "010-1111-1111",
      treatments: [
        { disease: "구내염", date: "2025.03.22", hospital: "가나다 동물병원" },
        { disease: "피부염", date: "2025.03.15", hospital: "가나다 동물병원" }
      ]
    },
    { 
      id: 2,
      name: "몽이", 
      breed: "강아지(포메라니안)", 
      age: 5, 
      weight: 3, 
      gender: "암컷", 
      neutered: true, 
      state: TreatmentState.WAITING, 
      owner: "김철수", 
      phone: "010-2222-2222",
      treatments: [
        { disease: "치과 검진", date: "2025.03.20", hospital: "가나다 동물병원" }
      ]
    }
  ];
  
  const pets = normalizePets(petData);
  
  const getStateBadgeColor = (state: TreatmentState) => {
    switch (state) {
      case TreatmentState.IN_PROGRESS: return "text-primary-500 border border-primary-500";
      case TreatmentState.WAITING: return "text-secondary-300 border border-secondary-300";
      case TreatmentState.COMPLETED: return "bg-gray-200 text-gray-700 border border-gray-400";
      default: return "bg-gray-200 text-gray-700 border border-gray-400";
    }
  };
  
  const getStateColor = (state: TreatmentState) => {
    switch (state) {
      case TreatmentState.IN_PROGRESS: return "bg-primary-50  border-primary-500 hover:bg-primary-100";
      case TreatmentState.WAITING: return "bg-secondary-50  border-secondary-300 hover:bg-secondary-100 ";
      case TreatmentState.COMPLETED: return "bg-gray-50 border border-gray-400";
      default: return "bg-gray-50 text-gray-700 border border-gray-400";
    }
  };

  const toggleTreatmentForm = () => {
    setIsFormVisible((before) => !before)
  }

  const handleSaveTreatment = () => {
    
  };

  return (
    <div className="w-full py-5 px-4 mx-auto sm:px-6 lg:px-8 flex">
      {/* 사이드바 */}
      <TreatmentSidebar
        pets={pets} 
        getStateBadgeColor={getStateBadgeColor}
        getStateColor={getStateColor}
        selectedPetIndex={selectedPetIndex}
        setSelectedPetIndex={setSelectedPetIndex}    
      />

      {/* 메인 진료 영역 */}
      <div className="flex-1 flex flex-col">
        <TreatmentHeader 
          pet={pets[selectedPetIndex]} 
          getStateBadgeColor={getStateBadgeColor} 
          toggleTreatmentForm={toggleTreatmentForm}
        />

        {isFormVisible ? (
          <TreatmentForm onSave={handleSaveTreatment} />
        ) : (
          <TreatmentHistory treatments={pets[selectedPetIndex].treatments} />
        )}
      </div>
    </div>
  );
};

export default TreatmentMain;

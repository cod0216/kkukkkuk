import React from 'react';
import { FaPaw, FaStethoscope } from 'react-icons/fa';
import { Treatment , Gender, TreatmentState } from '@/interfaces';

interface TreatmentHeaderProps {
  treatment?: Treatment;
  getStateBadgeColor: (state: TreatmentState) => string;
  toggleTreatmentForm: () => void;
}

const TreatmentHeader: React.FC<TreatmentHeaderProps> = ({ treatment, getStateBadgeColor, toggleTreatmentForm }) => {
  return (
    <div className="bg-white p-5 rounded-lg border mb-6 flex">
      <div className="w-20 h-20 bg-gray-50 rounded-full flex items-center justify-center border border-gray-200">
        <FaPaw className="text-gray-400 text-3xl" />
      </div>


      <div className="flex-1 ml-6">
        <div className="flex justify-between">
          <div className="flex gap-3 items-center">
            <div className="text-xl font-bold text-gray-800">{treatment?.name}</div>
            {
              treatment && (<div className={`text-xs px-2 py-0.5 rounded-full ${getStateBadgeColor(treatment.state)}`}>
              {treatment?.state}
            </div>)
              
            }
          </div>
          <div className="flex gap-2 h-8">
            <button 
              onClick={() => toggleTreatmentForm()}
              className="bg-primary-500 hover:bg-primary-600 text-white text-xs font-medium px-3 py-1 rounded-md transition flex items-center gap-1">
              <FaStethoscope className="text-white" />
              <span>진료 시작</span>
            </button>
          </div>
        </div>
        <div className="text-gray-600 text-sm text-base mt-1">
          {treatment?.breedName}
        </div>
        <div className="flex justify-between">
          <div className="text-gray-500 text-sm mt-1">
            {treatment?.gender === Gender.MALE ? '수컷' : '암컷'}, 
            {treatment?.flagNeutering ? '중성화 완료' : '중성화 안함'} / 
            {treatment?.age}세 
          </div>
          <div className="mt-2 text-sm font-medium text-gray-600">
            {/* 보호자: {treatment.owner} · {pet.phone} */}
          </div>
        </div>
      </div>
    </div>
  );
};

export default TreatmentHeader;
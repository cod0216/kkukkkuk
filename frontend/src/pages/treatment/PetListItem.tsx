import React from 'react';
import { FaPaw } from 'react-icons/fa';
import { Treatment , Gender, TreatmentState } from '@/interfaces';

interface PetListItemProps {
  treatment: Treatment;
  isSelected: boolean;
  onSelect: () => void;
  getStateColor: (state: TreatmentState) => string;
  getStateBadgeColor: (state: TreatmentState) => string;
}

const PetListItem: React.FC<PetListItemProps> = ({
  treatment, isSelected, onSelect, getStateColor, getStateBadgeColor }) => {
  return (
    <div
      className={`flex flex-col gap-1 p-3 rounded-lg transition-all duration-200 cursor-pointer
        ${isSelected ? 'outline-primary-500' : ''} 
        ${getStateColor(treatment.state)}`}
      onClick={onSelect}
    >
      <div className="flex gap-2">
        <div className="flex items-center flex-1 justify-between">
           <div className="flex items-baseline gap-2">
              <FaPaw className="h-3 w-3 text-gray-500" />
              <div className="font-bold text-gray-900 text-nowrap">{treatment.name}</div>
              <div className="text-xs text-gray-600">{treatment.breedName}</div>
          </div>
          <div className={`h-4 flex items-center text-xs px-2 rounded-full text-nowrap ${getStateBadgeColor(treatment.state)}`}>
            {treatment.state}
          </div>
        </div>
      </div>
      <div className="text-xs text-gray-600">
        {treatment.age}세, {treatment.gender === Gender.MALE ? '수컷' : '암컷'}
        {treatment.flagNeutering ? ', 중성화' : ''}
      </div>
      <div className="text-xs text-gray-600 mt-1">
        {/* {pet.owner} · {pet.phone} */}
      </div>
    </div>
  );
};

export default PetListItem;
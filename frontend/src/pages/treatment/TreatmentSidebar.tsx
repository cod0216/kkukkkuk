
import React, { useState } from 'react';
import { FaSearch } from 'react-icons/fa';
import PetListItem from '@/pages/treatment/PetListItem';
import { TreatmentState } from '@/interfaces/treatment';
import { Pet } from '@/interfaces/pet';

interface SidebarProps {
    pets: Pet[];
    selectedPetIndex : number;
    setSelectedPetIndex: (index : number) => void
    getStateBadgeColor: (state: TreatmentState) => string;
    getStateColor: (state: TreatmentState) => string;
}

const TreatmentSidebar: React.FC<SidebarProps> = ({
    pets,
    selectedPetIndex,
    setSelectedPetIndex,
    getStateBadgeColor,
    getStateColor,
}) => {

      const [searchTerm, setSearchTerm] = useState('');
      const [filters, setFilters] = useState({
        dateRange: { start: '', end: '' },
        state: TreatmentState.NONE,
      });
    
  return (
    <div className="w-80 bg-white rounded-lg border p-4 mr-6">
        <div className="mb-6">
            {/* 검색 */}
            <div className="flex items-center gap-2 mb-3">
            <FaSearch className="text-gray-400" />
            <input
              className="text-xs p-1 bg-gray-50 border rounded-md flex-1 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
              type="search"
              placeholder="환자 검색"
              value={searchTerm}
              onChange={(e) => setSearchTerm(e.target.value)}
            />
            </div>
            
            {/* 날짜 필터링 */}
            <div className="flex items-center gap-2 mb-3">
                <input
                type="date"
                value={filters.dateRange.start}
                onChange={(e) => setFilters({ 
                    ...filters, 
                    dateRange: { ...filters.dateRange, start: e.target.value } 
                })}
                className="text-xs py-1 px-2 bg-gray-50 border rounded-md flex-1"
                />
                <input
                type="date"
                value={filters.dateRange.end}
                onChange={(e) => setFilters({ 
                    ...filters, 
                    dateRange: { ...filters.dateRange, end: e.target.value } 
                })}
                className="text-xs py-1 px-2 bg-gray-50 border rounded-md flex-1"
                />
            </div>

            {/* 진료중 필터링 */}
            <div className="flex gap-1">
                <div className="flex gap-2 text-xs h-6">
                    <select
                        className="bg-gray-50 w-full px-1 border rounded-md"
                        value={filters.state}
                        onChange={(e) => setFilters({ 
                            ...filters, 
                            state: e.target.value as TreatmentState 
                        })}
                        >
                        {Object.values(TreatmentState).map((state) => (
                            <option key={state} value={state}>{state}</option>
                        ))}
                    </select>

                    <select
                        className="bg-gray-50 w-full px-1 border rounded-md"
                        value={filters.state}
                        onChange={(e) => setFilters({ 
                            ...filters, 
                            state: e.target.value as TreatmentState 
                        })}
                        >
                        {Object.values(TreatmentState).map((state) => (
                            <option key={state} value={state}>{state}</option>
                        ))}
                    </select>
                </div>
            </div>
        </div>

        <h2 className="font-semibold text-gray-700 mb-3">목록</h2>

        {/* 동물 목록 List */}
        <div className="flex flex-col gap-3 overflow-y-auto max-h-[calc(100vh-280px)]">
          {pets.map((pet, index) => (
            <PetListItem
              key={pet.id}
              pet={pet}
              isSelected={selectedPetIndex === index}
              onSelect={() => setSelectedPetIndex(index)}
              getStateColor={getStateColor}
              getStateBadgeColor={getStateBadgeColor}
            />
          ))}
        </div>
    </div>
  );
};

export default TreatmentSidebar;


import React from 'react';
import { useAppSelector } from '../redux/store';
import PetList from '../components/pet/PetList';
import { selectSelectedPet } from '../redux/slices/petSlice';

const PetManagement: React.FC = () => {
  const selectedPet = useAppSelector(selectSelectedPet);

  return (
    <div className="flex flex-col min-h-screen bg-gray-50 dark:bg-gray-900">
      <div className="container mx-auto px-4 py-6">
        <div className="grid grid-cols-1 md:grid-cols-3 gap-6">
          {/* 반려동물 목록 (왼쪽) */}
          <div className="h-[calc(100vh-8rem)] md:col-span-1">
            <PetList />
          </div>

          {/* 선택된 반려동물 정보 및 작업 영역 (오른쪽) */}
          <div className="h-[calc(100vh-8rem)] bg-white dark:bg-gray-800 md:col-span-2 rounded-lg shadow-sm">
            {selectedPet ? (
              <div className="p-6">
                <h2 className="text-2xl font-bold mb-4 text-gray-800 dark:text-white">
                  {selectedPet.name}
                </h2>
                
                <div className="grid grid-cols-1 md:grid-cols-2 gap-4 mb-6">
                  <div className="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg">
                    <h3 className="text-lg font-semibold mb-2 text-gray-700 dark:text-gray-200">반려동물 정보</h3>
                    <div className="space-y-2">
                      <p className="text-sm text-gray-600 dark:text-gray-300">
                        <span className="font-medium">품종:</span> {selectedPet.breed}
                      </p>
                      <p className="text-sm text-gray-600 dark:text-gray-300">
                        <span className="font-medium">성별:</span> {selectedPet.gender === 'male' ? '수컷' : '암컷'}
                      </p>
                      <p className="text-sm text-gray-600 dark:text-gray-300">
                        <span className="font-medium">중성화:</span> {selectedPet.flagNeutering ? '예' : '아니오'}
                      </p>
                      <p className="text-sm text-gray-600 dark:text-gray-300">
                        <span className="font-medium">나이:</span> {selectedPet.age || '정보 없음'}
                      </p>
                      <p className="text-sm text-gray-600 dark:text-gray-300">
                        <span className="font-medium">보호자:</span> {selectedPet.guardianName}
                      </p>
                      <p className="text-sm text-gray-600 dark:text-gray-300">
                        <span className="font-medium">생년월일:</span> {new Date(selectedPet.registeredDate).toLocaleDateString()}
                      </p>
                      <p className="text-sm text-gray-600 dark:text-gray-300">
                        <span className="font-medium">DID:</span> {selectedPet.did || '정보 없음'}
                      </p>
                    </div>
                  </div>
                  
                  <div className="bg-gray-50 dark:bg-gray-700 p-4 rounded-lg">
                    <h3 className="text-lg font-semibold mb-2 text-gray-700 dark:text-gray-200">진료 상태</h3>
                    <div className="space-y-2">
                      <div className={`px-3 py-1.5 rounded-full text-sm inline-flex items-center 
                        ${selectedPet.treatmentStatus === 'waiting' ? 'bg-yellow-100 text-yellow-800 dark:bg-yellow-900 dark:text-yellow-300' : 
                          selectedPet.treatmentStatus === 'inProgress' ? 'bg-blue-100 text-blue-800 dark:bg-blue-900 dark:text-blue-300' : 
                          'bg-green-100 text-green-800 dark:bg-green-900 dark:text-green-300'}`}
                      >
                        {selectedPet.treatmentStatus === 'waiting' ? '진료대기중' : 
                          selectedPet.treatmentStatus === 'inProgress' ? '진료중' : '진료완료'}
                      </div>
                    </div>
                  </div>
                </div>
                
                {/* 진료 기록 및 작업 영역 (향후 개발) */}
                <div className="border-t border-gray-200 dark:border-gray-700 pt-6 mt-6">
                  <h3 className="text-lg font-semibold mb-4 text-gray-700 dark:text-gray-200">진료 기록</h3>
                  <div className="text-center py-8 text-gray-500 dark:text-gray-400">
                    <p>이 영역은 향후 진료 기록 기능이 구현될 예정입니다.</p>
                  </div>
                </div>
              </div>
            ) : (
              <div className="flex items-center justify-center h-full">
                <div className="text-center p-6">
                  <h3 className="text-lg font-medium text-gray-500 dark:text-gray-400">
                    왼쪽 목록에서 반려동물을 선택해주세요.
                  </h3>
                </div>
              </div>
            )}
          </div>
        </div>
      </div>
    </div>
  );
};

export default PetManagement; 
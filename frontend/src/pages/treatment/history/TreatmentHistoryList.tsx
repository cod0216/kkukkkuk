import React, { useState, useEffect } from 'react';
import RecordItem from '@/pages/treatment/history/RecordItem';
import RecordDetail from '@/pages/treatment/history/RecordDetail';
import { BlockChainRecord } from '@/interfaces';
import { getHospitalPetsWithRecords } from '@/services/treatmentService';
import { getAccountAddress, getContractAddresses } from '@/services/blockchainAuthService';

/**
 * @module TreatmentHistoryList
 * @file TreatmentHistoryList.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 반려동물 의료 기록의 목록을 조회하는 UI 컴포넌트 
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         블록체인 서비스 연동
 */

/**
 * TreatmentHistoryList 컴포넌트의 Props 타입 정의
 * @param setSelectedRecordIndex Detail 을 보여줄 의료 기록의 index 
 * @param selectedPetDid 상위 컴포넌트에서 선택된 반려동물의 DID
 */
interface TreatmentHistoryListProps {
  setSelectedRecordIndex?: (idx: number) => void;
  selectedPetDid?: string; // 상위 컴포넌트에서 선택된 반려동물 DID
}

/**
 * 병원이 접근 가능한 반려동물 정보 인터페이스
 */
interface HospitalPet {
  petDID: string;
  name: string;
  birth?: string;
  gender?: string;
  breed?: string;
  records: BlockChainRecord[];
}

/**
 * 반려동물 의료 기록의 목록을 조회하는 UI 컴포넌트 
*/
const TreatmentHistoryList: React.FC<TreatmentHistoryListProps> = ({ 
  setSelectedRecordIndex = () => {},
  selectedPetDid
}) => {
  const [_selectedPetIndex, setSelectedPetIndex] = useState<number | null>(null);
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [hospitalPets, setHospitalPets] = useState<HospitalPet[]>([]);
  const [blockchainRecords, setBlockchainRecords] = useState<BlockChainRecord[]>([]);
  const [currentUserAddress, setCurrentUserAddress] = useState<string | null>(null);
  const [selectedRecordIndex, setSelectedRecordIndexLocal] = useState<number>(0);
  const [didRegistryAddress, setDidRegistryAddress] = useState<string>('');
  
  // 선택된 기록
  const selectedRecord = blockchainRecords.length > 0 ? blockchainRecords[selectedRecordIndex] : null;
  
  // 컨트랙트 주소 가져오기
  useEffect(() => {
    try {
      const addresses = getContractAddresses();
      if (addresses && addresses.didRegistry) {
        setDidRegistryAddress(addresses.didRegistry);
      } else {
        console.warn('DID 레지스트리 주소를 가져올 수 없습니다. 기본값을 사용합니다.');
      }
    } catch (error) {
      console.error('컨트랙트 주소 가져오기 오류:', error);
    }
  }, []);
  
  // MetaMask 계정 정보 가져오기
  useEffect(() => {
    const fetchUserAddress = async () => {
      const address = await getAccountAddress();
      setCurrentUserAddress(address);
    };
    
    fetchUserAddress();
  }, []);
  
  // 병원이 접근 가능한 반려동물 목록 조회
  useEffect(() => {
    // 계정 정보와 컨트랙트 주소가 준비되면 반려동물 목록 조회
    if (currentUserAddress && didRegistryAddress) {
      fetchHospitalPets();
    }
  }, [currentUserAddress, didRegistryAddress, selectedPetDid]);
  
  // 상위 컴포넌트에서 선택된 반려동물이 변경될 때 해당 반려동물의 의료 기록을 불러옵니다
  useEffect(() => {
    if (selectedPetDid && hospitalPets.length > 0) {
      // 반려동물 DID로 인덱스 찾기
      const petIndex = hospitalPets.findIndex(pet => pet.petDID === selectedPetDid);
      
      if (petIndex !== -1) {
        // 해당 반려동물 선택 및 의료 기록 표시
        setSelectedPetIndex(petIndex);
        setBlockchainRecords(hospitalPets[petIndex].records);
        
        // 의료 기록이 있으면 첫 번째 기록 선택
        if (hospitalPets[petIndex].records.length > 0) {
          setSelectedRecordIndexLocal(0);
          setSelectedRecordIndex(0);
        } else {
          setSelectedRecordIndexLocal(-1);
          setSelectedRecordIndex(-1);
        }
      }
    }
  }, [selectedPetDid, hospitalPets, setSelectedRecordIndex]);
  
  const fetchHospitalPets = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await getHospitalPetsWithRecords(didRegistryAddress);
      
      if (response.success) {
        setHospitalPets(response.pets);
        
        // selectedPetDid가 없을 때만 첫 번째 반려동물을 선택
        if (!selectedPetDid && response.pets.length > 0) {
          setSelectedPetIndex(0);
          setBlockchainRecords(response.pets[0].records);
          
          // 첫 번째 기록 선택
          if (response.pets[0].records.length > 0) {
            setSelectedRecordIndexLocal(0);
            setSelectedRecordIndex(0);
          }
        }
      } else {
        setError(response.error || '반려동물 목록을 불러오는데 실패했습니다.');
        setHospitalPets([]);
      }
    } catch (err: any) {
      setError(err.message || '반려동물 목록을 불러오는 중 오류가 발생했습니다.');
      setHospitalPets([]);
    } finally {
      setLoading(false);
    }
  };
  
  // 기록 선택 핸들러
  const handleRecordSelect = (index: number) => {
    setSelectedRecordIndexLocal(index);
    setSelectedRecordIndex(index);
  };

  return (
    <div className="flex flex-col md:flex-row flex-1 h-full gap-5">
      <div className="flex flex-col flex-1 h-full">
        <div className="flex-1 flex flex-col bg-white border border-gray-200 rounded-md h-full max-h-full overflow-y-auto">
          <div className="flex justify-between">
            <h3 className="font-bold text-gray-800 m-1 p-3">반려동물 진료 기록</h3>
          </div>
          
          {/* 반려동물 선택 UI */}
          <div className="p-3 border-b flex items-center justify-between">
            {blockchainRecords.length > 0 && (
              <div className="text-xs text-gray-500">
                총 {blockchainRecords.length}개의 진료기록
              </div>
            )}
          </div>
          
          {/* 로딩 상태 표시 */}
          {loading && (
            <div className="p-4 text-center text-gray-500">
              진료 기록을 불러오는 중...
            </div>
          )}
          
          {/* 오류 상태 표시 */}
          {error && (
            <div className="p-4 text-center text-red-500">
              {error}
            </div>
          )}
          
          {/* 데이터가 없는 경우 */}
          {!loading && !error && blockchainRecords.length === 0 && (
            <div className="p-4 text-center text-gray-500">
              진료 기록이 없습니다.
            </div>
          )}
          
          {/* 의료 기록 목록 */}
          {!loading && !error && blockchainRecords.length > 0 && (
            <div className="overflow-y-auto">
              <RecordItem 
                records={blockchainRecords}
                onRecordSelect={handleRecordSelect}
              />
            </div>
          )}
        </div>
      </div>
      
      {/* 모바일에서만 표시되는 상세 정보 */}
      {selectedRecord && (
        <div className="md:hidden mt-4">
          <RecordDetail record={selectedRecord} />
        </div>
      )}
      
      {/* 데스크톱에서는 부모 컴포넌트에서 RecordDetail을 관리 */}
      {selectedRecord && (
        <div className="hidden md:block max-w-sm">
          <RecordDetail record={selectedRecord} />
        </div>
      )}
    </div>
  );
};

export default TreatmentHistoryList;

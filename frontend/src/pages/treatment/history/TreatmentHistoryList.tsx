import React, { useState, useEffect, forwardRef, useImperativeHandle } from 'react';
import RecordItem from '@/pages/treatment/history/RecordItem';
import RecordDetail from '@/pages/treatment/history/RecordDetail';
import RecordEditForm from '@/pages/treatment/form/RecordEditForm';
import { BlockChainRecord } from '@/interfaces';
import { getHospitalPetsWithRecords, updateBlockchainTreatment, getRecordChanges } from '@/services/treatmentService';
import { getAccountAddress, getContractAddresses } from '@/services/blockchainAuthService';
import { getDoctors } from '@/services/doctorService';
import { Doctor } from '@/interfaces';
import { ResponseStatus } from '@/types';

/**
 * 정렬 기준 타입
 */
type SortField = 'timestamp' | 'diagnosis' | 'hospitalName' | 'doctorName';

/**
 * 정렬 방향 타입
 */
type SortDirection = 'asc' | 'desc';

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
 * 2025-04-01        assistant        인덱스 기반 선택에서 ID 기반 선택으로 변경
 * 2025-04-02        assistant        정렬 기능 추가
 */

/**
 * TreatmentHistoryList 컴포넌트의 Props 타입 정의
 * @param setSelectedRecordId Detail 을 보여줄 의료 기록의 ID
 * @param selectedPetDid 상위 컴포넌트에서 선택된 반려동물의 DID
 */
interface TreatmentHistoryListProps {
  setSelectedRecordId?: (id: string) => void;
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
 * 외부에서 접근 가능한 함수들의 타입 정의
 */
export interface TreatmentHistoryListRef {
  refreshRecords: () => Promise<void>;
}

/**
 * 반려동물 의료 기록의 목록을 조회하는 UI 컴포넌트 
*/
const TreatmentHistoryList = forwardRef<TreatmentHistoryListRef, TreatmentHistoryListProps>(({ 
  setSelectedRecordId: parentSetSelectedRecordId = () => {},
  selectedPetDid
}, ref) => {
  const [loading, setLoading] = useState<boolean>(true);
  const [error, setError] = useState<string | null>(null);
  const [hospitalPets, setHospitalPets] = useState<HospitalPet[]>([]);
  const [blockchainRecords, setBlockchainRecords] = useState<BlockChainRecord[]>([]);
  const [currentUserAddress, setCurrentUserAddress] = useState<string | null>(null);
  const [didRegistryAddress, setDidRegistryAddress] = useState<string>('');
  const [selectedRecordId, setSelectedRecordId] = useState<string>('');
  const [sortField, setSortField] = useState<SortField>('timestamp');
  const [sortDirection, setSortDirection] = useState<SortDirection>('desc');
  
  // 수정 모드 상태
  const [editingRecord, setEditingRecord] = useState<BlockChainRecord | null>(null);
  const [isEditSuccess, setIsEditSuccess] = useState<boolean>(false);
  const [editError, setEditError] = useState<string | null>(null);
  
  // 의사 목록
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  
  // 정렬 방향 토글 핸들러
  const toggleSort = (field: SortField) => {
    if (sortField === field) {
      // 같은 필드를 다시 클릭하면 정렬 방향만 전환
      setSortDirection(prev => prev === 'asc' ? 'desc' : 'asc');
    } else {
      // 다른 필드를 클릭하면 해당 필드를 기준으로 기본 내림차순 정렬(최신순)
      setSortField(field);
      // timestamp는 기본이 내림차순(최신순), 나머지는 기본이 오름차순
      setSortDirection(field === 'timestamp' ? 'desc' : 'asc');
    }
  };
  
  // 정렬된 의료 기록 목록 계산
  const sortedRecords = React.useMemo(() => {
    // 취소된 진료 기록(진단명에 CANCELED 포함) 필터링
    const filteredRecords = blockchainRecords.filter(record => 
      !record.diagnosis || !record.diagnosis.includes('CANCELED')
    );
    
    // 현재 선택된 기록이 필터링으로 제거된 경우, 첫 번째 기록 선택
    if (selectedRecordId && filteredRecords.length > 0) {
      const recordExists = filteredRecords.some(record => record.id === selectedRecordId);
      if (!recordExists) {
        const firstRecordId = filteredRecords[0].id;
        if (firstRecordId) {
          setTimeout(() => setSelectedRecordId(firstRecordId), 0);
        }
      }
    }
    
    return [...filteredRecords].sort((a, b) => {
      let compared = 0;
      
      switch (sortField) {
        case 'timestamp':
          compared = a.timestamp - b.timestamp;
          break;
        case 'diagnosis':
          compared = a.diagnosis.localeCompare(b.diagnosis);
          break;
        case 'hospitalName':
          compared = a.hospitalName.localeCompare(b.hospitalName);
          break;
        case 'doctorName':
          compared = a.doctorName.localeCompare(b.doctorName);
          break;
        default:
          compared = 0;
      }
      
      // 정렬 방향에 따라 비교 결과 반전
      return sortDirection === 'asc' ? compared : -compared;
    });
  }, [blockchainRecords, sortField, sortDirection, selectedRecordId]);
  
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
  
  // 의사 목록 불러오기
  useEffect(() => {
    const fetchDoctors = async () => {
      try {
        const response = await getDoctors();
        if (response.status === ResponseStatus.SUCCESS && response.data) {
          setDoctors(response.data);
        }
      } catch (error) {
        console.error('의사 목록을 불러오는 중 오류가 발생했습니다:', error);
      }
    };
    
    fetchDoctors();
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
        const petRecords = hospitalPets[petIndex].records;
        // 해당 반려동물의 의료 기록 표시
        setBlockchainRecords(petRecords);
        
        // 의료 기록이 있는 경우
        if (petRecords.length > 0) {
          // 현재 선택된 id가 새 레코드 목록에 없는 경우에만 첫 번째 레코드 선택
          const recordExists = selectedRecordId && petRecords.some(record => record.id === selectedRecordId);
          if (!recordExists) {
            const firstRecordId = petRecords[0].id;
            if (firstRecordId) {
              setSelectedRecordId(firstRecordId);
            }
          }
        } else {
          // 레코드가 없는 경우 선택 초기화
          setSelectedRecordId('');
        }
      }
    }
  }, [selectedPetDid, hospitalPets, selectedRecordId]);
  
  // 선택된 id가 변경될 때만 상위 컴포넌트에 알림
  useEffect(() => {
    // 유효한 id인 경우에만 업데이트
    if (selectedRecordId && blockchainRecords.some(record => record.id === selectedRecordId)) {
      parentSetSelectedRecordId(selectedRecordId);
    }
  }, [selectedRecordId, blockchainRecords, parentSetSelectedRecordId]);
  
  const fetchHospitalPets = async () => {
    setLoading(true);
    setError(null);
    
    try {
      const response = await getHospitalPetsWithRecords(didRegistryAddress);
      
      if (response.success) {
        setHospitalPets(response.pets);
        
        // selectedPetDid가 없을 때만 첫 번째 반려동물을 선택
        if (!selectedPetDid && response.pets.length > 0) {
          // 기록 설정
          const firstPetRecords = response.pets[0].records;
          setBlockchainRecords(firstPetRecords);
          
          // 첫 번째 기록 선택 - 최초 로드 시에만 실행되므로 여기서는 무조건 첫 번째 선택
          if (firstPetRecords.length > 0 && firstPetRecords[0].id) {
            setSelectedRecordId(firstPetRecords[0].id);
            // 상위 컴포넌트에 알림은 selectedRecordId가 변경될 때 useEffect에서 처리
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
  const handleRecordSelect = (id: string) => {
    if (id && blockchainRecords.some(record => record.id === id)) {
      setSelectedRecordId(id);
      // 상위 컴포넌트 알림은 useEffect에서 처리됨
    }
  };
  
  // 기록 수정 모드 핸들러
  const handleEditRecord = (record: BlockChainRecord) => {
    setEditingRecord(record);
    setIsEditSuccess(false);
    setEditError(null);
  };
  
  // 수정 취소 핸들러
  const handleCancelEdit = () => {
    setEditingRecord(null);
    setIsEditSuccess(false);
    setEditError(null);
  };
  
  // 수정 저장 핸들러
  const handleSaveEdit = async (updatedRecord: BlockChainRecord, changes: string[] = []) => {
    try {
      setIsEditSuccess(false);
      setEditError(null);
      
      // 현재 선택된 반려동물 정보 찾기
      const selectedPet = hospitalPets.find(pet => pet.records.some(record => record.id === updatedRecord.id));
      
      if (!selectedPet) {
        throw new Error('선택된 반려동물 정보를 찾을 수 없습니다.');
      }
      
      // petDid를 현재 선택된 반려동물의 petDID로 업데이트
      updatedRecord.petDid = selectedPet.petDID;
      
      if (!updatedRecord.petDid) {
        throw new Error('반려동물 정보가 없습니다.');
      }
      
      // 원본 record 찾기
      const originalRecord = blockchainRecords.find(record => record.id === updatedRecord.id);
      if (!originalRecord) {
        throw new Error('원본 기록을 찾을 수 없습니다.');
      }
      
      // 변경 사항 확인 (이미 RecordEditForm에서 확인했지만 한 번 더 확인)
      const detectedChanges = changes.length > 0 ? changes : getRecordChanges(originalRecord, updatedRecord);
      if (detectedChanges.length === 0) {
        setEditError('변경된 내용이 없습니다. 적어도 하나 이상의 필드를 수정해주세요.');
        return;
      }
      
      console.log('감지된 변경 사항:', detectedChanges);
      
      // 블록체인에 업데이트 요청
      const result = await updateBlockchainTreatment(
        updatedRecord.petDid,
        updatedRecord,
        detectedChanges
      );
      
      if (result.success) {
        setIsEditSuccess(true);
        setEditingRecord(null);
        
        // 새 레코드 ID가 있으면 선택
        if (result.newRecordId) {
          // 기록 다시 불러오기 후 새 레코드 선택
          await fetchHospitalPets();
          setTimeout(() => setSelectedRecordId(result.newRecordId || ''), 500);
        } else {
          // 기록 다시 불러오기
          await fetchHospitalPets();
        }
      } else {
        setEditError(result.error || '저장 중 오류가 발생했습니다.');
      }
    } catch (error: any) {
      setEditError(error.message || '저장 중 오류가 발생했습니다.');
    }
  };

  // 외부에서 호출 가능한 함수들 노출
  useImperativeHandle(ref, () => ({
    // 의료 기록 새로고침
    refreshRecords: async () => {
      await fetchHospitalPets();
    }
  }));

  return (
    <div className="flex flex-col md:flex-row flex-1 h-full gap-5">
      {/* 좌측: 의료 기록 목록 */}
      <div className="flex flex-col flex-1 h-full">
        <div className="flex-1 flex flex-col bg-white border border-gray-200 rounded-md h-full">
          {/* 헤더 및 정보 행 (고정 높이) */}
          <div className="flex-shrink-0">
            <div className="flex justify-between">
              <h3 className="font-bold text-gray-800 m-1 p-3">반려동물 진료 기록</h3>
            </div>
            
            {/* 반려동물 선택 UI */}
            {sortedRecords.length > 0 && (
              <div className="p-3 border-b flex items-center justify-between">
                <div className="text-xs text-gray-500">
                  총 {sortedRecords.length}개의 진료기록
                </div>
              </div>
            )}
            
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
            
            {/* 데이터가 없는 경우 - 실제 기록이 없거나 모두 취소된 경우 동일 메시지 표시 */}
            {!loading && !error && (blockchainRecords.length === 0 || sortedRecords.length === 0) && (
              <div className="p-4 text-center text-gray-500">
                진료 기록이 없습니다.
              </div>
            )}
          </div>
          
          {/* 의료 기록 목록 (스크롤 영역) */}
          {!loading && !error && sortedRecords.length > 0 && (
            <div className="flex-1 overflow-y-auto">
              <RecordItem 
                records={sortedRecords}
                onRecordSelect={handleRecordSelect}
                selectedRecordId={selectedRecordId}
                onSort={toggleSort}
                sortField={sortField}
                sortDirection={sortDirection}
              />
            </div>
          )}
        </div>
      </div>
      
      {/* 모바일에서만 표시되는 상세 정보 */}
      {selectedRecordId && (
        <div className="md:hidden mt-4 h-[500px]">
          {(() => {
            const record = sortedRecords.find(record => record.id === selectedRecordId) ||
                           blockchainRecords.find(record => record.id === selectedRecordId);
            
            // 기록이 없거나 취소된 기록(CANCELED)인 경우 표시하지 않음
            if (!record || record.diagnosis?.includes('CANCELED')) {
              return null;
            }
            
            // 수정 모드인 경우 수정 폼 표시
            if (editingRecord && editingRecord.id === record.id) {
              return (
                <RecordEditForm 
                  record={editingRecord}
                  onSave={async (updatedRecord, changes) => {
                    // 여기서 원본 레코드와 수정된 레코드를 비교하여 변경 사항을 감지하고 전달
                    await handleSaveEdit(updatedRecord, changes);
                  }}
                  onCancel={handleCancelEdit}
                  doctors={doctors}
                />
              );
            }
            
            // 상세 정보 표시
            return (
              <RecordDetail 
                key={`mobile-detail-${selectedRecordId}`} 
                record={record}
                onEditRecord={handleEditRecord}
                blockchainRecords={blockchainRecords}
              />
            );
          })()}
        </div>
      )}
      
      {/* 데스크톱에서는 부모 컴포넌트에서 RecordDetail을 관리 */}
      {selectedRecordId && (
        <div className="hidden md:block max-w-sm flex-shrink-0 h-[calc(100vh-208px)]">
          {(() => {
            const record = sortedRecords.find(record => record.id === selectedRecordId) ||
                           blockchainRecords.find(record => record.id === selectedRecordId);
            
            // 기록이 없거나 취소된 기록(CANCELED)인 경우 표시하지 않음
            if (!record || record.diagnosis?.includes('CANCELED')) {
              return null;
            }
            
            // 수정 모드인 경우 수정 폼 표시
            if (editingRecord && editingRecord.id === record.id) {
              return (
                <RecordEditForm 
                  record={editingRecord}
                  onSave={async (updatedRecord, changes) => {
                    // 여기서 원본 레코드와 수정된 레코드를 비교하여 변경 사항을 감지하고 전달
                    await handleSaveEdit(updatedRecord, changes);
                  }}
                  onCancel={handleCancelEdit}
                  doctors={doctors}
                />
              );
            }
            
            // 상세 정보 표시
            return (
              <RecordDetail 
                key={`desktop-detail-${selectedRecordId}`} 
                record={record}
                onEditRecord={handleEditRecord}
                blockchainRecords={blockchainRecords}
              />
            );
          })()}
          
          {/* 성공 메시지 */}
          {isEditSuccess && (
            <div className="mt-3 p-2 bg-green-50 border border-green-200 rounded-md text-xs text-green-600">
              진료 기록이 성공적으로 수정되었습니다.
            </div>
          )}
          
          {/* 오류 메시지 */}
          {editError && (
            <div className="mt-3 p-2 bg-red-50 border border-red-200 rounded-md text-xs text-red-600">
              {editError}
            </div>
          )}
        </div>
      )}
    </div>
  );
});

export default TreatmentHistoryList;

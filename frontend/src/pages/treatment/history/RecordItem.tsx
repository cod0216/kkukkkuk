import React, { useState } from "react";
import { BlockChainRecord } from "@/interfaces";
/**
 * @module RecordItem
 * @file RecordItem.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 반려동물 의료 기록의 간략한 정보를 표시하는 UI 컴포넌트
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         처방 목록 표시 일관성 개선, 테이블 형식으로 수정정
 */

/**
 * RecordItem 컴포넌트의 Props 타입 정의
 * @param petDID 반려동물의 DID 주소
 * @param didRegistryAddress DID 레지스트리 컨트랙트 주소
 * @param records 표시할 의료 기록 배열
 * @param onRecordSelect 기록 선택 시 호출될 콜백 함수
 */
interface RecordItemProps {
  records: BlockChainRecord[];
  onRecordSelect: (index: number) => void;
}

interface SortConfig {
  key: keyof BlockChainRecord;
  direction: 'asc' | 'desc';
}

/**
 * 반려동물 의료 기록을 테이블 형식으로 표시하는 컴포넌트
 */
const RecordItem: React.FC<RecordItemProps> = ({ 
  records,
  onRecordSelect
}) => {
  const [searchText, setSearchText] = useState<string>('');
  // const [filterStatus, setFilterStatus] = useState<string>('all');
  const [sortConfig, setSortConfig] = useState<SortConfig>({ key: 'timestamp', direction: 'desc' });

  // 검색 및 필터링
  const handleSearch = (e: React.ChangeEvent<HTMLInputElement>) => {
    setSearchText(e.target.value);
  };

  // 정렬 처리
  const handleSort = (key: keyof BlockChainRecord) => {
    let direction: 'asc' | 'desc' = 'asc';
    
    if (sortConfig.key === key && sortConfig.direction === 'asc') {
      direction = 'desc';
    }
    
    setSortConfig({ key, direction });
  };

  // 날짜 포맷 함수
  const formatDate = (timestamp: number): string => {
    try {
      const date = new Date(timestamp * 1000);
      return date.toLocaleString('ko-KR', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit'
      });
    } catch (error) {
      console.error('Date formatting error:', error);
      return '날짜 정보 없음';
    }
  };

  // 필터링된 데이터
  const filteredRecords = records.filter(record => {
    const matchesSearch = !searchText || 
      record.diagnosis.toLowerCase().includes(searchText.toLowerCase()) ||
      record.hospitalName.toLowerCase().includes(searchText.toLowerCase()) ||
      record.doctorName.toLowerCase().includes(searchText.toLowerCase());
    
    // const matchesStatus = filterStatus === 'all' ||
    //   (filterStatus === 'active' && !record.isDeleted) ||
    //   (filterStatus === 'deleted' && record.isDeleted);
    
    return matchesSearch;
  });

  // 정렬된 데이터
  const sortedRecords = [...filteredRecords].sort((a, b) => {
    const aValue = a[sortConfig.key];
    const bValue = b[sortConfig.key];
    
    if (aValue === undefined || bValue === undefined) return 0;
    
    if (sortConfig.direction === 'asc') {
      return aValue > bValue ? 1 : -1;
    } else {
      return aValue < bValue ? 1 : -1;
    }
  });

  return (
    <div className="w-full">
      {/* 검색 UI */}
      <div className="mb-2 flex">
        <input
          type="text"
          placeholder="진단명, 병원명, 의사명으로 검색"
          className="px-2 py-1 border rounded-md w-48 text-xs"
          value={searchText}
          onChange={handleSearch}
        />
      </div>

      {/* 테이블 */}
      <div className="overflow-x-auto">
        <table className="min-w-full border-collapse text-sm">
          <thead>
            <tr className="bg-gray-100">
              <th 
                className="px-2 py-1 text-left cursor-pointer text-xs"
                onClick={() => handleSort('timestamp')}
              >
                진료일
                {sortConfig.key === 'timestamp' && (
                  <span className="ml-1">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>
                )}
              </th>
              <th 
                className="px-2 py-1 text-left cursor-pointer text-xs"
                onClick={() => handleSort('diagnosis')}
              >
                진단명
                {sortConfig.key === 'diagnosis' && (
                  <span className="ml-1">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>
                )}
              </th>
              <th 
                className="px-2 py-1 text-left cursor-pointer text-xs"
                onClick={() => handleSort('hospitalName')}
              >
                병원명
                {sortConfig.key === 'hospitalName' && (
                  <span className="ml-1">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>
                )}
              </th>
              <th 
                className="px-2 py-1 text-left cursor-pointer text-xs"
                onClick={() => handleSort('doctorName')}
              >
                담당의사
                {sortConfig.key === 'doctorName' && (
                  <span className="ml-1">{sortConfig.direction === 'asc' ? '↑' : '↓'}</span>
                )}
              </th>
              <th className="px-2 py-1 text-center text-xs">처방</th>
            </tr>
          </thead>
          <tbody>
            {sortedRecords.length === 0 ? (
              <tr>
                <td colSpan={5} className="px-2 py-2 text-center border-b text-xs">
                  진료기록이 없습니다.
                </td>
              </tr>
            ) : (
              sortedRecords.map((record, index) => {
                // 원본 배열에서의 인덱스 찾기
                const originalIndex = records.findIndex(r => r.id === record.id);
                
                return (
                  <tr 
                    key={record.id || index} 
                    className="hover:bg-gray-50 border-b cursor-pointer text-xs"
                    onClick={() => onRecordSelect(originalIndex >= 0 ? originalIndex : index)}
                  >
                    <td className="px-2 py-1">{formatDate(record.timestamp)}</td>
                    <td className="px-2 py-1 max-w-[150px] truncate">{record.diagnosis}</td>
                    <td className="px-2 py-1">{record.hospitalName}</td>
                    <td className="px-2 py-1">{record.doctorName}</td>
                    <td className="px-2 py-1">
                      <div className="flex gap-1 justify-center">
                        {record.treatments.examinations.length > 0 && (
                          <span className="inline-flex items-center justify-center text-xs bg-primary-50 text-primary-700 rounded-full px-2 py-1 mr-1">
                            검사 {record.treatments.examinations.length}
                          </span>
                        )}
                        {record.treatments.medications.length > 0 && (
                          <span className="inline-flex items-center justify-center text-xs bg-blue-50 text-blue-700 rounded-full px-2 py-1 mr-1">
                            약물 {record.treatments.medications.length}
                          </span>
                        )}
                        {record.treatments.vaccinations.length > 0 && (
                          <span className="inline-flex items-center justify-center text-xs bg-green-50 text-green-700 rounded-full px-2 py-1">
                            접종 {record.treatments.vaccinations.length}
                          </span>
                        )}
                      </div>
                    </td>
                  </tr>
                );
              })
            )}
          </tbody>
        </table>
      </div>
    </div>
  );
};

export default RecordItem;

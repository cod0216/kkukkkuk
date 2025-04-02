import React from "react";
import { BlockChainRecord } from "@/interfaces";
import { FaSortUp, FaSortDown } from 'react-icons/fa';
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
 * 2025-04-02        assistant        정렬 기능 추가
 */

/**
 * 정렬 기준 타입
 */
type SortField = 'timestamp' | 'diagnosis' | 'hospitalName' | 'doctorName';

/**
 * 정렬 방향 타입
 */
type SortDirection = 'asc' | 'desc';

/**
 * RecordItem 컴포넌트의 Props 타입 정의
 * @param petDID 반려동물의 DID 주소
 * @param didRegistryAddress DID 레지스트리 컨트랙트 주소
 * @param records 표시할 의료 기록 배열
 * @param onRecordSelect 기록 선택 시 호출될 콜백 함수
 * @param onSort 정렬 기준 변경 시 호출될 콜백 함수
 * @param sortField 현재 정렬 기준 필드
 * @param sortDirection 현재 정렬 방향
 */
interface RecordItemProps {
  records: BlockChainRecord[];
  onRecordSelect: (id: string) => void;
  selectedRecordId?: string | null;
  onSort?: (field: SortField) => void;
  sortField?: SortField;
  sortDirection?: SortDirection;
}

/**
 * 반려동물 의료 기록을 테이블 형식으로 표시하는 컴포넌트
 */
const RecordItem: React.FC<RecordItemProps> = ({ 
  records,
  onRecordSelect,
  selectedRecordId,
  onSort,
  sortField,
  sortDirection
}) => {
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
  
  // 정렬 헤더 렌더링 함수
  const renderSortHeader = (label: string, field: SortField) => {
    const isActive = sortField === field;
    
    return (
      <th 
        className={`px-2 py-1 text-left text-xs cursor-pointer hover:bg-gray-200 ${isActive ? 'bg-gray-150' : ''}`}
        onClick={() => onSort && onSort(field)}
      >
        <div className="flex items-center justify-between">
          <span>{label}</span>
          {isActive && (
            sortDirection === 'asc' ? 
              <FaSortUp className="text-primary-600" /> : 
              <FaSortDown className="text-primary-600" />
          )}
        </div>
      </th>
    );
  };

  return (
    <div className="w-full">
      {/* 테이블 */}
      <div className="overflow-x-auto">
        <table className="min-w-full border-collapse text-sm">
          <thead>
            <tr className="bg-gray-100">
              {renderSortHeader('진료일', 'timestamp')}
              {renderSortHeader('진단명', 'diagnosis')}
              {renderSortHeader('병원명', 'hospitalName')}
              {renderSortHeader('담당의사', 'doctorName')}
              <th className="px-2 py-1 text-center text-xs">처방</th>
            </tr>
          </thead>
          <tbody>
            {records.length === 0 ? (
              <tr>
                <td colSpan={5} className="px-2 py-2 text-center border-b text-xs">
                  진료기록이 없습니다.
                </td>
              </tr>
            ) : (
              records.map((record, index) => {
                return (
                  <tr 
                    key={record.id || index} 
                    className={`border-b cursor-pointer text-xs ${
                      selectedRecordId && record.id === selectedRecordId 
                        ? 'bg-blue-50 hover:bg-blue-100' 
                        : 'hover:bg-gray-50'
                    }`}
                    onClick={() => onRecordSelect(record.id || '')}
                  >
                    <td className="px-2 py-1">{formatDate(record.timestamp)}</td>
                    <td className="px-2 py-1 max-w-[150px] truncate">{record.diagnosis}</td>
                    <td className="px-2 py-1">{record.hospitalName}</td>
                    <td className="px-2 py-1">{record.doctorName}</td>
                    <td className="px-2 py-1">
                      <div className="flex gap-1 justify-center min-h-[26px]">
                        {record.treatments.examinations.length > 0 ? (
                          <span className="inline-flex items-center justify-center text-xs bg-primary-50 text-primary-700 rounded-full px-2 py-1 mr-1">
                            검사 {record.treatments.examinations.length}
                          </span>
                        ) : null}
                        {record.treatments.medications.length > 0 ? (
                          <span className="inline-flex items-center justify-center text-xs bg-blue-50 text-blue-700 rounded-full px-2 py-1 mr-1">
                            약물 {record.treatments.medications.length}
                          </span>
                        ) : null}
                        {record.treatments.vaccinations.length > 0 ? (
                          <span className="inline-flex items-center justify-center text-xs bg-green-50 text-green-700 rounded-full px-2 py-1">
                            접종 {record.treatments.vaccinations.length}
                          </span>
                        ) : null}
                        {record.treatments.examinations.length === 0 && 
                         record.treatments.medications.length === 0 && 
                         record.treatments.vaccinations.length === 0 && (
                          <span className="invisible text-xs px-2 py-1">처방 없음</span>
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

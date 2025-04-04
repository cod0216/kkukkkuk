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
 * 2025-03-28        seonghun         처방 목록 표시 일관성 개선, 테이블 형식으로 수정
 * 2025-04-02        seonghun         정렬 기능 추가, 인증여부 상태표시추가
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
 * 진료 상태에 따른 스타일을 반환하는 함수
 */
const getStatusStyle = (status: string): string => {
  switch (status.toUpperCase()) {
    case 'WAITING':
      return 'bg-gray-100 text-gray-700';
    case 'IN_PROGRESS':
      return 'bg-blue-100 text-blue-700';
    case 'COMPLETED':
      return 'bg-green-100 text-green-700';
    case 'CANCELLED':
      return 'bg-red-100 text-red-700';
    case 'SHARED':
      return 'bg-purple-100 text-purple-700';
    default:
      return 'bg-gray-100 text-gray-700';
  }
};

/**
 * 진료 상태 코드를 표시용 텍스트로 변환하는 함수
 */
const getStatusText = (status: string): string => {
  switch (status.toUpperCase()) {
    case 'WAITING':
      return '진료전';
    case 'IN_PROGRESS':
      return '진료중';
    case 'COMPLETED':
      return '진료완료';
    case 'CANCELLED':
      return '취소됨';
    case 'SHARED':
      return '공유중';
    default:
      return '';
  }
};

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
  console.log('레코드 상태 정보:', records.map(r => ({
    id: r.id,
    diagnosis: r.diagnosis,
    status: r.status || '상태 없음'
  })));

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
              <th className="px-2 py-1 text-center text-xs">상태</th>
            </tr>
          </thead>
          <tbody>
            {records.length === 0 ? (
              <tr>
                <td colSpan={6} className="px-2 py-2 text-center border-b text-xs">
                  진료기록이 없습니다.
                </td>
              </tr>
            ) : (
              records.map((record, index) => {
                return (
                  <tr 
                    key={record.id || `temp-${index}`} 
                    className={`border-b cursor-pointer text-xs ${
                      selectedRecordId && record.id === selectedRecordId 
                        ? 'bg-blue-50 hover:bg-blue-100' 
                        : 'hover:bg-gray-50'
                    }`}
                    onClick={() => {
                      console.log('RecordItem 클릭 - 전달할 ID:', record.id, '기록:', record);
                      
                      // ID가 없는 경우 임시 ID 생성
                      let selectedId = record.id;
                      if (!selectedId) {
                        // 임시 ID 생성 (타임스탬프 + 진단명 해시)
                        const timestamp = record.timestamp || Math.floor(Date.now() / 1000);
                        const diagnosisHash = record.diagnosis ? 
                          record.diagnosis.split('').reduce((acc, char) => acc + char.charCodeAt(0), 0) : 
                          0;
                        selectedId = `temp_${timestamp}_${diagnosisHash}_${index}`;
                        console.log('임시 ID 생성:', selectedId);
                        
                        // 기록에 ID 직접 할당 (오직 클라이언트에서만 사용)
                        // @ts-ignore: 객체의 속성을 동적으로 할당
                        record.id = selectedId;
                      }
                      
                      onRecordSelect(selectedId);
                    }}
                  >
                    <td className="px-2 py-1">{formatDate(record.timestamp)}</td>
                    <td className="px-2 py-1 max-w-[150px] truncate">
                      {record.diagnosis}
                      {record.flagCertificated === false && (
                        <span className="ml-1 text-red-500 text-xs font-medium">(미인증)</span>
                      )}
                    </td>
                    <td className="px-2 py-1">{record.hospitalName}</td>
                    <td className="px-2 py-1">{record.doctorName}</td>
                    <td className="px-2 py-1">
                      <div className="flex gap-1 justify-center min-h-[26px]">
                        {record.treatments?.examinations?.length > 0 ? (
                          <span className="inline-flex items-center justify-center text-xs bg-primary-50 text-primary-700 rounded-full px-2 py-1 mr-1">
                            검사 {record.treatments?.examinations?.length || 0}
                          </span>
                        ) : null}
                        {record.treatments?.medications?.length > 0 ? (
                          <span className="inline-flex items-center justify-center text-xs bg-blue-50 text-blue-700 rounded-full px-2 py-1 mr-1">
                            약물 {record.treatments?.medications?.length || 0}
                          </span>
                        ) : null}
                        {record.treatments?.vaccinations?.length > 0 ? (
                          <span className="inline-flex items-center justify-center text-xs bg-green-50 text-green-700 rounded-full px-2 py-1">
                            접종 {record.treatments?.vaccinations?.length || 0}
                          </span>
                        ) : null}
                        {(!record.treatments?.examinations?.length && 
                         !record.treatments?.medications?.length && 
                         !record.treatments?.vaccinations?.length) && (
                          <span className="invisible text-xs px-2 py-1">처방 없음</span>
                        )}
                      </div>
                    </td>
                    <td className="px-2 py-1 text-center">
                      {record.status ? (
                        <span className={`text-xs font-medium px-2 py-0.5 rounded-full ${getStatusStyle(record.status)}`}>
                          {getStatusText(record.status)}
                        </span>
                      ) : null}
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

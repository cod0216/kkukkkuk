import React from 'react';
import { BlockChainRecord } from '@/interfaces';

/**
 * @component RecordHistory
 * @file RecordHistory.tsx
 * @author assistant
 * @date 2025-04-02
 * @description 반려동물 진료 기록의 수정 내역을 보여주는 컴포넌트입니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-02        assistant        최초 생성
 * 2025-04-03        assistant        수정 내역 표시 방식 변경 (previousRecord 참조 방식)
 * 2025-04-05        assistant        레코드 체인을 직접 받아서 사용하도록 수정
 */

/**
 * RecordHistory 컴포넌트의 Props 타입 정의
 */
interface RecordHistoryProps {
  historyChain: BlockChainRecord[]; // 현재 기록을 제외한 이전 수정 기록과 원본 기록의 배열 (최신순)
}

/**
 * 반려동물 진료 기록의 수정 내역을 보여주는 컴포넌트
 */
const RecordHistory: React.FC<RecordHistoryProps> = ({ historyChain }) => {
  // Unix timestamp를 날짜 형식으로 변환
  const formatDate = (record: BlockChainRecord): string => {
    try {
      // 다양한 소스에서 타임스탬프 추출 시도
      let timestamp: number = 0;
      
      // 1. timestamp 필드가 있고 숫자인 경우 사용
      if (typeof record.timestamp === 'number') {
        timestamp = record.timestamp;
      } 
      // 2. timestamp 필드가 문자열인 경우 변환 시도
      else if (typeof record.timestamp === 'string') {
        timestamp = parseInt(record.timestamp);
      }
      // 3. createdAt 필드가 있는 경우 사용
      else if (record.createdAt) {
        timestamp = typeof record.createdAt === 'number' 
          ? record.createdAt 
          : parseInt(record.createdAt);
      }
      
      // 유효한 타임스탬프가 아니면 ID에서 추출 시도
      if (isNaN(timestamp) || timestamp === 0) {
        if (record.id && record.id.includes('_')) {
          const parts = record.id.split('_');
          if (parts.length >= 3) {
            const idTimestamp = parseInt(parts[2]);
            if (!isNaN(idTimestamp)) {
              timestamp = idTimestamp;
            }
          }
        }
      }
      
      // 여전히 유효한 타임스탬프가 아니면 기본값 사용
      if (isNaN(timestamp) || timestamp === 0) {
        return '날짜 정보 없음';
      }
      
      const date = new Date(timestamp * 1000);
      return date.toLocaleString('ko-KR', {
        year: 'numeric',
        month: '2-digit',
        day: '2-digit',
        hour: '2-digit',
        minute: '2-digit',
        second: '2-digit'  // 초단위까지 표시하여 아주 빠른 수정도 구분할 수 있게 함
      });
    } catch (error) {
      console.error('날짜 변환 오류:', error, record);
      return '날짜 정보 없음';
    }
  };
  
  // 처방 정보를 압축적으로 표시하는 함수
  const renderTreatments = (record: BlockChainRecord) => {
    if (!record.treatments) return null;
    
    // 각 항목 배열을 하나로 합치기
    const allTreatments = [
      ...(record.treatments.examinations || []).map(item => ({...item, type: '검사'})),
      ...(record.treatments.medications || []).map(item => ({...item, type: '처방'})),
      ...(record.treatments.vaccinations || []).map(item => ({...item, type: '접종'}))
    ];
    
    // 처방 항목이 없으면 표시하지 않음
    if (allTreatments.length === 0) return null;
    
    // 타입별로 그룹화
    const groupedByType: Record<string, any[]> = {};
    allTreatments.forEach(item => {
      if (!groupedByType[item.type]) {
        groupedByType[item.type] = [];
      }
      groupedByType[item.type].push(item);
    });
    
    return (
      <div className="mt-1 text-[10px] text-gray-500">
        {Object.entries(groupedByType).map(([type, items]) => (
          <div key={type} className="truncate">
            <span className="text-gray-600">{type}:</span> {
              items.map(item => {
                // key와 value가 있으면 함께 표시, 없으면 둘 중 하나만 표시
                const displayText = item.key && item.value 
                  ? `${item.key}(${item.value})` 
                  : item.key || item.value || item.name || '항목명 없음';
                return displayText;
              }).join(', ')
            }
          </div>
        ))}
      </div>
    );
  };
  
  return (
    <div className="mt-3">
      <h4 className="text-xs font-semibold text-gray-800 mb-2">이전 수정 내역</h4>
      
      {historyChain.length === 0 ? (
        <div className="border border-gray-200 rounded-md p-3 text-xs text-gray-500">
          이전 수정 내역이 없습니다.
        </div>
      ) : (
        <div className="border border-gray-200 rounded-md divide-y divide-gray-200">
          {historyChain.map((record, index) => {
            // 마지막 항목은 원본 기록
            const isOriginal = index === historyChain.length - 1;
            
            return (
              <div key={record.id} className="p-2 bg-gray-50">
                <div className="flex justify-between items-center mb-1">
                  <span className="text-xs font-medium text-gray-700">
                    {isOriginal ? '최초 작성 (원본)' : `수정 내역 #${historyChain.length - index}`}
                  </span>
                  <span className="text-xs text-gray-500">{formatDate(record)}</span>
                </div>
                <div className="text-xs text-gray-600 mb-1">
                  {record.hospitalName && <span className="font-medium">{record.hospitalName}</span>}
                  {record.doctorName && <span> / {record.doctorName}</span>}
                </div>
                <div className="text-xs text-gray-700 font-medium">진단명: {record.diagnosis}</div>
                {record.notes && (
                  <div className="text-xs text-gray-600 mt-1 truncate">
                    증상: {record.notes.length > 50 ? record.notes.substring(0, 50) + '...' : record.notes}
                  </div>
                )}
                
                {/* 처방 정보 표시 */}
                {renderTreatments(record)}
              </div>
            );
          })}
        </div>
      )}
    </div>
  );
};

export default RecordHistory; 
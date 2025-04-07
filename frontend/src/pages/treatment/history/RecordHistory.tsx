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
          {historyChain.slice(1).map((record, index) => {
            // 마지막 항목은 원본 기록
            const isOriginal = index === historyChain.length - 2;
            
            return (
              <div key={record.id} className="p-2 bg-gray-50">
                <div className="flex justify-between items-center mb-1">
                  <span className="text-xs font-medium text-gray-700">
                    {isOriginal ? '최초 작성 (원본)' : `수정 내역 #${historyChain.length - index - 1}`}
                  </span>
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
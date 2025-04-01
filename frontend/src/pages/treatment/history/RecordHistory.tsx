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
 */

/**
 * RecordHistory 컴포넌트의 Props 타입 정의
 */
interface RecordHistoryProps {
  record: BlockChainRecord;
  allRecords?: BlockChainRecord[];
}

/**
 * 반려동물 진료 기록의 수정 내역을 보여주는 컴포넌트
 */
const RecordHistory: React.FC<RecordHistoryProps> = ({ record, allRecords = [] }) => {
  // 내역 기록들 생성
  const getHistoryChain = (currentRecord: BlockChainRecord): BlockChainRecord[] => {
    const historyChain: BlockChainRecord[] = [];
    
    // 조회할 이전 기록 ID
    let previousId = currentRecord.previousRecord;
    
    // 이전 기록이 없으면 현재 기록만 반환
    if (!previousId) {
      return [currentRecord];
    }
    
    // 현재 기록 추가
    historyChain.push(currentRecord);
    
    // 이전 기록들을 찾아 추가
    while (previousId) {
      const prevRecord = allRecords.find(r => r.id === previousId);
      if (prevRecord) {
        historyChain.push(prevRecord);
        previousId = prevRecord.previousRecord;
      } else {
        break; // 이전 기록을 찾을 수 없으면 종료
      }
    }
    
    return historyChain;
  };
  
  // 수정 내역 추출
  const historyItems = getHistoryChain(record);
  
  // Unix timestamp를 날짜 형식으로 변환
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
      console.error('날짜 변환 오류:', error, timestamp);
      return '날짜 정보 없음';
    }
  };
  
  // 변경 내용 추출 (노트에서 [수정내역] 부분만 추출)
  const extractChanges = (notes: string): string[] => {
    if (!notes) return [];
    
    const changeRegex = /\[수정내역\]\s*(.*?)(\n\n|$)/g;
    const matches = [...notes.matchAll(changeRegex)];
    
    if (matches.length === 0) return [];
    
    return matches.map(match => match[1].trim())
      .filter(Boolean)
      .flatMap(change => change.split(', '));
  };

  return (
    <div className="mt-3">
      <h4 className="text-xs font-semibold text-gray-800 mb-2">수정 내역</h4>
      
      {historyItems.length <= 1 ? (
        <div className="border border-gray-200 rounded-md p-3 text-xs text-gray-500">
          수정 내역이 없습니다.
        </div>
      ) : (
        <div className="border border-gray-200 rounded-md divide-y divide-gray-200">
          {historyItems.map((item, index) => {
            // 첫 번째 항목(현재 레코드)은 표시하지 않음
            if (index === 0) return null;
            
            const changes = extractChanges(historyItems[index - 1].notes);
            
            return (
              <div key={item.id} className="p-2 bg-gray-50">
                <div className="flex justify-between items-center mb-1">
                  <span className="text-xs font-medium text-gray-700">
                    {index === historyItems.length - 1 ? '최초 작성' : '진료 기록 수정'}
                  </span>
                  <span className="text-xs text-gray-500">{formatDate(item.timestamp)}</span>
                </div>
                <div className="text-xs text-gray-600 mb-1">{item.doctorName}</div>
                
                {changes.length > 0 && (
                  <ul className="text-xs text-gray-600 pl-3 list-disc">
                    {changes.map((change, i) => (
                      <li key={i}>{change}</li>
                    ))}
                  </ul>
                )}
              </div>
            );
          }).filter(Boolean)}
        </div>
      )}
    </div>
  );
};

export default RecordHistory; 
import React from 'react';
import { BlockChainRecord } from '@/interfaces';
import RecordItem from '@/pages/treatment/history/RecordItem';
/**
 * @module TreatmentHistoryList
 * @file TreatmentHistoryList.tsx
 * @author haelim
 * @date 2025-03-26
 * @description 반려동물 의료 기록의 목록을 조회하는 UI 컴포넌트 
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */

/**
 * TreatmentHistoryList 컴포넌트의 Props 타입 정의
 * @param records 블록체인 의료 데이터 array
 * @param setSelectedRecordIndex Detail 을 보여줄 의료 기록의 index 
 */
interface TreatmentHistoryListProps {
  records: BlockChainRecord[];
  setSelectedRecordIndex: (idx: number) => void;
}

/**
 * 반려동물 의료 기록의 목록을 조회하는 UI 컴포넌트 
*/
const TreatmentHistoryList: React.FC<TreatmentHistoryListProps> = ({ records, setSelectedRecordIndex }) => {
  return (
    <div className="flex flex-col flex-1 h-full">
      <div className="flex-1 flex flex-col bg-white border border-gray-200 rounded-md 
                      h-full max-h-full overflow-y-auto">
        <div className="flex justify-between">
          <h3 className="font-bold text-gray-800 m-1 p-3">전체 진료 기록</h3>
          <div className="text-xs text-gray-500 flex gap-2 items-center mr-5">
            {<span className="flex items-center gap-1"> <span className="rounded-max w-1.5 h-1.5 bg-red-200"></span> 검사 </span>}
            {<span className="flex items-center gap-1"> <span className="rounded-max w-1.5 h-1.5 bg-secondary-200"></span>약물</span>}
            {<span className="flex items-center gap-1"> <span className="rounded-max w-1.5 h-1.5 bg-primary-300"></span>백신</span>}
          </div>
        </div>
        {records.map((record, idx) => (
          <RecordItem key={idx} record={record} idx={idx} setSelectedRecordIndex={setSelectedRecordIndex} />
        ))}
      </div>
    </div>
  );
};

export default TreatmentHistoryList;

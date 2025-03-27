import React from 'react';
import { BlockChainRecord } from '@/interfaces';

/**
 * @module RecordItem
 * @file RecordItem.tsx
 * @author haelim
 * @date 2025-03-26
 * @description 반려동물 의료 기록의 간략한 정보를 표시하는 UI 컴포넌트
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */

/**
 * RecordItem 컴포넌트의 Props 타입 정의
 * @param record 해당 컴포넌트에 정보를 뿌려주기 위한 블록체인 데이터 
 * @param idx 해당 컴포넌트의 index
 * @param setSelectedRecordIndex 현재 선택된 블록체인 기록의 index
 */
interface RecordItemProps {
  record: BlockChainRecord;
  idx: number;
  setSelectedRecordIndex: (idx:number) => void;
}

/**
 * 반려동물 의료 기록의 간략한 정보를 표시하는 UI 컴포넌트
 */
const RecordItem: React.FC<RecordItemProps> = ({ record, idx, setSelectedRecordIndex }) => {
  const HOSPITAL_ADDRESS = "hospital:0xexampleaddress";
  const isMyRecord: boolean = HOSPITAL_ADDRESS === record.hospitalAddress;

  const examinations = record.treatments.examinations.length;
  const medications = record.treatments.medications.length;
  const vaccinations = record.treatments.vaccinations.length;

  return (
    <div
      key={idx}
      onClick={() => setSelectedRecordIndex(idx)}
      className="hover:bg-gray-50 border-b px-5 py-2 cursor-pointer group flex justify-between items-center">

      <div className="flex flex-col">
        <div className="font-semibold text-sm text-gray-800">{record.diagnosis}</div>
        <div className="text-xs text-gray-500 flex gap-2 items-center">
          {examinations > 0 && <span className="flex items-center gap-1"> <span className="rounded-max w-1.5 h-1.5 bg-red-200"></span> {examinations}</span>}
          {medications > 0 && <span className="flex items-center gap-1"> <span className="rounded-max w-1.5 h-1.5 bg-secondary-200"></span>{medications}</span>}
          {vaccinations > 0 && <span className="flex items-center gap-1"> <span className="rounded-max w-1.5 h-1.5 bg-primary-300"></span>{vaccinations}</span>}
        </div>
      </div>
      <div className="flex flex-col items-end text-right">
        <div className={
          `${isMyRecord ? `bg-primary-200` : `bg-secondary-100`} text-[8pt] text-gray-600 font-medium rounded-xl  px-2`
        }>{record.hospitalName}</div>
        <div className="font-md text-[8pt] text-gray-500 px-1">{record.createdAt}</div>

      </div>

    </div>
  );
};

export default RecordItem;
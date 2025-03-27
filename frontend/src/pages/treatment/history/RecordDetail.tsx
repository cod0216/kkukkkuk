import React from 'react';
import { BlockChainRecord } from '@/interfaces';

/**
 * @component RecordDetail
 * @file RecordDetail.tsx
 * @author haelim
 * @date 2025-03-26
 * @description 반려동물 진료 기록을 상세 조회하는 UI 컴포넌트입니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */



/**
 * RecordDetail 컴포넌트의 Props 타입 정의
 * @param record 반려동물의 블록체인 의료 데이터 
 */
interface RecordDetailProps {
  record: BlockChainRecord;
}

/**
 * 특정 반려동물의 진료 기록을 표시하는 컴포넌트입니다.
 */
export const RecordDetail: React.FC<RecordDetailProps> = ({ record }) => {

  return (
    <div className="w-[300px] bg-white p-5 rounded-md border border-gray-200 group">
      {/* 상단 진단 정보 */}
      <div className="flex justify-between items-center">
        <div className="flex items-center space-x-4">
          <div>
            <div className="font-semibold text-gray-800">{record.diagnosis}</div>
            <div className="text-xs text-gray-500">{record.createdAt}</div>
          </div>
        </div>

        {/* 병원 및 담당의 정보 */}
        <div className="flex flex-col text-right space-y-1">
          <div className="text-xs text-gray-600 font-medium">기록: {record.hospitalName}</div>
          <div className="text-xs text-gray-600">담당의: {record.doctorName}</div>
        </div>
      </div>


      {/* 노트 및 처방 정보 */}
      <div className="mt-6 space-y-6 border-t pt-6 border-gray-100">
        <div>
          <h4 className="text-sm font-semibold text-gray-800 mb-1">노트</h4>
          <p className="text-sm text-gray-700 leading-relaxed">{record.notes}</p>
        </div>

        <div>
          <h4 className="text-sm font-semibold text-gray-800 mb-3">처방</h4>
          <div className="bg-gray-50 rounded-lg p-4 space-y-2">
            {record.treatments.examinations.map((exam, index) => (
              <div key={index} className="text-xs flex justify-between border-b pb-2 last:border-b-0">
                <span className="font-medium text-gray-800">{exam.type}</span>
                <span className="text-gray-600">{exam.value}</span>
              </div>
            ))}
            {record.treatments.medications.map((medication, index) => (
              <div key={index} className="text-xs flex justify-between border-b pb-2 last:border-b-0">
                <span className="font-medium text-gray-800">{medication.type}</span>
                <span className="text-gray-600">용량: {medication.value}</span>
              </div>
            ))}
            {record.treatments.vaccinations.map((vaccination, index) => (
              <div key={index} className="text-xs flex justify-between border-b pb-2 last:border-b-0">
                <span className="font-medium text-gray-800">{vaccination.type}</span>
                <span className="text-gray-600">{vaccination.value}차</span>
              </div>
            ))}
          </div>
        </div>

        {/* 사진 섹션 */}
        {record.pictures.length > 0 && (
          <div>
            <h4 className="text-sm font-semibold text-gray-800 mb-3">사진</h4>
            <div className="grid grid-cols-4 gap-3">
              {record.pictures.map((picture, index) => (
                <img key={index} src={picture}
                  className="w-full aspect-square object-cover rounded-lg shadow-sm hover:shadow-md transition-shadow"
                />
              ))}
            </div>
          </div>
        )}
      </div>
    </div>
  );
};

export default RecordDetail;

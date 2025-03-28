import React, { useState } from 'react';
import { BlockChainRecord } from '@/interfaces';

/**
 * @component RecordDetail
 * @file RecordDetail.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 반려동물 진료 기록을 상세 조회하는 UI 컴포넌트입니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         처방 정보 표시 필드 수정 (type → key)
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
  const [selectedImage, setSelectedImage] = useState<string | null>(null);

  // 이미지 확대 모달 표시
  const showImageModal = (imageUrl: string) => {
    setSelectedImage(imageUrl);
  };

  // 이미지 확대 모달 닫기
  const closeImageModal = () => {
    setSelectedImage(null);
  };
  
  // Unix timestamp를 날짜 형식으로 변환
  const formatDate = (timestamp: number): string => {
    try {
      // Unix timestamp를 밀리초 단위로 변환 (초 * 1000)
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

  return (
    <div className="w-[350px] bg-white rounded-md border border-gray-200 overflow-hidden shadow-sm">
      {/* 상단 요약 정보 */}
      <div className="p-4 border-b border-gray-100">
        <div className="font-semibold text-gray-800">{record.diagnosis}</div>
        <div className="text-xs text-gray-500">
          {record.timestamp ? formatDate(record.timestamp) : record.createdAt}
        </div>
        <div className="text-xs text-gray-600 font-medium mt-1">{record.hospitalName}</div>
      </div>

      {/* 상세 정보 */}
      <div className="p-4">
        {/* 담당의 정보 */}
        <div className="mb-4 flex justify-between text-xs">
          <div className="text-gray-600">담당의: {record.doctorName}</div>
        </div>

        {/* 노트 및 처방 정보 */}
        <div className="space-y-4">
          <div>
            <h4 className="text-xs font-semibold text-gray-800 mb-1">노트</h4>
            <p className="text-xs text-gray-700 leading-relaxed">{record.notes || '노트 정보가 없습니다.'}</p>
          </div>

          <div>
            <h4 className="text-xs font-semibold text-gray-800 mb-2">처방</h4>
            <div className="flex gap-1 flex-col text-sm p-2 bg-gray-50 rounded-lg">
              {/* 검사 정보 */}
              {record.treatments.examinations.length > 0 && (
                <div>
                  <h5 className="text-xs font-bold text-gray-700">검사</h5>
                  {record.treatments.examinations.map((exam, index) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg mb-1 text-xs">
                      <span className="font-medium text-gray-800">{exam.key}</span>
                      <span className="text-gray-600">{exam.value}</span>
                    </div>
                  ))}
                </div>
              )}

              {/* 약물 정보 */}
              {record.treatments.medications.length > 0 && (
                <div className="mt-2">
                  <h5 className="text-xs font-bold text-gray-700">약물</h5>
                  {record.treatments.medications.map((medication, index) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg mb-1 text-xs">
                      <span className="font-medium text-gray-800">{medication.key}</span>
                      <span className="text-gray-600">{medication.value}</span>
                    </div>
                  ))}
                </div>
              )}

              {/* 접종 정보 */}
              {record.treatments.vaccinations.length > 0 && (
                <div className="mt-2">
                  <h5 className="text-xs font-bold text-gray-700">접종</h5>
                  {record.treatments.vaccinations.map((vaccination, index) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg mb-1 text-xs">
                      <span className="font-medium text-gray-800">{vaccination.key}</span>
                      <span className="text-gray-600">{vaccination.value}차</span>
                    </div>
                  ))}
                </div>
              )}
              
              {/* 처방 정보가 없는 경우 */}
              {record.treatments.examinations.length === 0 && 
               record.treatments.medications.length === 0 && 
               record.treatments.vaccinations.length === 0 && (
                <div className="text-xs text-gray-500 p-2">
                  처방 정보가 없습니다.
                </div>
              )}
            </div>
          </div>

          {/* 사진 섹션 */}
          {record.pictures && record.pictures.length > 0 && (
            <div>
              <h4 className="text-xs font-semibold text-gray-800 mb-2">사진</h4>
              <div className="grid grid-cols-2 gap-2">
                {record.pictures.map((picture, index) => (
                  <div 
                    key={index} 
                    className="cursor-pointer relative group"
                    onClick={() => showImageModal(picture)}
                  >
                    <img 
                      src={picture}
                      alt={`진료 사진 ${index + 1}`}
                      className="w-full aspect-square object-cover rounded-lg shadow-sm group-hover:shadow-md transition-shadow"
                    />
                    <div className="absolute inset-0 bg-black bg-opacity-0 group-hover:bg-opacity-20 transition-all rounded-lg flex items-center justify-center">
                      <span className="text-white opacity-0 group-hover:opacity-100 transform scale-0 group-hover:scale-100 transition-all">
                        <svg className="w-5 h-5" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                          <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M21 21l-6-6m2-5a7 7 0 11-14 0 7 7 0 0114 0z"></path>
                        </svg>
                      </span>
                    </div>
                  </div>
                ))}
              </div>
            </div>
          )}
        </div>
      </div>

      {/* 이미지 확대 모달 */}
      {selectedImage && (
        <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-75" onClick={closeImageModal}>
          <div className="relative max-w-3xl max-h-[80vh] overflow-auto" onClick={(e) => e.stopPropagation()}>
            <button
              className="absolute top-4 right-4 bg-black bg-opacity-50 rounded-full p-2 text-white"
              onClick={closeImageModal}
            >
              <svg className="w-6 h-6" fill="none" stroke="currentColor" viewBox="0 0 24 24">
                <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M6 18L18 6M6 6l12 12"></path>
              </svg>
            </button>
            <img 
              src={selectedImage} 
              alt="확대된 이미지" 
              className="max-w-full max-h-[80vh] object-contain"
            />
          </div>
        </div>
      )}
    </div>
  );
};

export default RecordDetail;

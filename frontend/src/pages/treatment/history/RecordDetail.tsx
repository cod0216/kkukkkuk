import React, { useState, useEffect } from 'react';
import { BlockChainRecord } from '@/interfaces';
import RecordHistory from './RecordHistory';
import { FaChevronDown, FaChevronUp, FaEdit, FaCheck, FaExclamationTriangle } from 'react-icons/fa';
import { getAccountAddress } from '@/services/blockchainAuthService';
import { getRecordChanges } from '@/services/treatmentRecordService';
import ChatEntryButton from '@/pages/chat/ChatEntryButton'

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
 * 2025-04-02        seonghun         수정 내역 기능 및 진료 기록 수정 기능 추가, 인증 여부 및 상태 표시 추가
 * 2025-04-03        seonghun         처방정보 null undefined 처리 개선, 높이 계산 개선
 */

/**
 * RecordDetail 컴포넌트의 Props 타입 정의
 * @param record 반려동물의 블록체인 의료 데이터 
 */
interface RecordDetailProps {
  record: BlockChainRecord;
  onEditRecord?: (record: BlockChainRecord) => void;
  blockchainRecords?: BlockChainRecord[];
  selectedPetDid?: string;
}

/**
 * 특정 반려동물의 진료 기록을 표시하는 컴포넌트입니다.
 */
export const RecordDetail: React.FC<RecordDetailProps> = ({ 
  record,
  onEditRecord,
  selectedPetDid,
}) => {
  const [selectedImage, setSelectedImage] = useState<string | null>(null);
  const [showHistory, setShowHistory] = useState<boolean>(false);
  const [currentUserAddress, setCurrentUserAddress] = useState<string | null>(null);
  const [historyChain, setHistoryChain] = useState<BlockChainRecord[]>([]);
  
  // 현재 사용자 주소 가져오기
  useEffect(() => {
    const fetchUserAddress = async () => {
      const address = await getAccountAddress();
      setCurrentUserAddress(address);
    };
    
    fetchUserAddress();
  }, []);
  
  // 레코드 체인 가져오기
  useEffect(() => {
    const fetchRecordHistory = async () => {
      if (record && selectedPetDid) {
        try {
          console.log('기록 변경 이력 조회 시작:', record.id, selectedPetDid);
          
          // getRecordChanges 함수는 이미 현재 기록에 맞게 이력을 반환함:
          // - 원본 기록 → 빈 배열
          // - 수정본 기록 → 현재 기록을 제외한 이전 버전들 (최신순, 원본이 마지막)
          const historyRecords = await getRecordChanges(record, selectedPetDid);
          
          // 타임스탬프 디버깅 로그
          if (historyRecords.length > 0) {
            console.log('수정 내역의 타임스탬프 정보:');
            historyRecords.forEach((item, index) => {
              console.log(`기록 #${index + 1}:`, {
                id: item.id,
                timestamp: item.timestamp,
                createdAt: item.createdAt,
                timestampType: typeof item.timestamp,
                createdAtType: typeof item.createdAt,
                diagnosis: item.diagnosis,
                isOriginal: item.id?.startsWith('medical_record_')
              });
            });
          }
          
          console.log('기록 내역 조회 결과:', historyRecords.length, '개 항목', historyRecords);
          setHistoryChain(historyRecords);
        } catch (error) {
          console.error('기록 내역 조회 실패:', error);
          setHistoryChain([]);
        }
      } else {
        console.log('기록 내역 조회 불가: record 또는 selectedPetDid 없음', {
          hasRecord: !!record,
          selectedPetDid
        });
        setHistoryChain([]);
      }
    };
    
    fetchRecordHistory();
  }, [record, selectedPetDid]);
  
  // 이력이 있는지 확인 (빈 배열이 아닌 경우)
  const hasHistory = historyChain.length > 0;
  
  // 원본 기록인지 확인 (ID가 'medical_record_'로 시작하는 경우)
  const isOriginalRecord = record.id ? record.id.startsWith('medical_record_') : false;
  
  // 현재 사용자가 작성한 기록인지 확인
  const isOwnRecord = currentUserAddress && record.hospitalAddress && 
    currentUserAddress.toLowerCase() === record.hospitalAddress.toLowerCase();
  
  // 병원 주소가 있는지 확인 (기본 인증 조건)
  const hasHospitalAddress = !!record.hospitalAddress;
  
  // 인증되지 않은 기록인지 확인 (명시적으로 false인 경우만 미인증 처리)
  const isUncertifiedRecord = record.flagCertificated === false;
  
  // 기록이 병원에서 인증되었는지 여부 
  // 1. flagCertificated가 명시적으로 false가 아니고
  // 2. hospitalAddress가 존재하는 경우에만 인증된 것으로 처리
  const isCertifiedRecord = !isUncertifiedRecord && hasHospitalAddress;
  
  // 수정 가능 여부: 본인이 작성했거나 인증되지 않은 기록
  const canEdit = isOwnRecord || isUncertifiedRecord;

  // 이미지 확대 모달 표시
  const showImageModal = (imageUrl: string) => {
    setSelectedImage(imageUrl);
  };

  // 이미지 확대 모달 닫기
  const closeImageModal = () => {
    setSelectedImage(null);
  };
  
  // 수정 버튼 클릭 핸들러
  const handleEditClick = () => {
    if (onEditRecord && record) {
      // 레코드에 petDid가 없으면 selectedPetDid를 사용하여 정보를 보완
      const recordWithPetDid = {
        ...record,
        petDid: record.petDid || selectedPetDid
      };
      onEditRecord(recordWithPetDid);
    }
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
    <div className="w-[350px] bg-white rounded-md border border-gray-200 h-full flex flex-col">
      {/* 상단 요약 정보 */}
      <div className="p-4 border-b border-gray-100 flex-shrink-0">
        <div className="flex justify-between items-center">
          <div className="flex items-center gap-2 font-semibold text-gray-800">
            {record.diagnosis}
            {!isCertifiedRecord ? (
              <div className="flex items-center text-xs text-red-500 ml-2">
                <FaExclamationTriangle className="w-3 h-3 mr-1" />
                <span>인증되지 않은 기록</span>
              </div>
            ) : (
              <div className="flex items-center text-xs text-green-600 ml-2">
                <FaCheck className="w-3 h-3 mr-1" />
                <span>병원 인증 기록</span>
              </div>
            )}
          </div>
          {canEdit && (
            <button 
              onClick={handleEditClick}
              className={`${isOwnRecord ? 'text-primary-600 hover:text-primary-800' : 'text-orange-600 hover:text-orange-800'} p-1 rounded-full hover:bg-primary-50`}
              title={isOwnRecord ? "진료 기록 수정" : "인증되지 않은 기록 수정 및 인증"}
            >
              <FaEdit className="h-4 w-4" />
            </button>
          )}
        </div>
        <div className="text-xs text-gray-500">
          {record.timestamp ? formatDate(record.timestamp) : record.createdAt}
        </div>
        <div className='flex justify-between items-center'>
          <div className="text-xs text-gray-600 font-medium mt-1">{record.hospitalName}</div>
          <ChatEntryButton hospitalName={record.hospitalName} chatRoomId={record.hospitalAccountId} receiverId={record.hospitalAccountId}/>
        </div>
      </div>

      {/* 상세 정보 (정상 진료 기록) */}
      <div className="p-4 overflow-y-auto flex-1">
        {/* 담당의 정보 */}
        <div className="mb-4 flex justify-between text-xs">
          <div className="text-gray-600">담당의: {record.doctorName}</div>
        </div>

        {/* 노트 및 처방 정보 */}
        <div className="space-y-4">
          <div>
            <h4 className="text-xs font-semibold text-gray-800 mb-1">증상</h4>
            <p className="text-xs text-gray-700 leading-relaxed">{record.notes || '증상 정보가 없습니다.'}</p>
          </div>

          <div>
            <h4 className="text-xs font-semibold text-gray-800 mb-2">처방</h4>
            <div className="flex gap-1 flex-col text-sm p-2 bg-gray-50 rounded-lg">
              {/* 검사 정보 */}
              {record.treatments?.examinations?.length > 0 && (
                <div>
                  <h5 className="text-xs font-bold text-gray-700">검사</h5>
                  {record.treatments?.examinations?.map((exam, index) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg mb-1 text-xs">
                      <span className="font-medium text-gray-800">{exam?.key || ''}</span>
                      <span className="text-gray-600">{exam?.value || ''}</span>
                    </div>
                  ))}
                </div>
              )}

              {/* 약물 정보 */}
              {record.treatments?.medications?.length > 0 && (
                <div className="mt-2">
                  <h5 className="text-xs font-bold text-gray-700">약물</h5>
                  {record.treatments?.medications?.map((medication, index) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg mb-1 text-xs">
                      <span className="font-medium text-gray-800">{medication?.key || ''}</span>
                      <span className="text-gray-600">{medication?.value || ''}</span>
                    </div>
                  ))}
                </div>
              )}

              {/* 접종 정보 */}
              {record.treatments?.vaccinations?.length > 0 && (
                <div className="mt-2">
                  <h5 className="text-xs font-bold text-gray-700">접종</h5>
                  {record.treatments?.vaccinations?.map((vaccination, index) => (
                    <div key={index} className="flex justify-between py-1 px-2 bg-primary-50 rounded-lg mb-1 text-xs">
                      <span className="font-medium text-gray-800">{vaccination?.key || ''}</span>
                      <span className="text-gray-600">{vaccination?.value || ''}</span>
                    </div>
                  ))}
                </div>
              )}
              
              {/* 처방 정보가 없는 경우 */}
              {(!record.treatments || 
                !record.treatments.examinations || 
                !record.treatments.medications || 
                !record.treatments.vaccinations ||
                (record.treatments.examinations?.length === 0 && 
                record.treatments.medications?.length === 0 && 
                record.treatments.vaccinations?.length === 0)) && (
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
                {record.pictures?.map((picture, index) => (
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
          
          {/* 아코디언 메뉴 - 수정 내역 */}
          {record.id && (
            <div className="border border-gray-200 rounded-md overflow-hidden">
              {isOriginalRecord ? (
                <div className="p-2 text-xs font-medium text-gray-700 bg-gray-50">
                  이 기록은 원본 기록입니다
                </div>
              ) : (
                <>
                  <button 
                    className="w-full flex justify-between items-center p-2 text-xs font-medium text-gray-700 bg-gray-50 hover:bg-gray-100"
                    onClick={() => setShowHistory(!showHistory)}
                    disabled={!hasHistory}
                  >
                    <span>
                      {hasHistory ? '수정된 기록 (이전 버전 있음)' : '수정된 기록 (최초 수정본)'}
                    </span>
                    {hasHistory && (showHistory ? <FaChevronUp className="h-3 w-3" /> : <FaChevronDown className="h-3 w-3" />)}
                  </button>
                  
                  {showHistory && hasHistory && (
                    <div className="p-2 bg-white border-t border-gray-200">
                      <RecordHistory historyChain={historyChain} />
                    </div>
                  )}
                </>
              )}
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

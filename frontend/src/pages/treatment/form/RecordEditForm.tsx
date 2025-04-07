import React, { useState, useEffect } from 'react';
import { FaSave, FaTimes, FaCamera, FaTrash, FaExclamationTriangle, FaSpinner } from 'react-icons/fa';
import { BlockChainRecord, BlockChainTreatment } from '@/interfaces';
import PrescriptionSection from '@/pages/treatment/form/PrescriptionSection';
import { updateBlockchainTreatment, softDeleteMedicalRecord } from '@/services/treatmentRecordService';
import { uploadImage } from '@/services/treatmentImageService';

/**
 * @module RecordEditForm
 * @file RecordEditForm.tsx
 * @author seonghun
 * @date 2025-04-12
 * @description 진료 기록을 수정하기 위한 폼 컴포넌트
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-12        seonghun           최초 생성
 * 2025-04-22        seonghun           직접 블록체인 업데이트 방식으로 변경
 * 2025-04-25        seonghun           이미지 업로드 및 미리보기 문제 수정
 */

/**
 * RecordEditForm 컴포넌트의 Props 타입 정의
 */
interface RecordEditFormProps {
  record: BlockChainRecord;
  pictures?: string[]; // 별도로 pictures 매개변수 추가
  onSave?: (updatedRecord: BlockChainRecord) => void; // 성공 시 알림용 콜백
  onCancel: () => void;
  doctors?: { id: number; name: string }[];
  petDid?: string;
  blockchainRecords?: BlockChainRecord[]; // 허브-스포크 구조를 위한 전체 기록
}

/**
 * RecordEditForm 컴포넌트
 */
const RecordEditForm: React.FC<RecordEditFormProps> = ({
  record,
  pictures: propsPictures, // 별도로 전달된 pictures 프롭
  onSave,
  onCancel,
  doctors = [],
  petDid,
  blockchainRecords = []
}) => {
  // 폼 상태
  const [diagnosis, setDiagnosis] = useState(record.diagnosis || '');
  const [notes, setNotes] = useState(record.notes || '');
  const [doctorName, setDoctorName] = useState(record.doctorName || '');
  const [prescriptions, setPrescriptions] = useState<BlockChainTreatment>(
    record.treatments || { examinations: [], medications: [], vaccinations: [] }
  );
  
  // 이미지 관련 상태
  const [blobImages, setBlobImages] = useState<string[]>([]); // 미리보기용 Blob URL
  const [imageUrls, setImageUrls] = useState<string[]>(propsPictures || record.pictures || []); // 실제 업로드된 이미지 URL
  const [isUploading, setIsUploading] = useState(false);
  const [loadingFiles, setLoadingFiles] = useState<number>(0); // 업로드 중인 파일 수
  
  // propsPictures가 변경되면 imageUrls 업데이트
  useEffect(() => {
    if (propsPictures) {
      console.log('propsPictures 변경됨:', propsPictures);
      setImageUrls([...propsPictures]);
    }
  }, [propsPictures]);
  
  // 치료완료 체크박스 - 기존 레코드의 상태를 우선적으로 적용하고, 없으면 기본값 true
  const [isFinalTreatment, setIsFinalTreatment] = useState(
    record.status ? record.status === 'COMPLETED' : true
  );
  
  const [hospitalAddress] = useState(record.hospitalAddress || '');
  const [flagCertificated, setFlagCertificated] = useState(record.flagCertificated !== undefined ? record.flagCertificated : true);

  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  
  // 원본 기록 정보
  const [originalRecordInfo, setOriginalRecordInfo] = useState<{
    isOriginal: boolean;
    originalRecordId: string;
    message: string;
  }>({
    isOriginal: false,
    originalRecordId: '',
    message: ''
  });
  
  // 삭제 관련 상태
  const [isDeleting, setIsDeleting] = useState(false);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [deleteError, setDeleteError] = useState<string | null>(null);
  
  // 수정된 데이터를 모니터링
  useEffect(() => {
    // 처방 정보가 변경될 때마다 원본과 비교
    const originalTreatments = record.treatments || { examinations: [], medications: [], vaccinations: [] };
    const changed = JSON.stringify(prescriptions) !== JSON.stringify(originalTreatments);
    
    if (changed) {
      console.log('처방 정보가 변경되었습니다:', {
        original: originalTreatments,
        updated: prescriptions
      });
    }
  }, [prescriptions, record.treatments]);
  
  // 원본 기록 정보 찾기
  useEffect(() => {
    // 기록이 원본인지 수정본인지 확인
    const isOriginal = record.id?.startsWith('medical_record_') || false;
    let originalRecordId = '';
    let message = '';
    
    if (isOriginal) {
      // 현재 기록이 원본인 경우
      originalRecordId = record.id || '';
      message = '원본 기록을 수정합니다.';
    } else if (record.previousRecord) {
      // 수정본이고 previousRecord 필드가 있는 경우
      originalRecordId = record.previousRecord;
      message = '수정된 기록을 다시 수정합니다.';
    } else {
      // 기록이 원본이 아니고 previousRecord도 없는 경우
      // blockchainRecords에서 원본 기록 찾기 시도
      const originalRecord = blockchainRecords.find(r => 
        r.id?.startsWith('medical_record_') && 
        r.status === record.status && 
        r.timestamp <= record.timestamp
      );
      
      if (originalRecord?.id) {
        originalRecordId = originalRecord.id;
        message = '원본 기록을 찾았습니다. 같은 상태의 이전 기록입니다.';
      } else {
        message = '원본 기록을 찾을 수 없습니다. Hub-Spoke 구조에서는 원본 기록이 필요합니다.';
      }
    }
    
    setOriginalRecordInfo({
      isOriginal,
      originalRecordId,
      message
    });
    
    console.log('원본 기록 정보:', {
      isOriginal,
      originalRecordId,
      message
    });
  }, [record, blockchainRecords]);
  
  /**
   * 알림 메시지 표시
   */
  const showMessage = (message: string, isError: boolean) => {
    if (isError) {
      setError(message);
      setSuccessMessage(null);
    } else {
      setSuccessMessage(message);
      setError(null);
    }
    
    // 3초 후 메시지 숨기기
    setTimeout(() => {
      if (isError) {
        setError(null);
      } else {
        setSuccessMessage(null);
      }
    }, 3000);
  };
  
  /**
   * 이미지 파일 선택 핸들러
   */
  const handleFileChange = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files || files.length === 0) return;

    setIsUploading(true);
    setError(null);
    setLoadingFiles(files.length);
    
    console.log('업로드 시작: 파일 개수', files.length);
    
    // 임시 미리보기 URL 생성
    const newBlobUrls: string[] = [];
    for (let i = 0; i < files.length; i++) {
      const blobUrl = URL.createObjectURL(files[i]);
      newBlobUrls.push(blobUrl);
    }
    
    // 미리보기 상태 업데이트
    setBlobImages(prev => [...prev, ...newBlobUrls]);
    
    try {
      // 각 파일을 순차적으로 업로드
      for (let i = 0; i < files.length; i++) {
        const file = files[i];
        try {
          console.log(`파일 업로드 시작: ${file.name}, 크기: ${file.size}바이트`);
          
          // API로 사진 업로드
          const imageUrl = await uploadImage(file, 'treatment');
          
          if (imageUrl) {
            // 반환된 URL을 상태에 추가
            setImageUrls(prev => [...prev, imageUrl]);
            console.log('이미지 URL 추가됨:', imageUrl);
          } else {
            // 업로드 실패 시 해당 미리보기 제거
            setBlobImages(prev => prev.filter(url => url !== newBlobUrls[i]));
            URL.revokeObjectURL(newBlobUrls[i]);
            showMessage(`파일 업로드 실패: ${file.name}`, true);
          }
        } catch (error: any) {
          console.error(`파일 업로드 실패: ${file.name}`, error);
          // 업로드 실패 시 해당 미리보기 제거
          setBlobImages(prev => prev.filter(url => url !== newBlobUrls[i]));
          URL.revokeObjectURL(newBlobUrls[i]);
          showMessage(`파일 업로드 실패: ${file.name}`, true);
        } finally {
          // 로딩 카운터 감소
          setLoadingFiles(prev => prev - 1);
        }
      }
    } catch (err: any) {
      console.error('이미지 업로드 오류:', err);
      // 오류 발생 시 모든 임시 URL 해제
      newBlobUrls.forEach(url => URL.revokeObjectURL(url));
      showMessage('이미지 업로드 중 오류가 발생했습니다', true);
    } finally {
      setIsUploading(false);
      
      // 파일 입력 초기화
      if (event.target) {
        event.target.value = '';
      }
    }
  };

  /**
   * 이미지 제거 핸들러
   */
  const handleRemoveImage = (index: number) => {
    // 미리보기 URL이 있으면 해제
    if (blobImages[index]) {
      URL.revokeObjectURL(blobImages[index]);
    }
    
    // 미리보기와 업로드된 URL 모두 제거
    setBlobImages(prev => prev.filter((_, i) => i !== index));
    setImageUrls(prev => prev.filter((_, i) => i !== index));
    
    console.log(`이미지 ${index} 제거됨`);
  };
  
  // 삭제 버튼 클릭 핸들러
  const handleDeleteButtonClick = () => {
    setShowDeleteConfirm(true);
  };
  
  // 레코드 삭제 핸들러
  const handleDelete = async () => {
    const recordPetDid = record.petDid || petDid;
    
    if (!recordPetDid || !record.id) {
      setDeleteError('삭제할 진료 기록 정보가 부족합니다.');
      return;
    }
    
    try {
      setIsDeleting(true);
      setDeleteError(null);
      
      const result = await softDeleteMedicalRecord(recordPetDid, record.id);
      
      if (result.success) {
        // 삭제 성공 시 폼 닫기
        onCancel();
      } else {
        setDeleteError(result.error || '삭제 중 오류가 발생했습니다.');
      }
    } catch (err: any) {
      setDeleteError(err.message || '삭제 중 오류가 발생했습니다.');
    } finally {
      setIsDeleting(false);
      setShowDeleteConfirm(false);
    }
  };
  
  // 저장 핸들러
  const handleSave = async () => {
    try {
      setIsLoading(true);
      setError(null);
      
      // 진단명 필수 체크
      if (!diagnosis.trim()) {
        setError('진단명을 입력해주세요.');
        setIsLoading(false);
        return;
      }
      
      // 원본 기록 ID 확인
      if (!originalRecordInfo.originalRecordId) {
        setError('원본 기록을 찾을 수 없습니다. Hub-Spoke 구조에서는 원본 기록이 필요합니다.');
        setIsLoading(false);
        return;
      }
      
      // 업로드 중인 이미지가 있는지 확인
      if (loadingFiles > 0 || isUploading) {
        setError('이미지 업로드가 완료될 때까지 기다려주세요.');
        setIsLoading(false);
        return;
      }
      
      console.log('==== 저장 시점 이미지 정보 ====');
      console.log('이미지 URL 배열:', imageUrls);
      console.log('이미지 배열 길이:', imageUrls.length);
      
      // 업데이트된 레코드 생성
      const updatedRecord: BlockChainRecord = {
        ...record,
        diagnosis,
        doctorName,
        notes: notes,
        treatments: prescriptions,
        pictures: imageUrls, // 로컬 상태의 이미지 URL 사용
        hospitalAddress,
        petDid: record.petDid || petDid,
        status: isFinalTreatment ? 'COMPLETED' : 'IN_PROGRESS',
        flagCertificated,
        previousRecord: originalRecordInfo.originalRecordId
      };
      
      console.log('레코드 업데이트 직전 상태:', {
        pictures: updatedRecord.pictures,
        hasPictures: !!updatedRecord.pictures,
        picturesLength: updatedRecord.pictures ? updatedRecord.pictures.length : 0,
        picturesIsArray: Array.isArray(updatedRecord.pictures)
      });
      
      // 직접 블록체인 업데이트 요청
      const result = await updateBlockchainTreatment(
        updatedRecord.petDid!,
        updatedRecord
      );
      
      if (result.success) {
        console.log('블록체인 업데이트 성공! 전송된 이미지 정보:', updatedRecord.pictures);
        showMessage('진료 기록이 성공적으로 수정되었습니다', false);
        
        // 성공 시 상위 컴포넌트에 알림 (있는 경우)
        if (onSave) {
          // 최종 업데이트된 레코드 전달 - pictures 변경 사항 유지
          onSave(updatedRecord);
        }
        
        // 폼 닫기 (성공 메시지 표시 후)
        setTimeout(() => {
          onCancel();
        }, 1500);
      } else {
        console.error('블록체인 업데이트 실패:', result.error);
        showMessage(result.error || '진료 기록 수정 중 오류가 발생했습니다', true);
      }
    } catch (err: any) {
      showMessage(err.message || '진료 기록 수정 중 오류가 발생했습니다', true);
    } finally {
      setIsLoading(false);
    }
  };

  // 컴포넌트 언마운트 시 생성한 모든 blob URL 해제
  useEffect(() => {
    return () => {
      blobImages.forEach(url => URL.revokeObjectURL(url));
    };
  }, []);

  return (
    <div className="w-[350px] bg-white rounded-md border border-gray-200 h-full flex flex-col">
      <div className="p-3 border-b border-gray-200 bg-primary-50 flex justify-between items-center flex-shrink-0">
        <h3 className="text-sm font-semibold text-gray-800">진료 기록 수정</h3>
        <button 
          onClick={onCancel}
          className="text-gray-500 hover:text-gray-700"
          disabled={isLoading || isDeleting}
        >
          <FaTimes />
        </button>
      </div>
      
      <div className="p-4 overflow-y-auto flex-1">
        {/* 성공 메시지 */}
        {successMessage && (
          <div className="mb-4 p-2 bg-green-50 border border-green-200 rounded-md text-xs text-green-600">
            {successMessage}
          </div>
        )}
        
        {/* 오류 메시지 */}
        {error && (
          <div className="mb-4 p-2 bg-red-50 border border-red-200 rounded-md text-xs text-red-600">
            {error}
          </div>
        )}
        
        {/* 삭제 오류 메시지 */}
        {deleteError && (
          <div className="mb-4 p-2 bg-red-50 border border-red-200 rounded-md text-xs text-red-600">
            {deleteError}
          </div>
        )}
        
        {/* 원본 기록 정보 */}
        {originalRecordInfo.message && (
          <div className={`mb-4 p-2 rounded-md text-xs ${originalRecordInfo.originalRecordId ? 'bg-blue-50 border border-blue-200 text-blue-600' : 'bg-yellow-50 border border-yellow-200 text-yellow-600'}`}>
            {originalRecordInfo.message}
          </div>
        )}
        
        {/* 진단명 입력 */}
        <div className="mb-4">
          <label className="block text-xs font-medium text-gray-700 mb-1">
            진단명
          </label>
          <input
            type="text"
            value={diagnosis}
            onChange={(e) => setDiagnosis(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md text-xs focus:outline-none focus:ring-2 focus:ring-primary-500"
            disabled={isLoading || isDeleting}
          />
        </div>
        
        {/* 담당의 입력 - 의사 목록 있는 경우 선택, 없는 경우 직접 입력 */}
        <div className="mb-4">
          <label className="block text-xs font-medium text-gray-700 mb-1">
            담당의
          </label>
          {doctors && doctors.length > 0 ? (
            <select
              value={doctorName}
              onChange={(e) => setDoctorName(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md text-xs focus:outline-none focus:ring-2 focus:ring-primary-500"
              disabled={isLoading || isDeleting}
            >
              <option value="">선택하세요</option>
              {doctors.map((doctor) => (
                <option key={doctor.id} value={doctor.name}>{doctor.name}</option>
              ))}
              <option value="직접입력">직접 입력</option>
            </select>
          ) : (
            <input
              type="text"
              value={doctorName}
              onChange={(e) => setDoctorName(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md text-xs focus:outline-none focus:ring-2 focus:ring-primary-500"
              disabled={isLoading || isDeleting}
            />
          )}
          {/* 직접 입력 선택 시 입력 필드 표시 */}
          {doctorName === '직접입력' && (
            <input
              type="text"
              value=""
              onChange={(e) => setDoctorName(e.target.value)}
              className="w-full mt-2 px-3 py-2 border border-gray-300 rounded-md text-xs focus:outline-none focus:ring-2 focus:ring-primary-500"
              placeholder="담당의 이름 직접 입력"
              disabled={isLoading || isDeleting}
            />
          )}
        </div>
        
        {/* 노트 입력 */}
        <div className="mb-4">
          <label className="block text-xs font-medium text-gray-700 mb-1">
            진료 노트
          </label>
          <textarea
            value={notes}
            onChange={(e) => setNotes(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md text-xs h-24 focus:outline-none focus:ring-2 focus:ring-primary-500"
            disabled={isLoading || isDeleting}
          />
        </div>
        
        {/* 최종 진료 체크박스 */}
        <div className="mb-4">
          <label className="flex items-center cursor-pointer">
            <input
              type="checkbox"
              checked={isFinalTreatment}
              onChange={() => setIsFinalTreatment(prev => !prev)}
              className="mr-2 h-4 w-4 text-primary-500 focus:ring-primary-400 border-gray-300 rounded"
              disabled={isLoading || isDeleting}
            />
            <span className="text-xs font-medium text-gray-700">
              최종 진료로 표시 (치료 완료)
            </span>
          </label>
          {isFinalTreatment && (
            <p className="text-xs text-gray-500 mt-1 ml-6">
              * 이 옵션을 선택하면 치료가 완료된 것으로 간주합니다.
            </p>
          )}
        </div>
        
        {/* 처방 정보 수정 */}
        <div className="mb-4 flex flex-col flex-1">
          <label className="block text-xs font-medium text-gray-700 mb-1">
            처방 정보
          </label>
          <div className="flex-1">
            <PrescriptionSection
              prescriptions={prescriptions}
              setPrescriptions={setPrescriptions}
              petSpecies={(record as any).petSpecies || (record as any).petBreed || ''}
            />
          </div>
        </div>
        
        {/* 사진 업로드 섹션 */}
        <div className="mb-4">
          <label className="block text-xs font-medium text-gray-700 mb-1">
            진료 사진
          </label>
          <div className="flex flex-col gap-2 mt-2">
            <div className="flex items-center">
              <input
                type="file"
                id="photo-upload"
                accept="image/*"
                multiple
                onChange={handleFileChange}
                className="hidden"
                disabled={isLoading || isDeleting || isUploading}
              />
              <label
                htmlFor="photo-upload"
                className={`flex items-center justify-center px-3 py-2 border border-gray-300 rounded-md text-xs text-gray-700 hover:bg-gray-50 mr-2 ${isUploading ? 'opacity-50 cursor-not-allowed' : 'cursor-pointer'}`}
              >
                {isUploading ? (
                  <><FaSpinner className="text-gray-400 animate-spin mr-1" /> 업로드 중...</>
                ) : (
                  <><FaCamera className="text-gray-400 mr-1" /> 사진 선택</>
                )}
              </label>
              <span className="text-xs text-gray-500">{imageUrls.length}개 이미지</span>
            </div>
            
            {/* 업로드된 URL 목록 표시 */}
            {imageUrls.length > 0 && (
              <div className="border border-gray-200 rounded-md p-2 bg-gray-50">
                <p className="text-xs font-medium text-gray-700 mb-1">업로드된 이미지:</p>
                <div className="flex flex-wrap gap-2">
                  {imageUrls.map((url, index) => (
                    <div key={`image-${index}`} className="relative">
                      <img 
                        src={url} 
                        alt={`진료 이미지 ${index+1}`} 
                        className="w-16 h-16 object-cover rounded-md border border-gray-200"
                      />
                      <button
                        type="button"
                        onClick={() => handleRemoveImage(index)}
                        className="absolute -top-1 -right-1 bg-red-500 hover:bg-red-600 text-white rounded-full p-1 shadow-sm"
                        title="이미지 삭제"
                        disabled={isLoading || isDeleting}
                      >
                        <FaTimes size={10} />
                      </button>
                    </div>
                  ))}
                </div>
              </div>
            )}
            
            {/* 이미지 업로드 상태 표시 */}
            {isUploading && (
              <p className="text-xs text-blue-600 mt-2 flex items-center">
                <FaSpinner className="animate-spin mr-1" />
                이미지 업로드 중... {loadingFiles > 0 ? `(${loadingFiles}개 남음)` : '완료 중'}
              </p>
            )}
          </div>
        </div>
        
        {/* 병원 인증 체크박스 */}
        <div className="mb-4 flex items-center">
          <input
            type="checkbox"
            id="hospital-cert-checkbox"
            checked={flagCertificated}
            onChange={() => setFlagCertificated(prev => !prev)}
            className="mr-2 h-4 w-4 text-primary-500 focus:ring-primary-400 border-gray-300 rounded"
            disabled={isLoading || isDeleting}
          />
          <label htmlFor="hospital-cert-checkbox" className="text-xs text-gray-700 flex items-center">
            <span className={`${flagCertificated ? 'text-primary-600 font-medium' : 'text-gray-700'}`}>
              병원 인증 여부
            </span>
            {flagCertificated && (
              <span className="ml-1 text-[10px] bg-primary-100 text-primary-600 px-1.5 py-0.5 rounded-full">
                인증됨
              </span>
            )}
          </label>
        </div>
        
        {/* 버튼 그룹 */}
        <div className="flex justify-end gap-2 mt-4 flex-shrink-0">
          <button
            type="button"
            onClick={onCancel}
            className="px-3 py-1.5 border border-gray-300 rounded-md text-xs text-gray-700 hover:bg-gray-50"
            disabled={isLoading || isDeleting}
          >
            취소
          </button>
          
          {/* 삭제 버튼 */}
          <button
            type="button"
            onClick={handleDeleteButtonClick}
            className="px-3 py-1.5 bg-red-600 border border-red-600 rounded-md text-xs text-white hover:bg-red-700 flex items-center gap-1"
            disabled={isLoading || isDeleting}
          >
            {isDeleting ? (
              <span className="flex items-center gap-1">
                <FaSpinner className="animate-spin h-3 w-3" />
                삭제 중...
              </span>
            ) : (
              <span className="flex items-center gap-1">
                <FaTrash className="h-3 w-3" />
                삭제
              </span>
            )}
          </button>
          
          {/* 저장 버튼 */}
          <button
            type="button"
            onClick={handleSave}
            className={`px-3 py-1.5 ${(!originalRecordInfo.originalRecordId || loadingFiles > 0) ? 'bg-gray-500 cursor-not-allowed' : 'bg-primary-600 hover:bg-primary-700'} border border-primary-600 rounded-md text-xs text-white flex items-center gap-1`}
            disabled={isLoading || isDeleting || !originalRecordInfo.originalRecordId || loadingFiles > 0}
          >
            {isLoading ? (
              <span className="flex items-center gap-1">
                <FaSpinner className="animate-spin h-3 w-3" />
                저장 중...
              </span>
            ) : (
              <span className="flex items-center gap-1">
                <FaSave className="h-3 w-3" />
                저장
              </span>
            )}
          </button>
        </div>
      </div>
      
      {/* 삭제 확인 모달 */}
      {showDeleteConfirm && (
        <div className="fixed inset-0 flex items-center justify-center bg-black bg-opacity-50 z-50">
          <div className="bg-white rounded-lg p-6 max-w-md w-full mx-4">
            <div className="flex items-center text-red-600 mb-4">
              <FaExclamationTriangle className="h-6 w-6 mr-2" />
              <h3 className="text-lg font-semibold">진료 기록 삭제 확인</h3>
            </div>
            
            <p className="text-gray-700 mb-2">
              이 진료 기록을 정말 삭제하시겠습니까?
            </p>
            
            <p className="text-red-600 text-sm mb-4 font-medium">
              삭제된 기록은 복구할 수 없습니다.
            </p>
            
            <div className="flex justify-end gap-2">
              <button
                onClick={() => setShowDeleteConfirm(false)}
                className="px-4 py-2 border border-gray-300 rounded text-gray-700 text-sm hover:bg-gray-100"
                disabled={isDeleting}
              >
                취소
              </button>
              
              <button
                onClick={handleDelete}
                className="px-4 py-2 bg-red-600 rounded text-white text-sm hover:bg-red-700"
                disabled={isDeleting}
              >
                {isDeleting ? '삭제 중...' : '삭제'}
              </button>
            </div>
          </div>
        </div>
      )}
    </div>
  );
};

export default RecordEditForm;
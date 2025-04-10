import React, { useState, useEffect } from 'react';
import { BlockChainRecord, BlockChainTreatment } from '@/interfaces';
import { FaSave, FaTimes, FaCamera, FaTrash, FaExclamationTriangle, FaSpinner } from 'react-icons/fa';
import PrescriptionSection from '@/pages/treatment/form/PrescriptionSection';
import { getAccountAddress } from '@/services/blockchainAuthService';
import { softDeleteMedicalRecord, updateBlockchainTreatment } from '@/services/treatmentRecordService';
import { uploadImage } from '@/services/treatmentImageService';

/**
 * @component RecordByOwnerEditForm
 * @file RecordByOwnerEditForm.tsx
 * @author assistant
 * @date 2025-04-10
 * @description 보호자가 작성한 진료 기록(flagCertificated=false) 수정을 위한 폼 컴포넌트입니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-10        assistant        최초 생성 - 보호자 작성 기록을 위한 수정 폼 컴포넌트
 * 2025-04-22        seonghun         직접 블록체인 업데이트 방식으로 변경
 */

/**
 * RecordByOwnerEditForm 컴포넌트의 Props 타입 정의
 */
interface RecordByOwnerEditFormProps {
  record: BlockChainRecord;
  onSave?: (updatedRecord: BlockChainRecord) => void; // 성공 시 알림용 콜백
  onCancel: () => void;
  petDid?: string;
}

/**
 * 보호자가 작성한 진료 기록 수정을 위한 폼 컴포넌트
 */
const RecordByOwnerEditForm: React.FC<RecordByOwnerEditFormProps> = ({ 
  record, 
  onSave, 
  onCancel,
  petDid
}) => {
  // 폼 상태
  const [diagnosis, setDiagnosis] = useState(record.diagnosis || '');
  const [notes, setNotes] = useState(record.notes || '');
  const [isFinalTreatment, setIsFinalTreatment] = useState(
    record.status === 'COMPLETED' || false
  );
  const [doctorName, setDoctorName] = useState(record.doctorName || '');
  const [hospitalName, setHospitalName] = useState(record.hospitalName || '');
  const [prescriptions, setPrescriptions] = useState<BlockChainTreatment>(
    record.treatments || { examinations: [], medications: [], vaccinations: [] }
  );
  
  // 이미지 관련 상태
  const [previewImages, setPreviewImages] = useState<string[]>([]); // 로컬 미리보기 Blob URL
  const [uploadedImageUrls, setUploadedImageUrls] = useState<string[]>(record.pictures || []); // 최종 S3 URL 목록
  const [isUploading, setIsUploading] = useState(false); // 업로드 진행 상태
  
  const [hospitalAddress, setHospitalAddress] = useState(record.hospitalAddress || '');
  
  // 병원 인증 상태는 항상 false로 유지 (보호자 작성 기록)
  const [flagCertificated, setFlagCertificated] = useState(false);
  
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);
  
  // 삭제 관련 상태
  const [isDeleting, setIsDeleting] = useState(false);
  const [showDeleteConfirm, setShowDeleteConfirm] = useState(false);
  const [deleteError, setDeleteError] = useState<string | null>(null);
  
  // 계정 주소 가져오기
  useEffect(() => {
    const fetchAccountAddress = async () => {
      try {
        const address = await getAccountAddress();
        if (address) {
          setHospitalAddress(address);
        }
      } catch (error) {
        console.error('계정 주소 가져오기 실패:', error);
      }
    };
    
    if (!record.hospitalAddress) {
      fetchAccountAddress();
    }
  }, [record.hospitalAddress]);
  
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
    const newPreviewUrls: string[] = [];

    // Blob URL 생성 및 미리보기 상태 업데이트
    for (const file of files) {
      const blobUrl = URL.createObjectURL(file);
      newPreviewUrls.push(blobUrl);
    }
    setPreviewImages(prev => [...prev, ...newPreviewUrls]);

    // 파일 업로드
    const uploadPromises = Array.from(files).map(async (file, index) => {
      const blobUrl = newPreviewUrls[index];
      try {
        const s3Url = await uploadImage(file, 'treatment');
        if (s3Url) {
          // 성공 시 S3 URL 추가 및 미리보기 제거
          setUploadedImageUrls(prev => [...prev, s3Url]);
          setPreviewImages(prev => prev.filter(url => url !== blobUrl));
          URL.revokeObjectURL(blobUrl);
        } else {
          throw new Error(`'${file.name}' 업로드 실패`);
        }
      } catch (error: any) {
        console.error('이미지 업로드 오류:', error);
        showMessage(error.message || '이미지 업로드 중 오류 발생', true);
        // 실패 시 미리보기 제거
        setPreviewImages(prev => prev.filter(url => url !== blobUrl));
        URL.revokeObjectURL(blobUrl);
      }
    });

    await Promise.all(uploadPromises);
    setIsUploading(false);
  };
  
  /**
   * 이미지 제거 핸들러
   * @param index 제거할 이미지의 인덱스
   * @param type 'preview' 또는 'uploaded'
   */
  const handleRemoveImage = (index: number, type: 'preview' | 'uploaded') => {
    if (type === 'preview') {
      const urlToRemove = previewImages[index];
      setPreviewImages(prev => prev.filter((_, i) => i !== index));
      URL.revokeObjectURL(urlToRemove);
    } else if (type === 'uploaded') {
      setUploadedImageUrls(prev => prev.filter((_, i) => i !== index));
    }
  };
  
  // 삭제 버튼 클릭 핸들러
  const handleDeleteButtonClick = () => {
    console.log('삭제 버튼 클릭됨');
    console.log('기록 정보:', { id: record.id, petDid: record.petDid });
    setShowDeleteConfirm(true);
  };
  
  /**
   * 진료 기록 삭제 핸들러
   */
  const handleDelete = async () => {
    console.log('삭제 확인 버튼 클릭됨');
    const recordPetDid = record.petDid || petDid;
    console.log('삭제할 기록 정보:', { id: record.id, petDid: recordPetDid });
    
    if (!recordPetDid || !record.id) {
      console.error('삭제 실패: 필수 정보 누락', { petDid: recordPetDid, id: record.id });
      setDeleteError('삭제할 진료 기록 정보가 부족합니다.');
      return;
    }
    
    try {
      setIsDeleting(true);
      setDeleteError(null);
      
      console.log('softDeleteMedicalRecord 함수 호출 직전', { petDid: recordPetDid, recordKey: record.id });
      
      const result = await softDeleteMedicalRecord(recordPetDid, record.id);
      console.log('softDeleteMedicalRecord 함수 반환 결과:', result);
      
      if (result.success) {
        console.log('삭제 성공, 폼 닫기 시도');
        // 삭제 성공 시 폼 닫기
        onCancel();
      } else {
        console.error('삭제 실패:', result.error);
        setDeleteError(result.error || '삭제 중 오류가 발생했습니다.');
      }
    } catch (err: any) {
      console.error('삭제 중 예외 발생:', err);
      setDeleteError(err.message || '삭제 중 오류가 발생했습니다.');
    } finally {
      setIsDeleting(false);
      setShowDeleteConfirm(false);
      console.log('삭제 프로세스 완료');
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
      
      // 병원명 필수 체크
      if (!hospitalName.trim()) {
        setError('병원명을 입력해주세요.');
        setIsLoading(false);
        return;
      }
      
      // 업데이트된 레코드 생성
      const updatedRecord: BlockChainRecord = {
        ...record,
        diagnosis,
        doctorName,
        hospitalName,
        notes: notes,
        treatments: prescriptions,
        pictures: uploadedImageUrls, // S3 이미지 URL 배열 사용
        hospitalAddress,
        petDid: record.petDid || petDid,
        status: isFinalTreatment ? 'COMPLETED' : 'IN_PROGRESS',
        flagCertificated: flagCertificated // 체크박스 상태에 따라 병원 인증 여부 설정
      };
      
      // 직접 블록체인 업데이트 요청
      const result = await updateBlockchainTreatment(
        updatedRecord.petDid!,
        updatedRecord
      );
      
      if (result.success) {
        showMessage('진료 기록이 성공적으로 수정되었습니다', false);
        
        // 성공 시 상위 컴포넌트에 알림 (있는 경우)
        if (onSave) {
          try {
            await onSave(updatedRecord);
            console.log('상위 컴포넌트 onSave 콜백 완료');
            
            // 폼 닫기 (onSave 콜백 완료 후)
            onCancel();
          } catch (callbackError) {
            console.error('onSave 콜백 실행 중 오류:', callbackError);
            // 오류가 있어도 성공 메시지는 표시 (블록체인에는 이미 저장됨)
          }
        } else {
          // onSave 콜백이 없는 경우 1.5초 후 폼 닫기
          setTimeout(() => {
            onCancel();
          }, 1500);
        }
      } else {
        showMessage(result.error || '진료 기록 수정 중 오류가 발생했습니다', true);
      }
    } catch (err: any) {
      showMessage(err.message || '저장 중 오류가 발생했습니다.', true);
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="w-[350px] bg-white rounded-md border border-gray-200 h-full flex flex-col">
      <div className="p-3 border-b border-gray-200 bg-primary-50 flex justify-between items-center flex-shrink-0">
        <h3 className="text-sm font-semibold text-gray-800">보호자 작성 기록 수정</h3>
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
        
        {/* 병원명 입력 - 보호자 기록에서는 직접 입력 가능 */}
        <div className="mb-4">
          <label className="block text-xs font-medium text-gray-700 mb-1">
            병원명
          </label>
          <input
            type="text"
            value={hospitalName}
            onChange={(e) => setHospitalName(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md text-xs focus:outline-none focus:ring-2 focus:ring-primary-500"
            disabled={isLoading || isDeleting}
          />
        </div>
        
        {/* 담당의 입력 - 보호자 기록에서는 직접 입력 가능 */}
        <div className="mb-4">
          <label className="block text-xs font-medium text-gray-700 mb-1">
            담당의
          </label>
          <input
            type="text"
            value={doctorName}
            onChange={(e) => setDoctorName(e.target.value)}
            className="w-full px-3 py-2 border border-gray-300 rounded-md text-xs focus:outline-none focus:ring-2 focus:ring-primary-500"
            disabled={isLoading || isDeleting}
          />
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
          <div className="flex flex-wrap gap-2 mt-2">
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
              className={`flex items-center justify-center w-16 h-16 border border-dashed border-gray-300 rounded-md cursor-pointer hover:bg-gray-50 ${isUploading ? 'opacity-50 cursor-not-allowed' : ''}`}
            >
              {isUploading ? (
                <FaSpinner className="text-gray-400 animate-spin" />
              ) : (
                <FaCamera className="text-gray-400" />
              )}
            </label>
            
            {/* S3 업로드 완료된 이미지 미리보기 */}
            {uploadedImageUrls.map((pic, index) => (
              <div key={`uploaded-${index}`} className="relative w-16 h-16">
                <img 
                  src={pic} 
                  alt={`진료 사진 ${index + 1}`}
                  className="w-full h-full object-cover rounded-md"
                />
                <button
                  type="button"
                  onClick={() => handleRemoveImage(index, 'uploaded')}
                  className="absolute -top-1 -right-1 bg-red-500 text-white rounded-full p-1 w-5 h-5 flex items-center justify-center text-xs"
                  disabled={isLoading || isDeleting}
                >
                  x
                </button>
              </div>
            ))}
            
            {/* 로컬 미리보기 (업로드 중) */}
            {previewImages.map((pic, index) => (
              <div key={`preview-${index}`} className="relative w-16 h-16">
                <img 
                  src={pic} 
                  alt={`미리보기 ${index + 1}`}
                  className="w-full h-full object-cover rounded-md opacity-70"
                />
                <div className="absolute inset-0 bg-black bg-opacity-40 flex items-center justify-center">
                  <FaSpinner className="text-white animate-spin" />
                </div>
                <button
                  type="button"
                  onClick={() => handleRemoveImage(index, 'preview')}
                  className="absolute -top-1 -right-1 bg-gray-500 text-white rounded-full p-1 w-5 h-5 flex items-center justify-center text-xs"
                  disabled={isLoading || isDeleting}
                >
                  x
                </button>
              </div>
            ))}
          </div>
        </div>
        
        {/* 보호자 기록 알림 */}
        <div className="mb-4 p-2 bg-yellow-50 border border-yellow-200 rounded-md">
          <p className="text-xs text-yellow-700">
            이 기록은 보호자가 직접 작성한 기록으로, 병원 인증을 받지 않았습니다.
          </p>
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
              병원 인증으로 변경
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
            className="px-3 py-1.5 bg-primary-600 border border-primary-600 rounded-md text-xs text-white hover:bg-primary-700 flex items-center gap-1"
            disabled={isLoading || isDeleting}
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
                onClick={() => {
                  console.log('삭제 취소 버튼 클릭');
                  setShowDeleteConfirm(false);
                }}
                className="px-4 py-2 border border-gray-300 rounded text-gray-700 text-sm hover:bg-gray-100"
                disabled={isDeleting}
              >
                취소
              </button>
              
              <button
                onClick={() => {
                  console.log('모달 내 삭제 확인 버튼 클릭');
                  handleDelete();
                }}
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

export default RecordByOwnerEditForm;

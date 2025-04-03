import React, { useState, useEffect } from 'react';
import { BlockChainRecord, BlockChainTreatment, TreatmentType } from '@/interfaces';
import { FaSave, FaTimes, FaCamera, FaTrash } from 'react-icons/fa';
import PrescriptionSection from '@/pages/treatment/form/PrescriptionSection';
// import { useSelector } from 'react-redux';
// import { RootState } from '@/redux/store';
import { getAccountAddress } from '@/services/blockchainAuthService';
import { getRecordChanges } from '@/services/treatmentService';

/**
 * @component RecordEditForm
 * @file RecordEditForm.tsx
 * @author seonghun
 * @date 2025-04-02
 * @description 진료 기록 수정을 위한 폼 컴포넌트입니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-02        seonghun        최초 생성
 * 2025-04-03        seonghun        컴포넌트 개선 및 모든 필드 수정 가능하도록 수정
 * 2025-04-03        seonghun        처방 정보 수정 시 너비 개선
 */

/**
 * RecordEditForm 컴포넌트의 Props 타입 정의
 */
interface RecordEditFormProps {
  record: BlockChainRecord;
  onSave: (updatedRecord: BlockChainRecord, changes: any[]) => Promise<void>;
  onCancel: () => void;
  doctors?: { id: number; name: string }[];
}

/**
 * 진료 기록 수정을 위한 폼 컴포넌트
 */
const RecordEditForm: React.FC<RecordEditFormProps> = ({ 
  record, 
  onSave, 
  onCancel,
  doctors = []
}) => {
  // 폼 상태
  const [diagnosis, setDiagnosis] = useState(record.diagnosis || '');
  const [notes, setNotes] = useState(record.notes || '');
  const [isFinalTreatment, setIsFinalTreatment] = useState(
    record.status === 'COMPLETED' || false
  );
  const [doctorName, setDoctorName] = useState(record.doctorName || '');
  const [prescriptions, setPrescriptions] = useState<BlockChainTreatment>(
    record.treatments || { examinations: [], medications: [], vaccinations: [] }
  );
  const [pictures, setPictures] = useState<string[]>(record.pictures || []);
  const [prescriptionType, setPrescriptionType] = useState('');
  const [prescriptionDosage, setPrescriptionDosage] = useState('');
  const [treatmentType, setTreatmentType] = useState<TreatmentType>(TreatmentType.EXAMINATION);
  const [hospitalAddress, setHospitalAddress] = useState(record.hospitalAddress || '');
  
  const [isLoading, setIsLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  
  // // Redux에서 병원 정보 가져오기
  // const { hospital } = useSelector((state: RootState) => state.auth);
  
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
   * 이미지 업로드 핸들러
   */
  const handleImageUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (files) {
      // FileReader를 사용하여 각 파일을 base64 문자열로 변환
      Array.from(files).forEach(file => {
        const reader = new FileReader();
        reader.onloadend = () => {
          // reader.result는 base64 인코딩된 문자열
          if (typeof reader.result === 'string') {
            setPictures(prev => [...prev, reader.result as string]);
          }
        };
        reader.readAsDataURL(file);
      });
    }
  };
  
  /**
   * 이미지 삭제 핸들러
   */
  const removeImage = (index: number) => {
    setPictures(prev => prev.filter((_, i) => i !== index));
  };
  
  
  // 수정된 데이터를 모니터링
  useEffect(() => {
    // 처방 정보가 변경될 때마다 원본과 비교
    const originalExams = JSON.stringify(record.treatments?.examinations || []);
    const newExams = JSON.stringify(prescriptions.examinations || []);
    const originalMeds = JSON.stringify(record.treatments?.medications || []);
    const newMeds = JSON.stringify(prescriptions.medications || []);
    const originalVacs = JSON.stringify(record.treatments?.vaccinations || []);
    const newVacs = JSON.stringify(prescriptions.vaccinations || []);
    
    const examsChanged = originalExams !== newExams;
    const medsChanged = originalMeds !== newMeds;
    const vacsChanged = originalVacs !== newVacs;
    
    if (examsChanged || medsChanged || vacsChanged) {
      console.log('처방 정보 변경 감지:', {
        examsChanged,
        medsChanged,
        vacsChanged,
        originalExams,
        newExams,
        originalMeds,
        newMeds,
        originalVacs,
        newVacs
      });
    }
  }, [prescriptions, record.treatments]);
  
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
      
      // 업데이트된 레코드 생성
      const updatedRecord: BlockChainRecord = {
        ...record,
        diagnosis,
        doctorName,
        notes: notes,
        treatments: prescriptions,
        pictures,
        hospitalAddress,
        petDid: record.petDid,
        status: isFinalTreatment ? 'COMPLETED' : 'IN_PROGRESS'
      };
      
      // 원본 레코드와 비교하여 변경 사항 감지
      const changes = getRecordChanges(record, updatedRecord);
      
      if (changes.length === 0) {
        setError('변경된 내용이 없습니다. 적어도 하나 이상의 필드를 수정해주세요.');
        setIsLoading(false);
        return;
      }
      
      console.log('변경 내역:', changes);
      
      // 저장 콜백 호출 (감지된 변경 사항 전달)
      await onSave(updatedRecord, changes);
    } catch (err: any) {
      setError(err.message || '저장 중 오류가 발생했습니다.');
    } finally {
      setIsLoading(false);
    }
  };

  return (
    <div className="w-[350px] bg-white rounded-md border border-gray-200 h-full flex flex-col">
      <div className="p-3 border-b border-gray-200 bg-primary-50 flex justify-between items-center flex-shrink-0">
        <h3 className="text-sm font-semibold text-gray-800">진료 기록 수정</h3>
        <button 
          onClick={onCancel}
          className="text-gray-500 hover:text-gray-700"
          disabled={isLoading}
        >
          <FaTimes />
        </button>
      </div>
      
      <div className="p-4 overflow-y-auto flex-1">
        {/* 오류 메시지 */}
        {error && (
          <div className="mb-4 p-2 bg-red-50 border border-red-200 rounded-md text-xs text-red-600">
            {error}
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
            disabled={isLoading}
          />
        </div>
        
        {/* 담당의 선택 */}
        <div className="mb-4">
          <label className="block text-xs font-medium text-gray-700 mb-1">
            담당의
          </label>
          {doctors.length > 0 ? (
            <select
              value={doctorName}
              onChange={(e) => setDoctorName(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md text-xs focus:outline-none focus:ring-2 focus:ring-primary-500"
              disabled={isLoading}
            >
              {doctors.map((doctor) => (
                <option key={doctor.id} value={doctor.name}>{doctor.name}</option>
              ))}
            </select>
          ) : (
            <input
              type="text"
              value={doctorName}
              onChange={(e) => setDoctorName(e.target.value)}
              className="w-full px-3 py-2 border border-gray-300 rounded-md text-xs focus:outline-none focus:ring-2 focus:ring-primary-500"
              disabled={isLoading}
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
            disabled={isLoading}
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
              disabled={isLoading}
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
              treatmentType={treatmentType}
              setTreatmentType={setTreatmentType}
              prescriptionType={prescriptionType}
              setPrescriptionType={setPrescriptionType}
              prescriptionDosage={prescriptionDosage}
              setPrescriptionDosage={setPrescriptionDosage}
            />
          </div>
        </div>
        
        {/* 사진 업로드 */}
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
              onChange={handleImageUpload}
              className="hidden"
              disabled={isLoading}
            />
            <label
              htmlFor="photo-upload"
              className="flex items-center justify-center w-16 h-16 border border-dashed border-gray-300 rounded-md cursor-pointer hover:bg-gray-50"
            >
              <FaCamera className="text-gray-400" />
            </label>
            
            {pictures.map((pic, index) => (
              <div key={index} className="relative w-16 h-16">
                <img 
                  src={pic} 
                  alt={`진료 사진 ${index + 1}`}
                  className="w-full h-full object-cover rounded-md"
                />
                <button
                  type="button"
                  onClick={() => removeImage(index)}
                  className="absolute -top-1 -right-1 bg-red-500 text-white rounded-full p-1 w-5 h-5 flex items-center justify-center"
                  disabled={isLoading}
                >
                  <FaTrash className="text-[8px]" />
                </button>
              </div>
            ))}
          </div>
        </div>
        
        {/* 버튼 그룹 */}
        <div className="flex justify-end gap-2 mt-4 flex-shrink-0">
          <button
            type="button"
            onClick={onCancel}
            className="px-3 py-1.5 border border-gray-300 rounded-md text-xs text-gray-700 hover:bg-gray-50"
            disabled={isLoading}
          >
            취소
          </button>
          <button
            type="button"
            onClick={handleSave}
            className="px-3 py-1.5 bg-primary-600 border border-primary-600 rounded-md text-xs text-white hover:bg-primary-700 flex items-center gap-1"
            disabled={isLoading}
          >
            {isLoading ? (
              <span className="flex items-center gap-1">
                <svg className="animate-spin h-3 w-3 text-white" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
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
    </div>
  );
};

export default RecordEditForm; 
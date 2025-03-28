import React, { useState } from 'react';
import { Camera, Save, Loader, ArrowLeft } from 'lucide-react';
import { useSelector } from 'react-redux';
import { RootState } from '@/redux/store';
import { Doctor, BlockChainRecord, TreatmentType } from '@/interfaces';
import PrescriptionSection from '@/pages/treatment/form/PrescriptionSection';
import { createBlockchainTreatment } from '@/services/treatmentService';
/**
 * @module TreatmentForm
 * @file TreatmentForm.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 반려동물 진단 처방을 관리하는 UI 컴포넌트입니다.
 *              의사 목록을 제공하며, 처방 및 진단을 입력할 수 있습니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         온캔슬 콜백 추가 및 목록으로 버튼 구현
 * 2025-03-28        seonghun         토큰에서 실제 병원명 가져오기 추가
 */


/**
 * TreatmentForm 컴포넌트의 Props 타입 정의
 * @param {Function} props.onSave - 저장 버튼 클릭 시 호출되는 함수
 * @param {Function} props.onCancel - 취소 버튼 클릭 시 호출되는 함수
 * @param {Doctor[]} props.doctors - 선택 가능한 의사 목록
 * @param {string} props.petDID - 반려동물 DID 주소
 * @param {string} props.hospitalName - 병원 이름 (선택적)
 */
interface TreatmentFormProps {
  onSave?: (record: BlockChainRecord) => void;
  onCancel?: () => void;
  doctors: Doctor[];
  petDID: string;
  hospitalName?: string;
}

/**
 * 반려동물의 의료 기록을 입력하는 컴포넌트입니다. 
 */
const TreatmentForm: React.FC<TreatmentFormProps> = ({ 
  onSave, 
  onCancel,
  doctors, 
  petDID,
  hospitalName = '샘플 동물병원' 
}) => {
  // Redux에서 토큰 가져오기
  const accessToken = useSelector((state: RootState) => state.auth.accessToken);

  // 토큰에서 병원명 추출
  const getHospitalNameFromToken = (token: string) => {
    try {
      const payloadBase64 = token.split(".")[1];
      const decoded = decodeURIComponent(
        atob(payloadBase64)
          .split("")
          .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
          .join("")
      );
      const payload = JSON.parse(decoded);
      return payload.name || hospitalName;
    } catch (error) {
      console.error("토큰 디코딩 실패", error);
      return hospitalName;
    }
  };

  // 실제 병원명 가져오기 (토큰에서 가져오거나 props로 받은 값 사용)
  const actualHospitalName = accessToken 
    ? getHospitalNameFromToken(accessToken) 
    : hospitalName;
    
  const [notes, setNotes] = useState('');
  const [prescriptionType, setPrescriptionType] = useState('');
  const [prescriptionDosage, setPrescriptionDosage] = useState('');
  const [treatmentType, setTreatmentType] = useState<TreatmentType>(TreatmentType.EXAMINATION);
  const [prescriptions, setPrescriptions] = useState({
    examinations: [],
    medications: [],
    vaccinations: []
  });
  const [images, setImages] = useState<string[]>([]);
  const [diagnosis, setDiagnosis] = useState('');
  const [doctorId, setDoctorId] = useState<number>(doctors[0] ? doctors[0].id : 0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);

  /**
   * 이미지 업로드 핸들러입니다. 
   * @param {React.ChangeEvent<HTMLInputElement>} event - 파일 입력 이벤트
   */
  const handleImageUpload = (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (files) {
      const newImages = Array.from(files).map(file => URL.createObjectURL(file));
      setImages([...images, ...newImages]);
    }
  };

  /**
   * 업로드된 이미지를 삭제합니다. 
   * @param {number} index - 삭제할 이미지의 인덱스
   */
  const removeImage = (index: number) => {
    setImages(images.filter((_, i) => i !== index));
  };

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
   * 진료 기록을 저장합니다. 
   */
  const handleSave = async () => {
    if (!diagnosis.trim()) {
      showMessage('진단명을 입력해주세요', true);
      return;
    }

    if (!petDID) {
      showMessage('반려동물 정보가 없습니다', true);
      return;
    }

    try {
      setLoading(true);
      setError(null);
      setSuccessMessage(null);

      const timestamp = Math.floor(Date.now() / 1000); // Unix timestamp (초 단위)
      const doctorName = doctors.find(doctor => doctor.id === doctorId)?.name || '';
      
      const record: BlockChainRecord = {
        id: `medical_record_${timestamp}_${doctorName.replace(/\s+/g, '_')}`,
        timestamp: timestamp,
        diagnosis,
        treatments: prescriptions,
        doctorName: doctorName,
        notes: notes,
        hospitalAddress: '',
        hospitalName: actualHospitalName,
        createdAt: new Date().toISOString(),
        isDeleted: false,
        pictures: images,
        expireDate: Math.floor(Date.now() / 1000) + (365 * 24 * 60 * 60) // 1년 후 만료
      };

      console.log('저장 전 처방 데이터:', prescriptions);

      // 블록체인에 트랜잭션 전송
      const result = await createBlockchainTreatment(petDID, record);

      if (result.success) {
        showMessage('진료 기록이 성공적으로 저장되었습니다', false);
        
        // 폼 초기화
        setDiagnosis('');
        setNotes('');
        setPrescriptions({
          examinations: [],
          medications: [],
          vaccinations: []
        });
        setImages([]);
        
        // 상위 컴포넌트 콜백 호출 (있는 경우)
        if (onSave) {
          onSave(record);
        }

        console.log('블록체인에 저장한 데이터:', record.treatments);
      } else {
        showMessage(result.error || '알 수 없는 오류가 발생했습니다', true);
      }
    } catch (error: any) {
      console.error('진료 기록 저장 중 오류:', error);
      showMessage(error.message || '진료 기록 저장 중 오류가 발생했습니다', true);
    } finally {
      setLoading(false);
    }
  };

  /**
   * 진료 기록 입력을 취소하고 목록으로 돌아갑니다.
   */
  const handleCancel = () => {
    if (onCancel) {
      onCancel();
    }
  };

  return (
    <div className="flex-1 flex flex-col bg-white px-4 pb-4 rounded-lg border">
      <div className="py-3 flex justify-between items-center">
        <h3 className="font-bold text-gray-800">
          {new Date().toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' })} 
          <span className="text-primary-500 ml-2">{actualHospitalName}</span>
        </h3>
        <div className="flex gap-2">
          <button
            onClick={handleCancel}
            className="flex gap-1 items-center justify-center border border-gray-300 text-gray-700 text-xs font-medium rounded-md transition px-2 py-1 hover:bg-gray-50"
            disabled={loading}
          >
            <ArrowLeft className="w-4 h-4" /> 목록으로
          </button>
          <select
            value={doctorId}
            onChange={(e) => setDoctorId(Number(e.target.value))}
            className="px-2 py-1 border rounded-md text-xs font-medium text-primary-500 border-primary-500 w-20"
            disabled={loading}
          >
            {doctors.map((doctor) => (
              <option key={doctor.id} value={doctor.id}>{doctor.name}</option>
            ))}
          </select>
          <button
            onClick={handleSave}
            className="flex gap-1 items-center justify-center bg-primary-500 hover:bg-primary-600 text-white text-xs font-medium rounded-md transition w-20 px-2 py-1"
            disabled={loading}
          >
            {loading ? <Loader className="w-4 h-4 animate-spin" /> : <><Save className="w-4 h-4" /> 저장</>}
          </button>
        </div>
      </div>

      {error && (
        <div className="mb-4 p-2 bg-red-50 text-red-700 text-xs rounded border border-red-200">
          {error}
        </div>
      )}

      {successMessage && (
        <div className="mb-4 p-2 bg-green-50 text-green-700 text-xs rounded border border-green-200">
          {successMessage}
        </div>
      )}

      <div className="flex flex-1 gap-5">
        <div className="flex-1 flex flex-col gap-2">
          {/* 진단 입력 필드 */}
          <div>
            <div className="font-bold text-md">진단</div>
            <input
              type="text"
              className="w-full border mt-2 p-2 text-sm rounded-md"
              value={diagnosis}
              onChange={(e) => setDiagnosis(e.target.value)}
              disabled={loading}
              placeholder="진단명을 입력하세요"
            />
          </div>

          {/* 증상 입력 필드 */}
          <div>
            <div className="font-bold text-md">증상</div>
            <textarea
              className="w-full border p-2 text-sm h-24 rounded-md"
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
              disabled={loading}
              placeholder="증상에 대한 메모를 입력하세요"
            />
          </div>

          {/* 사진 업로드 */}
          <div className="flex-1">
            <div className="font-bold text-md">사진</div>
            <div className="flex gap-1 mt-2 flex-wrap">
              <input type="file" accept="image/*" multiple onChange={handleImageUpload} className="hidden" id="file-upload" disabled={loading} />
              <label
                htmlFor="file-upload"
                className="w-16 h-16 flex justify-center items-center border rounded-md cursor-pointer text-primary-500"
              >
                <Camera className="w-4 h-4" />
              </label>
              {images.map((image, index) => (
                <div key={index} className="relative">
                  <img src={image} alt="uploaded" className="w-16 h-16 object-cover rounded-md" />
                  <button
                    onClick={() => removeImage(index)}
                    className="absolute top-0 right-0 text-white text-xs bg-red-500 rounded-full p-1"
                    disabled={loading}
                  >
                    x
                  </button>
                </div>
              ))}
            </div>
          </div>
        </div>

        {/* 처방 입력 필드 */}
        <div className="flex-1">
          <div className="font-bold text-md mb-2">처방</div>
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
    </div>
  );
};

export default TreatmentForm;

import React, { useState, useEffect } from 'react';
import { Camera, Save, Loader, ArrowLeft } from 'lucide-react';
import { useSelector } from 'react-redux';
import { RootState } from '@/redux/store';
import { Doctor, BlockChainRecord, ExaminationTreatment, MedicationTreatment, VaccinationTreatment } from '@/interfaces';
import PrescriptionSection from '@/pages/treatment/form/PrescriptionSection';
import { createBlockchainTreatment } from '@/services/treatmentRecordService';
import { getAccountAddress } from '@/services/blockchainAuthService';
import { uploadImage } from '@/services/treatmentImageService';
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
 * 2025-04-02        seonghun         이미지 업로드 처리 api 연동, 필드명 정리 및 최종진료 체크박스스
 */


/**
 * TreatmentForm 컴포넌트의 Props 타입 정의
 * @param {Function} props.onSave - 저장 버튼 클릭 시 호출되는 함수
 * @param {Function} props.onCancel - 취소 버튼 클릭 시 호출되는 함수
 * @param {Doctor[]} props.doctors - 선택 가능한 의사 목록
 * @param {string} props.petDID - 반려동물 DID 주소
 * @param {string} props.hospitalName - 병원 이름 (선택적)
 * @param {string} props.petSpecies - 반려동물 종류 (예: '개', '고양이' 등)
 */
interface TreatmentFormProps {
  onSave?: (record: BlockChainRecord) => void;
  onCancel?: () => void;
  doctors: Doctor[];
  petDID: string;
  hospitalName?: string;
  petSpecies?: string;
}

/**
 * 반려동물의 의료 기록을 입력하는 컴포넌트입니다. 
 */
const TreatmentForm: React.FC<TreatmentFormProps> = ({ 
  onSave, 
  onCancel,
  doctors, 
  petDID,
  hospitalName = '샘플 동물병원',
  petSpecies = '개' // 기본값 설정
}) => {
  // 폼 상태 관리
  const [formData, setFormData] = useState({
    diagnosis: '',
    doctorName: '',
    notes: '',
    pictures: [],
    hospitalAddress: ''
  });

  // Redux에서 병원 정보 가져오기
  const { hospital } = useSelector((state: RootState) => state.auth);
  
  // 계정 주소 가져오기
  useEffect(() => {
    const fetchAccountAddress = async () => {
      try {
        const address = await getAccountAddress();
        if (address) {
          setFormData(prev => ({
            ...prev,
            hospitalAddress: address
          }));
        }
      } catch (error) {
        console.error('계정 주소 가져오기 실패:', error);
      }
    };
    
    fetchAccountAddress();
  }, []);

  // Redux 스토어에서 병원명 가져오기
  const actualHospitalName = hospital?.name || hospitalName;
    
  const [notes, setNotes] = useState('');
  const [isFinalTreatment, setIsFinalTreatment] = useState(true);
  const [prescriptions, setPrescriptions] = useState<{
    examinations: ExaminationTreatment[];
    medications: MedicationTreatment[];
    vaccinations: VaccinationTreatment[];
  }>({
    examinations: [],
    medications: [],
    vaccinations: []
  });
  const [images, setImages] = useState<string[]>([]);
  const [imageUrls, setImageUrls] = useState<string[]>([]);
  const [isUploadingImages, setIsUploadingImages] = useState<boolean>(false);
  const [diagnosis, setDiagnosis] = useState('');
  const [doctorId, setDoctorId] = useState<number>(doctors[0] ? doctors[0].id : 0);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const [successMessage, setSuccessMessage] = useState<string | null>(null);


  /**
   * 이미지 업로드 핸들러입니다. 
   * @param {React.ChangeEvent<HTMLInputElement>} event - 파일 입력 이벤트
   */
  const handleImageUpload = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const files = event.target.files;
    if (!files || files.length === 0) return;

    setIsUploadingImages(true);
    setError(null);

    // 현재 상태 복사
    const currentBlobUrls = [...images];
    const currentS3Urls = [...imageUrls];
    
    // 결과를 저장할 배열 초기화
    const newBlobUrls: string[] = [];
    
    try {
      console.log(`${files.length}개 미리보기 생성 중...`);
      for (const file of files) {
        const blobUrl = URL.createObjectURL(file);
        newBlobUrls.push(blobUrl);
      }
      
      // 미리보기 업데이트
      setImages([...currentBlobUrls, ...newBlobUrls]);
      
      // 3단계: 압축된 파일을 서버에 업로드
      console.log(`${files.length}개 이미지 업로드 시작...`);
      for (let i = 0; i < files.length; i++) {
        const file = files[i];
        const blobUrl = newBlobUrls[i];
        
        try {
          console.log(`[${i+1}/${files.length}] 이미지 업로드 중: ${file.name}`);
          const s3Url = await uploadImage(file, 'treatment');
          
          if (s3Url) {
            console.log(`[${i+1}/${files.length}] 업로드 성공: ${file.name}, S3 URL: ${s3Url}`);
            currentS3Urls.push(s3Url);
          } else {
            console.error(`[${i+1}/${files.length}] 업로드 실패: ${file.name}`);
            showMessage(`'${file.name}' 이미지 업로드 실패`, true);
            
            // 업로드 실패 시 해당 미리보기 제거
            setImages(prev => prev.filter(url => url !== blobUrl));
            URL.revokeObjectURL(blobUrl);
          }
        } catch (uploadError) {
          console.error(`[${i+1}/${files.length}] 이미지 업로드 중 오류:`, uploadError);
          showMessage(`'${file.name}' 이미지 업로드 중 오류 발생`, true);
          
          // 업로드 오류 시 해당 미리보기 제거
          setImages(prev => prev.filter(url => url !== blobUrl));
          URL.revokeObjectURL(blobUrl);
        }
      }
      
      // S3 URL 상태 업데이트
      setImageUrls(currentS3Urls);
      console.log(`이미지 업로드 프로세스 완료: 총 ${currentS3Urls.length}개 이미지 저장 완료`);
      
    } catch (error) {
      console.error('이미지 처리 중 예상치 못한 오류:', error);
      showMessage('이미지 처리 중 오류가 발생했습니다', true);
      
      // 오류 발생 시 생성된 모든 Blob URL 해제
      newBlobUrls.forEach(url => URL.revokeObjectURL(url));
    } finally {
      setIsUploadingImages(false);
    }
  };

  /**
   * 업로드된 이미지를 삭제합니다.
   * @param {number} index - 삭제할 이미지의 인덱스
   */
  const removeImage = (index: number) => {
    const newImages = images.filter((_, i) => i !== index);
    const newImageUrls = imageUrls.filter((_, i) => i !== index);

    if (images[index]) {
      URL.revokeObjectURL(images[index]);
    }

    setImages(newImages);
    setImageUrls(newImageUrls);
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
        diagnosis: diagnosis || '진단 없음',
        treatments: {
          examinations: prescriptions.examinations,
          medications: prescriptions.medications,
          vaccinations: prescriptions.vaccinations
        },
        doctorName: doctorName || '담당의사 정보 없음',
        notes: notes || '',
        hospitalAddress: formData.hospitalAddress || '',
        hospitalName: actualHospitalName || '병원명 없음',
        createdAt: new Date().toISOString(),
        isDeleted: false,
        pictures: imageUrls || [],
        expireDate: Math.floor(Date.now() / 1000) + (365 * 24 * 60 * 60), // 1년 후 만료
        status: isFinalTreatment ? 'COMPLETED' : 'IN_PROGRESS', // 최종 진료면 완료, 아니면 진행 중
        flagCertificated: true, // 병원에서 작성하므로 true
        hospitalAccountId: hospital?.id ? String(hospital.id) : '' // 병원 계정 ID 추가
      };

      console.log('저장 전 처방 데이터:', record.treatments);

      // 중요: 트랜잭션 실패 시에도 UI는 정상 동작하도록 예외 처리
      try {
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
          setImageUrls([]);
          
          // 상위 컴포넌트 콜백 호출 (있는 경우)
          if (onSave) {
            onSave(record);
          }

          console.log('블록체인에 저장한 데이터:', record.treatments);
        } else {
          showMessage(result.error || '알 수 없는 오류가 발생했습니다', true);
        }
      } catch (txError: any) {
        console.error('블록체인 트랜잭션 오류:', txError);
        showMessage(`블록체인 저장 중 오류: ${txError.message || '알 수 없는 오류가 발생했습니다'}`, true);
        
        // 심각한 오류 감지 시 개발자 콘솔에 상세 정보 표시
        if (txError.code === 'GAS_LIMIT_EXCEEDED') {
          console.error('가스 한도 초과 오류. 처방 데이터가 너무 많을 수 있습니다.');
        } else if (txError.code === 'TRANSACTION_REVERTED') {
          console.error('트랜잭션 실패. 계약 내부 조건을 확인하세요.');
        }
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

  // 노트 내용 변경 핸들러
  const handleNotesChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    setNotes(e.target.value);
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
            disabled={loading || isUploadingImages}
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
          <div className="flex-2">
            <div className="font-bold text-md">증상</div>
            <textarea
              className="w-full border p-2 text-sm h-24 rounded-md"
              value={notes}
              onChange={handleNotesChange}
              disabled={loading}
              placeholder="증상에 대한 메모를 입력하세요"
            ></textarea>
          </div>
          
          {/* 최종 진료 체크박스 */}
          <div className="mb-2">
            <label className="flex items-center cursor-pointer">
              <input
                type="checkbox"
                checked={isFinalTreatment}
                onChange={() => setIsFinalTreatment(prev => !prev)}
                className="mr-2 h-4 w-4 text-primary-500 focus:ring-primary-400 border-gray-300 rounded"
                disabled={loading}
              />
              <span className="text-sm font-medium text-gray-700">
                이번 진료를 장기 치료의 마지막 진료로 표시 (치료 완료)
              </span>
            </label>
            {isFinalTreatment && (
              <p className="text-xs text-gray-500 mt-1 ml-6">
                * 이 옵션을 선택하면 해당 진료가 완료된 것으로 처리되며, 더 이상 추가 진료가 필요하지 않음을 의미합니다.
              </p>
            )}
          </div>

          {/* 사진 업로드 */}
          <div>
            <div className="font-bold text-md">사진</div>
            <div className="flex gap-1 mt-2 flex-wrap items-center">
              <input type="file" accept="image/*" multiple onChange={handleImageUpload} className="hidden" id="file-upload" disabled={loading || isUploadingImages} />
              <label
                htmlFor="file-upload"
                className={`w-16 h-16 flex flex-col justify-center items-center border rounded-md cursor-pointer text-primary-500 
                  ${loading || isUploadingImages ? 'bg-gray-100 cursor-not-allowed opacity-50' : 'hover:bg-primary-50'}`}
              >
                {isUploadingImages ? (
                  <Loader className="w-4 h-4 animate-spin mb-1" />
                ) : (
                  <Camera className="w-4 h-4 mb-1" /> 
                )}
                <span className="text-xs">{isUploadingImages ? '업로드중' : '사진 추가'}</span>
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
        <div className="flex-1 flex flex-col">
          <div className="font-bold text-md mb-2">처방</div>
          <span className="h-full">
            <PrescriptionSection
              prescriptions={prescriptions}
              setPrescriptions={setPrescriptions}
              petSpecies={petSpecies}
            />
          </span>
        </div>
      </div>
    </div>
  );
};

export default TreatmentForm;

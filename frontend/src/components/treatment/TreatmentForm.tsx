import React, { useState, useRef, useEffect } from 'react';
import { useAppDispatch, useAppSelector } from '../../redux/store';
import { 
  setCurrentTreatment, 
  updateCurrentTreatmentDiagnosis, 
  updateCurrentTreatmentFields,
  addTreatmentItem, 
  removeTreatmentItem, 
  updateTreatmentItem,
  setImportedPdfData,
  saveTreatmentStart,
  saveTreatmentSuccess,
  saveToBlockchainStart,
  saveToBlockchainSuccess,
  saveTreatmentTemp,
  TreatmentItem,
  Treatment,
  DocumentType
} from '../../redux/slices/treatmentSlice';
import { updateTreatmentStatus, selectSelectedGuardian } from '../../redux/slices/guardianSlice';
import { selectSelectedPet } from '../../redux/slices/petSlice';
import { selectDevModeEnabled, selectMockHospitalData } from '../../redux/slices/devModeSlice';
import { FiPlus, FiTrash2, FiUpload, FiSave, FiLink, FiCheck, FiFileText, FiClipboard } from 'react-icons/fi';
import { toast } from 'react-toastify';
import { parsePdfFile } from '../../utils/pdfParser';
import { selectLoggedInHospital, selectCurrentDoctor } from '../../redux/slices/authSlice';

// 아이콘 props 인터페이스 정의
interface IconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  color?: string;
  className?: string;
}

// 아이콘 컴포넌트를 위한 타입 단언
const IconPlus = FiPlus as unknown as React.ComponentType<IconProps>;
const IconTrash = FiTrash2 as unknown as React.ComponentType<IconProps>;
const IconUpload = FiUpload as unknown as React.ComponentType<IconProps>;
const IconSave = FiSave as unknown as React.ComponentType<IconProps>;
const IconLink = FiLink as unknown as React.ComponentType<IconProps>;
const IconCheck = FiCheck as unknown as React.ComponentType<IconProps>;
const IconFileText = FiFileText as unknown as React.ComponentType<IconProps>;
const IconClipboard = FiClipboard as unknown as React.ComponentType<IconProps>;

interface TreatmentFormProps {
  petId: string;
}

interface TreatmentState {
  currentTreatment: {
    petId: string;
    diagnosis: string;
    diseaseName?: string;
    onsetDate?: string;
    diagnosisDate?: string;
    prognosis?: string;
    petColor?: string;
    items: TreatmentItem[];
    nextAppointment?: string;
    documentType: DocumentType['type'];
    veterinarianName?: string;
    veterinarianLicense?: string;
  } | null;
  loading: boolean;
  blockchainLoading: boolean;
  tempSaved: boolean;
  importedPdfData: any;
}

interface AuthState {
  user: {
    id: string;
    username: string;
    hospitalName?: string;
  } | null;
}

interface PetState {
  selectedPet: {
    id: string;
    name: string;
    species?: string;
    breed?: string;
    gender?: string;
    age?: number;
  } | null;
}

const TreatmentForm: React.FC<TreatmentFormProps> = ({ petId }) => {
  const dispatch = useAppDispatch();
  const { currentTreatment, loading, blockchainLoading, tempSaved, importedPdfData } = useAppSelector(state => state.treatment as TreatmentState);
  const { user } = useAppSelector(state => state.auth as AuthState);
  const { selectedPet } = useAppSelector(state => state.pet as PetState);
  const selectedGuardian = useAppSelector(selectSelectedGuardian);
  
  // 개발 모드 상태 확인
  const isDevMode = useAppSelector(selectDevModeEnabled);
  
  // 개발 모드일 때 mockHospitalData에서 의사 목록 가져오기
  const mockHospital = useAppSelector(selectMockHospitalData);
  
  // 현재 선택된 의사 정보
  const currentDoctor = useAppSelector(selectCurrentDoctor);
  
  // 의사 목록 - 개발 모드에 따라 다른 데이터 사용
  const [veterinarians, setVeterinarians] = useState<Array<{id: string, name: string, licenseNumber: string}>>([
    { id: 'VET001', name: '김수의', licenseNumber: 'LIC123456' },
    { id: 'VET002', name: '박닥터', licenseNumber: 'LIC234567' },
    { id: 'VET003', name: '이진료', licenseNumber: 'LIC345678' },
    { id: 'VET004', name: '최메디', licenseNumber: 'LIC456789' },
  ]);
  
  // 개발 모드일 때 mockHospitalData에서 의사 목록 업데이트
  useEffect(() => {
    if (isDevMode && mockHospital && mockHospital.doctors && mockHospital.doctors.length > 0) {
      const mockDoctors = mockHospital.doctors.map(doctor => ({
        id: doctor.id,
        name: doctor.name,
        licenseNumber: doctor.licenseNumber || ''
      }));
      
      setVeterinarians(mockDoctors);
    }
  }, [isDevMode, mockHospital]);
  
  const [newItem, setNewItem] = useState<TreatmentItem>({
    name: '',
    quantity: 1,
    dosage: '',
    frequency: '',
    description: ''
  });
  
  const fileInputRef = useRef<HTMLInputElement>(null);
  const [isAddingItem, setIsAddingItem] = useState(false);
  
  // 현재 날짜를 YYYY-MM-DD 형식으로 가져오는 함수
  const getCurrentDate = () => {
    const today = new Date();
    const year = today.getFullYear();
    const month = String(today.getMonth() + 1).padStart(2, '0');
    const day = String(today.getDate()).padStart(2, '0');
    return `${year}-${month}-${day}`;
  };
  
  useEffect(() => {
    // 선택된 반려동물 ID 저장
    localStorage.setItem('selectedPetId', petId);
    
    // 선택된 반려동물이 변경되면 새 진료 초기화
    dispatch(setCurrentTreatment({
      petId,
      diagnosis: '',
      items: [],
      documentType: 'receipt',
      // 현재 선택된 의사가 있으면 해당 의사 정보 사용, 없으면 기본값 사용
      veterinarianName: currentDoctor ? currentDoctor.name : (user?.username || ''),
      veterinarianLicense: currentDoctor ? (currentDoctor.licenseNumber || '') : (user?.id || ''),
      diagnosisDate: getCurrentDate(), // 현재 날짜를 진단일로 설정
    }));
    
    // localStorage에 치료중인 반려동물 ID 저장
    localStorage.setItem('activeTreatmentPetId', petId);
    
  }, [petId, dispatch, user, currentDoctor]);
  
  // 현재 선택된 의사가 변경되면 진료 기록의 의사 정보도 업데이트
  useEffect(() => {
    if (currentDoctor && currentTreatment) {
      // 진료 기록에 의사 정보가 없거나 다른 경우에만 업데이트
      if (!currentTreatment.veterinarianName || currentTreatment.veterinarianName !== currentDoctor.name) {
        dispatch(updateCurrentTreatmentFields({ field: 'veterinarianName', value: currentDoctor.name }));
      }
      
      if (!currentTreatment.veterinarianLicense || currentTreatment.veterinarianLicense !== currentDoctor.licenseNumber) {
        dispatch(updateCurrentTreatmentFields({ field: 'veterinarianLicense', value: currentDoctor.licenseNumber || '' }));
      }
    }
  }, [currentDoctor, currentTreatment, dispatch]);
  
  useEffect(() => {
    const handleBeforeUnload = () => {
      if (currentTreatment && Object.keys(currentTreatment).length > 0) {
        // 임시 저장 로직
        localStorage.setItem('tempTreatmentData', JSON.stringify(currentTreatment));
      }
    };
    
    window.addEventListener('beforeunload', handleBeforeUnload);
    return () => {
      window.removeEventListener('beforeunload', handleBeforeUnload);
    };
  }, [currentTreatment]);
  
  const handleDiagnosisChange = (e: React.ChangeEvent<HTMLTextAreaElement>) => {
    dispatch(updateCurrentTreatmentDiagnosis(e.target.value));
    
    // 진단내용이 입력되면 보호자의 진료 상태를 "진료중"으로 변경
    if (e.target.value.trim() && selectedPet && selectedGuardian) {
      // 현재 상태가 "대기중"인 경우에만 변경
      if (selectedGuardian.treatmentStatus === 'waiting') {
        dispatch(updateTreatmentStatus({
          guardianId: selectedGuardian.id,
          status: 'inProgress'
        }));
        toast.info(`${selectedGuardian.name}님의 진료 상태가 '진료중'으로 변경되었습니다.`);
      }
    }
  };
  
  const handleFieldChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    dispatch(updateCurrentTreatmentFields({ field: name, value }));
  };
  
  const handleNewItemChange = (e: React.ChangeEvent<HTMLInputElement | HTMLTextAreaElement>) => {
    const { name, value } = e.target;
    setNewItem(prev => ({
      ...prev,
      [name]: name === 'quantity' ? Number(value) : value
    }));
  };
  
  const handleAddItem = () => {
    if (!newItem.name) {
      toast.error('항목 이름을 입력해주세요.');
      return;
    }
    
    dispatch(addTreatmentItem(newItem));
    setNewItem({
      name: '',
      quantity: 1,
      dosage: '',
      frequency: '',
      description: ''
    });
  };
  
  const handleRemoveItem = (index: number) => {
    dispatch(removeTreatmentItem(index));
  };
  
  const handleUpdateItem = (index: number, field: keyof TreatmentItem, value: string | number) => {
    if (!currentTreatment) return;
    
    const updatedItem = {
      ...currentTreatment.items[index],
      [field]: field === 'quantity' ? Number(value) : value
    };
    
    dispatch(updateTreatmentItem({ index, item: updatedItem }));
  };
  
  const handleFileUpload = async (e: React.ChangeEvent<HTMLInputElement>) => {
    const file = e.target.files?.[0];
    if (!file) return;
    
    // PDF 파일 유효성 검사
    if (file.type !== 'application/pdf') {
      toast.error('PDF 파일만 업로드 가능합니다.');
      return;
    }
    
    // PDF 파일 처리 시작
    toast.info('PDF 파일을 분석 중입니다...');
    
    try {
      // PDF 파싱
      const parsedData = await parsePdfFile(file);
      
      // 추출된 데이터를 Redux 상태에 저장
      dispatch(setImportedPdfData(parsedData));
      
      // 현재 진료 내역에 반영
      const treatmentData = {
        petId,
        diagnosis: parsedData.diagnosis || '',
        items: parsedData.items || [],
        nextAppointment: parsedData.nextAppointment,
        documentType: parsedData.documentType,
        // 진단서 데이터
        diseaseName: parsedData.diseaseName,
        onsetDate: parsedData.onsetDate,
        diagnosisDate: parsedData.diagnosisDate,
        prognosis: parsedData.prognosis,
        petColor: parsedData.petColor,
        veterinarianName: parsedData.veterinarianName,
        veterinarianLicense: parsedData.veterinarianLicense
      };
      
      dispatch(setCurrentTreatment(treatmentData));
      
      toast.success('PDF 파일 분석이 완료되었습니다.');
    } catch (error) {
      console.error('PDF 파싱 실패:', error);
      toast.error('PDF 파일 분석에 실패했습니다.');
    }
    
    // 파일 입력 초기화
    if (fileInputRef.current) {
      fileInputRef.current.value = '';
    }
  };
  
  const handleSaveTreatment = () => {
    if (!currentTreatment) return;
    
    // 공통 유효성 검사
    if (!currentTreatment.diagnosis) {
      toast.error('진단 내용을 입력해주세요.');
      return;
    }
    
    // 문서 타입별 유효성 검사
    if (currentTreatment.documentType === 'receipt' && currentTreatment.items.length === 0) {
      toast.error('최소 하나 이상의 진료 항목을 추가해주세요.');
      return;
    }
    
    if (currentTreatment.documentType === 'diagnosis' && !currentTreatment.diseaseName) {
      toast.error('병명을 입력해주세요.');
      return;
    }
    
    // 임시 저장
    dispatch(saveTreatmentTemp());
    toast.info('진료 내역이 임시 저장되었습니다. 블록체인에 저장하려면 블록체인 저장 버튼을 클릭하세요.');
  };
  
  const handleSaveToBlockchain = () => {
    if (!currentTreatment) return;
    
    // 저장 전 유효성 검사
    if (!currentTreatment.diagnosis) {
      toast.error('진단 내용을 입력해주세요.');
      return;
    }
    
    if (!currentTreatment.veterinarianName) {
      toast.error('수의사 이름을 입력해주세요.');
      return;
    }
    
    dispatch(saveToBlockchainStart());
    
    // 실제로는 여기서 블록체인 API 호출
    // 임시 처리
    setTimeout(() => {
      // 새 진료 내역 생성
      const txHash = `0x${Math.random().toString(16).substring(2, 42)}`;
      const timestamp = new Date().toISOString();
      
      // Treatment 타입에 맞게 객체 생성
      const newTreatment: Treatment = {
        id: `treatment-${Date.now()}`,
        petId: currentTreatment.petId,
        hospitalName: user?.hospitalName || '알 수 없는 병원',
        hospitalId: user?.id || '',
        treatmentDate: new Date().toISOString(),
        diagnosis: currentTreatment.diagnosis,
        items: currentTreatment.items,
        documentType: currentTreatment.documentType,
        blockchainVerified: true,
        blockchainTxHash: txHash,
        blockchainTimestamp: timestamp,
        veterinarianName: currentTreatment.veterinarianName || user?.username || '알 수 없는 수의사',
        veterinarianLicense: currentTreatment.veterinarianLicense || ''
      };
      
      // 선택적 필드 추가
      if (currentTreatment.nextAppointment) {
        newTreatment.nextAppointment = currentTreatment.nextAppointment;
      }
      
      if (currentTreatment.diseaseName) {
        newTreatment.diseaseName = currentTreatment.diseaseName;
      }
      
      if (currentTreatment.onsetDate) {
        newTreatment.onsetDate = currentTreatment.onsetDate;
      }
      
      if (currentTreatment.diagnosisDate) {
        newTreatment.diagnosisDate = currentTreatment.diagnosisDate;
      }
      
      if (currentTreatment.prognosis) {
        newTreatment.prognosis = currentTreatment.prognosis;
      }
      
      if (currentTreatment.petColor) {
        newTreatment.petColor = currentTreatment.petColor;
      }
      
      // 먼저 저장 후 블록체인 트랜잭션 정보 업데이트
      dispatch(saveTreatmentSuccess(newTreatment));
      
      dispatch(saveToBlockchainSuccess({
        treatmentId: newTreatment.id,
        txHash: txHash,
        timestamp: timestamp
      }));
      
      // 보호자의 진료 상태를 '진료완료'로 변경
      if (selectedGuardian) {
        dispatch(updateTreatmentStatus({
          guardianId: selectedGuardian.id,
          status: 'completed'
        }));
        toast.info(`${selectedGuardian.name}님의 진료가 완료되었습니다.`);
      }
      
      toast.success('진료 내역이 블록체인에 저장되었습니다.');
    }, 2000);
  };
  
  // 수의사 선택 시 면허번호도 함께 업데이트
  const handleVeterinarianChange = (e: React.ChangeEvent<HTMLSelectElement>) => {
    const selectedVetId = e.target.value;
    const selectedVet = veterinarians.find(vet => vet.id === selectedVetId);
    
    if (selectedVet) {
      dispatch(updateCurrentTreatmentFields({ field: 'veterinarianName', value: selectedVet.name }));
      dispatch(updateCurrentTreatmentFields({ field: 'veterinarianLicense', value: selectedVet.licenseNumber }));
    }
  };
  
  if (!currentTreatment || !selectedPet) {
    return (
      <div className="h-full p-4 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <div className="flex flex-col items-center justify-center h-full text-gray-500 dark:text-gray-400">
          <p>반려동물을 선택해주세요.</p>
        </div>
      </div>
    );
  }
  
  return (
    <div className="h-full bg-white rounded-lg shadow-md dark:bg-gray-800">
      <div className="p-4 border-b dark:border-gray-700">
        <div className="flex items-center justify-between">
          <h2 className="text-lg font-semibold text-gray-800 dark:text-white">
            {selectedPet.name} 진료 세부 내역 입력
          </h2>
          <div className="flex space-x-2">
            <button
              onClick={() => fileInputRef.current?.click()}
              className="flex items-center p-2 text-gray-600 bg-gray-100 rounded-md hover:bg-gray-200 dark:text-gray-300 dark:bg-gray-700 dark:hover:bg-gray-600"
              title="PDF 파일 불러오기"
            >
              <IconFileText size={16} className="mr-1" />
              <span className="text-xs">PDF 불러오기</span>
            </button>
            <input
              type="file"
              ref={fileInputRef}
              onChange={handleFileUpload}
              accept=".pdf"
              className="hidden"
            />
          </div>
        </div>
      </div>
      
      <div className="p-4 overflow-y-auto h-[calc(100vh-22rem)]">
        {/* 수의사 정보 */}
        <div className="grid grid-cols-1 gap-4 mb-4 md:grid-cols-2">
          <div>
            <label htmlFor="veterinarian" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
              수의사 선택
            </label>
            <select
              id="veterinarian"
              name="veterinarian"
              onChange={handleVeterinarianChange}
              className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            >
              <option value="">수의사를 선택하세요</option>
              {veterinarians.map(vet => (
                <option key={vet.id} value={vet.id}>
                  {vet.name}
                </option>
              ))}
            </select>
          </div>
          <div>
            <label htmlFor="veterinarianLicense" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
              수의사 면허번호
            </label>
            <input
              type="text"
              id="veterinarianLicense"
              name="veterinarianLicense"
              value={currentTreatment.veterinarianLicense || ''}
              onChange={handleFieldChange}
              className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              placeholder="수의사 면허번호를 입력하세요"
              readOnly
            />
          </div>
        </div>

        {/* 진단 내용 */}
        <div className="mb-4">
          <label htmlFor="diagnosis" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
            진단 내용
          </label>
          <textarea
            id="diagnosis"
            rows={3}
            value={currentTreatment.diagnosis}
            onChange={handleDiagnosisChange}
            className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            placeholder="진단 내용을 입력하세요..."
          ></textarea>
        </div>
        
        {/* 진단서 관련 필드 */}
        <div className="grid grid-cols-1 gap-4 mb-4 md:grid-cols-2">
          <div>
            <label htmlFor="diseaseName" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
              병명
          </label>
                <input
                  type="text"
              id="diseaseName"
              name="diseaseName"
              value={currentTreatment.diseaseName || ''}
              onChange={handleFieldChange}
              className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              placeholder="병명을 입력하세요"
            />
          </div>
          <div>
            <label htmlFor="petColor" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
              모색
            </label>
                <input
              type="text"
              id="petColor"
              name="petColor"
              value={currentTreatment.petColor || ''}
              onChange={handleFieldChange}
              className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              placeholder="반려동물의 모색을 입력하세요"
            />
          </div>
          <div>
            <label htmlFor="onsetDate" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
              발병일
            </label>
                <input
              type="date"
              id="onsetDate"
              name="onsetDate"
              value={currentTreatment.onsetDate || ''}
              onChange={handleFieldChange}
              className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            />
              </div>
          <div>
            <label htmlFor="diagnosisDate" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
              진단일
            </label>
            <input
              type="date"
              id="diagnosisDate"
              name="diagnosisDate"
              value={currentTreatment.diagnosisDate || getCurrentDate()}
              onChange={handleFieldChange}
              className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            />
          </div>
        </div>

        {/* 예후 소견 */}
        <div className="mb-4">
          <label htmlFor="prognosis" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
            예후 소견
          </label>
          <textarea
            id="prognosis"
            name="prognosis"
            rows={3}
            value={currentTreatment.prognosis || ''}
            onChange={handleFieldChange}
            className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            placeholder="예후에 대한 소견을 입력하세요..."
          ></textarea>
        </div>

        {/* 진료 항목 */}
        <div className="mb-4">
          <h3 className="mb-2 text-sm font-medium text-gray-700 dark:text-gray-300">진료 항목</h3>
          
          {/* 항목 추가 폼 */}
          <div className="grid grid-cols-12 gap-2 mb-2">
            <div className="col-span-4">
            <input
              type="text"
              name="name"
              value={newItem.name}
              onChange={handleNewItemChange}
                placeholder="항목명"
                className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            />
            </div>
            <div className="col-span-2">
            <input
              type="number"
              name="quantity"
              value={newItem.quantity}
              onChange={handleNewItemChange}
              min="1"
              placeholder="수량"
                className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              />
            </div>
            <div className="col-span-2">
              <input
                type="text"
                name="dosage"
                value={newItem.dosage}
                onChange={handleNewItemChange}
                placeholder="용량"
                className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              />
            </div>
            <div className="col-span-3">
            <input
                type="text"
                name="frequency"
                value={newItem.frequency}
              onChange={handleNewItemChange}
                placeholder="투약 횟수/빈도"
                className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            />
            </div>
            <div className="col-span-1">
            <button
                type="button"
              onClick={handleAddItem}
                className="flex items-center justify-center w-full h-full p-2 text-white bg-primary rounded-md hover:bg-opacity-90"
            >
              <IconPlus size={16} />
            </button>
          </div>
        </div>
        
          {/* 항목 설명 입력 필드 */}
          <div className="mb-2">
            <textarea
              name="description"
              value={newItem.description}
              onChange={handleNewItemChange}
              placeholder="항목 설명 (선택사항)"
              rows={2}
              className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            ></textarea>
          </div>

          {/* 항목 목록 */}
          <div className="border border-gray-200 rounded-md dark:border-gray-700">
            {currentTreatment.items.length === 0 ? (
              <div className="p-4 text-center text-gray-500 dark:text-gray-400">
                진료 항목이 없습니다. 항목을 추가해주세요.
              </div>
            ) : (
              <ul className="divide-y divide-gray-200 dark:divide-gray-700">
                {currentTreatment.items.map((item, index) => (
                  <li key={index} className="p-3">
                    <div className="flex items-center justify-between">
                      <div className="flex-1">
                        <div className="flex items-center">
                          <span className="font-medium text-gray-800 dark:text-white">{item.name}</span>
                          <span className="ml-2 text-sm text-gray-600 dark:text-gray-400">x {item.quantity}</span>
                          {item.dosage && (
                            <span className="ml-2 text-sm text-gray-600 dark:text-gray-400">({item.dosage})</span>
                          )}
                          {item.frequency && (
                            <span className="ml-2 text-sm text-gray-600 dark:text-gray-400">{item.frequency}</span>
                          )}
                        </div>
                        {item.description && (
                          <p className="text-sm text-gray-500 dark:text-gray-400">{item.description}</p>
                        )}
                      </div>
                      <button
                        type="button"
                        onClick={() => handleRemoveItem(index)}
                        className="p-1 text-red-600 rounded-full hover:bg-red-100 dark:text-red-400 dark:hover:bg-red-900"
                      >
                        <IconTrash size={16} />
                      </button>
                    </div>
                  </li>
                ))}
              </ul>
            )}
          </div>
        </div>

        {/* 다음 예약일 */}
        <div className="mb-4">
          <label htmlFor="nextAppointment" className="block mb-1 text-sm font-medium text-gray-700 dark:text-gray-300">
            다음 예약일 (선택사항)
          </label>
          <input
            type="date"
            id="nextAppointment"
            name="nextAppointment"
            value={currentTreatment.nextAppointment || ''}
            onChange={handleFieldChange}
            className="block w-full p-2 border border-gray-300 rounded-md focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
          />
        </div>
      </div>

      {/* 하단 버튼 */}
      <div className="flex justify-between p-4 border-t dark:border-gray-700">
        <div className="flex items-center text-xs text-gray-500 dark:text-gray-400">
          {tempSaved && (
            <div className="flex items-center text-green-600 dark:text-green-400">
              <IconCheck size={12} className="mr-1" />
              <span>임시 저장됨</span>
            </div>
          )}
        </div>
        
        <div className="flex space-x-2">
          <button
            type="button"
            onClick={handleSaveToBlockchain}
            disabled={blockchainLoading}
            className="flex items-center px-4 py-2 text-white bg-primary rounded-md hover:bg-opacity-90 disabled:opacity-50"
          >
            {blockchainLoading ? (
              <>
                <svg className="w-4 h-4 mr-2 animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                저장 중...
              </>
            ) : (
              <>
                <IconLink className="mr-2" />
                블록체인에 저장
              </>
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default TreatmentForm; 
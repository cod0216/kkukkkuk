import React, { useState } from 'react';
import { Camera, Save } from 'lucide-react';
import { Doctor, BlockChainRecord, TreatmentType } from '@/interfaces';
import PrescriptionSection from '@/pages/treatment/form/PrescriptionSection';
/**
 * @module TreatmentForm
 * @file TreatmentForm.tsx
 * @author haelim
 * @date 2025-03-26
 * @description 반려동물 진단 처방을 관리하는 UI 컴포넌트입니다.
 *              의사 목록을 제공하며, 처방 및 진단을 입력할 수 있습니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */


/**
 * TreatmentForm 컴포넌트의 Props 타입 정의
 * @param {Function} props.onSave - 저장 버튼 클릭 시 호출되는 함수
 * @param {Doctor[]} props.doctors - 선택 가능한 의사 목록
 */
interface TreatmentFormProps {
  onSave: () => void;
  doctors: Doctor[];
}

/**
 * 반려동물의 의료 기록을 입력하는 컴포넌트입니다. 
 */
const TreatmentForm: React.FC<TreatmentFormProps> = ({ onSave, doctors }) => {
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
  const [doctorId, setDoctorId] = useState<number>(doctors[0].id);

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
   * 진료 기록을 저장합니다. 
   */
  const handleSave = () => {
    const record: BlockChainRecord = {
      diagnosis,
      treatments: prescriptions,
      doctorName: doctors.find(doctor => doctor.id === doctorId)?.name || '',
      notes: notes,
      hospitalAddress: '',
      hospitalName: '',
      createdAt: new Date().toISOString(),
      isDeleted: false,
      pictures: images,
    };

    console.log(record);

    onSave();
  };

  return (
    <div className="flex-1 flex flex-col bg-white px-4 pb-4 rounded-lg border">
      <div className="py-3 flex justify-between items-center">
        <h3 className="font-bold text-gray-800">
          {new Date().toLocaleDateString('ko-KR', { year: 'numeric', month: '2-digit', day: '2-digit' })}
        </h3>
        <div className="flex gap-2">
          <select
            value={doctorId}
            onChange={(e) => setDoctorId(Number(e.target.value))}
            className="px-2 py-1 border rounded-md text-xs font-medium text-primary-500 border-primary-500 w-20"
          >
            {doctors.map((doctor) => (
              <option key={doctor.id} value={doctor.id}>{doctor.name}</option>
            ))}
          </select>
          <button
            onClick={handleSave}
            className="flex gap-1 items-center justify-center bg-primary-500 hover:bg-primary-600 text-white text-xs font-medium rounded-md transition w-20"
          >
            <Save className="w-4 h-4" /> 저장
          </button>
        </div>
      </div>

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
            />
          </div>

          {/* 증상 입력 필드 */}
          <div>
            <div className="font-bold text-md">증상</div>
            <textarea
              className="w-full border p-2 text-sm h-24 rounded-md"
              value={notes}
              onChange={(e) => setNotes(e.target.value)}
            />
          </div>

          {/* 사진 업로드 */}
          <div className="flex-1">
            <div className="font-bold text-md">사진</div>
            <div className="flex gap-1 mt-2">
              <input type="file" accept="image/*" multiple onChange={handleImageUpload} className="hidden" id="file-upload" />
              <label
                htmlFor="file-upload"
                className="w-16 h-16 flex justify-center items-center w-full border rounded-md cursor-pointer text-primary-500"
              >
                <Camera className="w-4 h-4 mr-2" />
              </label>
              {images.map((image, index) => (
                <div key={index} className="relative">
                  <img src={image} alt="uploaded" className="w-16 h-16 object-cover rounded-md" />
                  <button
                    onClick={() => removeImage(index)}
                    className="absolute top-0 right-0 text-white text-xs bg-red-500 rounded-full p-1"
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

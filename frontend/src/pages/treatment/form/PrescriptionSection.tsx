import React, { FC } from 'react';
import { PlusCircle } from 'lucide-react';
import { TreatmentType, ExaminationTreatment, MedicationTreatment, VaccinationTreatment } from '@/interfaces';

/**
 * @module PrescriptionSection
 * @file PrescriptionSection.tsx
 * @author haelim
 * @date 2025-03-26
 * @description 반려동물 진단 처방을 관리하는 UI 컴포넌트입니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 */


/**
 * PrescriptionSection 컴포넌트의 Props 타입 정의
 */
interface PrescriptionSectionProps {
    prescriptions: any; // 현재 처방 목록
    setPrescriptions: React.Dispatch<any>; // 처방 목록을 업데이트하는 함수
    treatmentType: TreatmentType; // 현재 선택된 치료 유형
    setTreatmentType: React.Dispatch<React.SetStateAction<TreatmentType>>; // 치료 유형 변경 함수
    prescriptionType: string; // 입력된 처방 항목명
    setPrescriptionType: React.Dispatch<React.SetStateAction<string>>; // 처방 항목명 변경 함수
    prescriptionDosage: string; // 입력된 처방 용량
    setPrescriptionDosage: React.Dispatch<React.SetStateAction<string>>; // 처방 용량 변경 함수
}

/**
 * PrescriptionSection - 반려동물 처방을 관리하는 컴포넌트입니다
 */
const PrescriptionSection: FC<PrescriptionSectionProps> = ({
    prescriptions, setPrescriptions, treatmentType, setTreatmentType,
    prescriptionType, setPrescriptionType, prescriptionDosage, setPrescriptionDosage
}) => {
    /**
     * 처방을 추가하는 함수입니다. 
     * 사용자가 입력한 처방 항목명과 용량이 비어 있지 않다면, 해당 치료 유형에 맞는 배열에 추가합니다. 
     */
    const addPrescription = () => {
        if (prescriptionType.trim() && prescriptionDosage.trim()) {
            const newPrescription = {
                type: treatmentType,
                key: prescriptionType,
                value: prescriptionDosage
            };

            // 기존 처방 목록을 복사
            const updatedPrescriptions = { ...prescriptions };

            // 치료 유형에 따라 해당 배열에 추가
            if (treatmentType === TreatmentType.EXAMINATION) {
                updatedPrescriptions.examinations.push(newPrescription as ExaminationTreatment);
            } else if (treatmentType === TreatmentType.MEDICATION) {
                updatedPrescriptions.medications.push(newPrescription as MedicationTreatment);
            } else if (treatmentType === TreatmentType.VACCINATION) {
                updatedPrescriptions.vaccinations.push(newPrescription as VaccinationTreatment);
            }

            // 상태 업데이트 및 입력값 초기화
            setPrescriptions(updatedPrescriptions);
            setPrescriptionType('');
            setPrescriptionDosage('');
        }
    };

    /**
     * 처방을 삭제하는 함수입니다. 
     * 특정 인덱스의 처방 항목을 해당 치료 유형의 목록에서 제거합니다. 
     * @param index 삭제할 처방 항목의 인덱스
     * @param type 삭제할 처방 항목이 속한 치료 유형
     */
    const removePrescription = (index: number, type: TreatmentType) => {
        const updatedPrescriptions = { ...prescriptions };
        if (type === TreatmentType.EXAMINATION) {
            updatedPrescriptions.examinations.splice(index, 1);
        } else if (type === TreatmentType.MEDICATION) {
            updatedPrescriptions.medications.splice(index, 1);
        } else if (type === TreatmentType.VACCINATION) {
            updatedPrescriptions.vaccinations.splice(index, 1);
        }
        setPrescriptions(updatedPrescriptions);
    };

    return (
        <div className="flex gap-2 flex-col">
            {/* 처방 입력 필드 */}
            <div className="flex gap-2 items-center">
                {/* 치료 유형 선택 */}
                <select
                    value={treatmentType}
                    onChange={(e) => setTreatmentType(e.target.value as TreatmentType)}
                    className="text-sm border rounded w-24 py-1 px-2"
                >
                    {Object.values(TreatmentType).map((type) => (
                        <option key={type} value={type}>{type}</option>
                    ))}
                </select>

                {/* 처방 항목명 입력 */}
                <input
                    type="text"
                    value={prescriptionType}
                    onChange={(e) => setPrescriptionType(e.target.value)}
                    placeholder="약물"
                    className="flex-1 border rounded px-2 py-1 text-sm max-w-40"
                />

                {/* 처방 용량 입력 */}
                <input
                    type="text"
                    value={prescriptionDosage}
                    onChange={(e) => setPrescriptionDosage(e.target.value)}
                    placeholder="용량"
                    className="flex-1 border rounded px-2 py-1 text-sm max-w-40"
                />

                {/* 처방 추가 버튼 */}
                <button
                    onClick={addPrescription}
                    className="p-1 text-xs text-gray-500 h-7 w-7"
                >
                    <PlusCircle className="w-4 h-4" />
                </button>
            </div>

            {/* 기존 처방 목록 표시 */}
            <div className="flex gap-1 flex-col text-sm mr-9 p-2">
                {prescriptions.examinations.length > 0 && (
                    <div className="font-bold text-md mt-2">검사</div>
                )}
                {prescriptions.examinations.map((item: any, index: number) => (
                    <div key={index} className="flex gap-2 justify-between py-1 px-2 bg-primary-50 rounded-lg">
                        {/* <div>{item.type}</div> */}
                        <div>{item.key}</div>
                        <div>{item.value}</div>
                        <button onClick={() => removePrescription(index, TreatmentType.EXAMINATION)} className="text-primary-500 text-xs">x</button>
                    </div>
                ))}

                {prescriptions.medications.length > 0 && (
                    <div className="font-bold text-md">약물</div>
                )}
                {prescriptions.medications.map((item: any, index: number) => (
                    <div key={index} className="flex gap-2 justify-between py-1 px-2 bg-primary-50 rounded-lg">
                        {/* <div>{item.type}</div> */}
                        <div>{item.key}</div>
                        <div>{item.value}</div>
                        <button onClick={() => removePrescription(index, TreatmentType.MEDICATION)} className="text-primary-500 text-xs">x</button>
                    </div>
                ))}
                {prescriptions.vaccinations.length > 0 && (
                    <div className="font-bold text-md mt-2">접종</div>
                )}
                {prescriptions.vaccinations.map((item: any, index: number) => (
                    <div key={index} className="flex gap-2 justify-between py-1 px-2 bg-primary-50 rounded-lg">
                        {/* <div>{item.type}</div> */}
                        <div>{item.key}</div>
                        <div>{item.value}</div>
                        <button onClick={() => removePrescription(index, TreatmentType.VACCINATION)} className="text-primary-500 text-xs">x</button>
                    </div>
                ))}
            </div>
        </div>
    );
};

export default PrescriptionSection;


import React, { useState } from 'react';
import {FaCamera, FaRegSave} from 'react-icons/fa';

interface TreatmentFormProps {
  onSave: () => void;
}

export const TreatmentForm: React.FC<TreatmentFormProps> = ({ onSave }) => {
  const [symptoms, setSymptoms] = useState('');
  const [prescriptionType, setPrescriptionType] = useState('');
  const [prescriptionDosage, setPrescriptionDosage] = useState('');

  return (
    <div className="flex-1 flex gap-5 bg-white p-4 rounded-lg border">
      <div className="flex flex-col flex-1">
        {/* 상단 헤더, 날짜, 저장 버튼 */}
        <div className="px-1 flex justify-between items-center">
          <div className="font-bold text-xl">
            {new Date().toLocaleDateString('ko-KR', { 
              year: 'numeric', 
              month: '2-digit', 
              day: '2-digit' 
            })}
          </div>
          <div className="flex gap-2 h-8">
            <select className="px-2 py-1 border rounded-md text-xs font-medium text-primary-500 border-primary-500 text-nowrap w-20 justify-center">
              <option value="의사1">김닥터</option>
              <option value="의사2">권닥터</option>
            </select>
            <button 
              onClick={onSave}
              className="flex gap-1 bg-primary-500 hover:bg-primary-600 text-white text-xs font-medium px-3 py-2 rounded-md transition flex items-center overflow-nowrap w-20 justify-center"
            >
              <FaRegSave></FaRegSave>
              저장
            </button>
          </div>
        </div> {/* 상단 헤더, 날짜, 저장 버튼 종료*/}


        <div className="flex flex-1 gap-5 mt-3">
          {/* 좌측 영역*/}
          <div className="flex-1 flex flex-col gap-2">
            <div>
              <label className="block ml-1 mb-2 font-bold flex items-center">
                {/* <FaNotesMedical className="mr-2 text-gray-500" /> */}
                증상
              </label>
              <textarea
                value={symptoms}
                onChange={(e) => setSymptoms(e.target.value)}
                className="w-full border border-gray-300 rounded-md p-3 h-20 transition text-sm"
                placeholder="증상을 상세히 입력해주세요"
              />
            </div>

            <div>
            <label className="block ml-1 mb-2 font-bold flex items-center">
                처방
              </label>
              <div className="flex space-x-2 items-center">
                <input
                  type="text"
                  value={prescriptionType}
                  onChange={(e) => setPrescriptionType(e.target.value)}
                  placeholder="약물"
                  className="flex-1 border rounded-md px-2 py-1 text-sm"
                />
                <input
                  type="text"
                  value={prescriptionDosage}
                  onChange={(e) => setPrescriptionDosage(e.target.value)}
                  placeholder="용량"
                  className="flex-1 border rounded-md px-2 py-1 text-sm"
                />
                <button className="px-3 py-1 rounded-md text-xs bg-primary-500 text-white text-nowrap h-7">
                  추가
                </button>
              </div>
            </div>
          </div>

          {/* 우측 영역 */}
          <div className="flex-1 flex flex-col gap-2">
            <div className="">
            <label className="block ml-1 mb-2 font-bold flex items-center">
              사진
              </label>
              <div className="grid grid-cols-4 gap-1.5 justify-start overflow-hidden">
                <div className="bg-gray-50 rounded-md h-20 w-20 aspect-square flex items-center justify-center border-2 border-dashed border-gray-300">
                  <FaCamera className="text-gray-400" />
                </div>
                
              </div>
            </div>

            <div className="flex-1 flex flex-col mt-1">
              <label className="block ml-1 mb-2 font-bold flex items-center">
                메모
              </label>
              <textarea
                className="w-full border border-gray-300 rounded-md p-3 transition text-sm flex-1"
                placeholder="추가 메모 사항을 입력해주세요"
              />
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default TreatmentForm;
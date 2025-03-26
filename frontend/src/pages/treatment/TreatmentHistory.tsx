import React from 'react';
import { BlockChainRecord } from '@/interfaces';


const TreatmentHistory: React.FC = () => {

  const records: BlockChainRecord[] = [
    {
      diagnosis: "감기",
      treatments: {
        tests: [
          { type: "혈액 검사", description: "백혈구 수치 확인" },
          { type: "X-ray", description: "폐 상태 확인" }
        ],
        medications: [
          { type: "타이레놀", dosage: 3 },
          { type: "항생제", dosage: 2 }
        ],
        vaccinations: [
          { type: "독감 예방 접종", doseNumber: 1 }
        ]
      },
      doctorName: "김의사",
      notes: "휴식과 수분 섭취 권장",
      hospitalAddress: "서울특별시 강남구 병원로 123",
      hospitalName: "서울 중앙 병원",
      createdAt: "2025.03.26",
      isDeleted: false,
      pictures: [
        "https://example.com/image1.jpg",
        "https://example.com/image2.jpg"
      ]
    },
    {
      diagnosis: "알레르기",
      treatments: {
        tests: [
          { type: "피부 반응 검사", description: "알레르기 원인 확인" }
        ],
        medications: [
          { type: "항히스타민제", dosage: 1 }
        ],
        vaccinations: []
      },
      doctorName: "이의사",
      notes: "알레르기 유발 물질 회피 필요",
      hospitalAddress: "부산광역시 해운대구 병원로 45",
      hospitalName: "부산 해운대 병원",
      createdAt: "2025.03.25",
      isDeleted: false,
      pictures: []
    }
  ];
  
  
  return (

    
    <div className="flex gap-5">
            <div className="flex-1">
              <h3 className="font-bold text-gray-800 m-1">우리 병원 기록</h3>

              <div className="flex flex-col gap-2 overflow-y-auto max-h-[calc(100vh-265px)]">
              {records.map((record, idx) => (
                          <div key={idx} className="bg-white p-4 rounded-lg border border-gray-200 hover:shadow transition cursor-pointer">
                            <div className="flex justify-between items-center">
                              <div className="flex items-center gap-2">
                                <div>
                                  <div className="font-semibold text-gray-800">{record.diagnosis}</div>
                                  <div className="text-sm text-gray-500">{record.createdAt}</div>
                                </div>
                              </div>
                              <div className="text-xs text-gray-600">
                                기록: {record.hospitalName}
                              </div>
                            </div>
                          </div>
              ))}
              </div>
            </div>

            <div className="flex-1">
              <h3 className="font-bold text-gray-800 m-1">전체 진료 기록</h3>

              <div className="flex flex-col gap-2 overflow-y-auto max-h-[calc(100vh-265px)]">
              {records.map((record, idx) => (
                          <div key={idx} className="bg-white p-4 rounded-lg border border-gray-200 hover:shadow transition cursor-pointer">
                            <div className="flex justify-between items-center">
                              <div className="flex items-center gap-2">
                                <div>
                                  <div className="font-semibold text-gray-800">{record.diagnosis}</div>
                                  <div className="text-sm text-gray-500">{record.createdAt}</div>
                                </div>
                              </div>
                              <div className="text-xs text-gray-600">
                                기록: {record.hospitalName}
                              </div>
                            </div>
                          </div>
              ))}
              </div>
            </div>
          </div>
  );
};

export default TreatmentHistory;
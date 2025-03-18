import React, { useState } from 'react';

// 임시 데이터 타입 정의
interface Treatment {
  id: string;
  date: string;
  petName: string;
  symptoms: string;
  diagnosis: string;
  treatment: string;
  status: 'completed' | 'pending' | 'canceled';
}

// 임시 진료 기록 데이터
const mockTreatments: Treatment[] = [
  {
    id: '1',
    date: '2023-05-15',
    petName: '맥스',
    symptoms: '식욕 감소, 무기력',
    diagnosis: '경미한 소화 장애',
    treatment: '소화제 처방, 식이요법 권장',
    status: 'completed'
  },
  {
    id: '2',
    date: '2023-06-20',
    petName: '맥스',
    symptoms: '피부 가려움, 발적',
    diagnosis: '알레르기성 피부염',
    treatment: '항히스타민제 처방, 국소 스테로이드 연고',
    status: 'completed'
  },
  {
    id: '3',
    date: '2023-07-05',
    petName: '맥스',
    symptoms: '예방접종',
    diagnosis: '건강검진',
    treatment: '종합백신 접종',
    status: 'completed'
  }
];

const TreatmentHistory: React.FC = () => {
  const [treatments] = useState<Treatment[]>(mockTreatments);
  const [selectedTreatment, setSelectedTreatment] = useState<Treatment | null>(null);
  
  // 상태에 따른 배지 색상 클래스
  const getStatusBadgeClass = (status: Treatment['status']) => {
    switch (status) {
      case 'completed':
        return 'bg-green-100 text-green-800 dark:bg-green-800 dark:text-green-100';
      case 'pending':
        return 'bg-yellow-100 text-yellow-800 dark:bg-yellow-800 dark:text-yellow-100';
      case 'canceled':
        return 'bg-red-100 text-red-800 dark:bg-red-800 dark:text-red-100';
      default:
        return 'bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300';
    }
  };
  
  // 상태 텍스트
  const getStatusText = (status: Treatment['status']) => {
    switch (status) {
      case 'completed':
        return '완료';
      case 'pending':
        return '대기중';
      case 'canceled':
        return '취소됨';
      default:
        return '알 수 없음';
    }
  };
  
  return (
    <div className="bg-white rounded-lg shadow-sm dark:bg-gray-800">
      <div className="p-6">
        <h2 className="text-xl font-semibold mb-4 text-gray-800 dark:text-gray-200">진료 기록</h2>
        
        <div className="space-y-6">
          {treatments.length > 0 ? (
            <div className="overflow-x-auto">
              <table className="min-w-full divide-y divide-gray-200 dark:divide-gray-700">
                <thead className="bg-gray-50 dark:bg-gray-700">
                  <tr>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                      날짜
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                      진단
                    </th>
                    <th scope="col" className="px-6 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                      상태
                    </th>
                    <th scope="col" className="px-6 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider dark:text-gray-300">
                      상세
                    </th>
                  </tr>
                </thead>
                <tbody className="bg-white divide-y divide-gray-200 dark:bg-gray-800 dark:divide-gray-700">
                  {treatments.map((treatment) => (
                    <tr key={treatment.id} className="hover:bg-gray-50 dark:hover:bg-gray-700">
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                        {treatment.date}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-sm text-gray-500 dark:text-gray-400">
                        {treatment.diagnosis}
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap">
                        <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${getStatusBadgeClass(treatment.status)}`}>
                          {getStatusText(treatment.status)}
                        </span>
                      </td>
                      <td className="px-6 py-4 whitespace-nowrap text-right text-sm font-medium">
                        <button
                          onClick={() => setSelectedTreatment(treatment)}
                          className="text-indigo-600 hover:text-indigo-900 dark:text-indigo-400 dark:hover:text-indigo-300"
                        >
                          상세보기
                        </button>
                      </td>
                    </tr>
                  ))}
                </tbody>
              </table>
            </div>
          ) : (
            <div className="text-center py-10 text-gray-500 dark:text-gray-400">
              진료 기록이 없습니다.
            </div>
          )}
          
          {/* 선택된 진료 기록 상세 정보 */}
          {selectedTreatment && (
            <div className="mt-6 bg-gray-50 p-4 rounded-lg dark:bg-gray-700">
              <div className="flex justify-between items-center mb-4">
                <h3 className="text-lg font-medium text-gray-900 dark:text-gray-100">
                  진료 상세 정보
                </h3>
                <button
                  onClick={() => setSelectedTreatment(null)}
                  className="text-gray-400 hover:text-gray-500 dark:text-gray-300 dark:hover:text-gray-200"
                >
                  닫기
                </button>
              </div>
              <div className="space-y-4">
                <div>
                  <h4 className="text-sm font-medium text-gray-500 dark:text-gray-400">날짜</h4>
                  <p className="mt-1 text-sm text-gray-900 dark:text-gray-100">{selectedTreatment.date}</p>
                </div>
                <div>
                  <h4 className="text-sm font-medium text-gray-500 dark:text-gray-400">반려동물</h4>
                  <p className="mt-1 text-sm text-gray-900 dark:text-gray-100">{selectedTreatment.petName}</p>
                </div>
                <div>
                  <h4 className="text-sm font-medium text-gray-500 dark:text-gray-400">증상</h4>
                  <p className="mt-1 text-sm text-gray-900 dark:text-gray-100">{selectedTreatment.symptoms}</p>
                </div>
                <div>
                  <h4 className="text-sm font-medium text-gray-500 dark:text-gray-400">진단</h4>
                  <p className="mt-1 text-sm text-gray-900 dark:text-gray-100">{selectedTreatment.diagnosis}</p>
                </div>
                <div>
                  <h4 className="text-sm font-medium text-gray-500 dark:text-gray-400">치료</h4>
                  <p className="mt-1 text-sm text-gray-900 dark:text-gray-100">{selectedTreatment.treatment}</p>
                </div>
                <div>
                  <h4 className="text-sm font-medium text-gray-500 dark:text-gray-400">상태</h4>
                  <p className="mt-1">
                    <span className={`px-2 inline-flex text-xs leading-5 font-semibold rounded-full ${getStatusBadgeClass(selectedTreatment.status)}`}>
                      {getStatusText(selectedTreatment.status)}
                    </span>
                  </p>
                </div>
              </div>
            </div>
          )}
        </div>
      </div>
    </div>
  );
};

export default TreatmentHistory; 
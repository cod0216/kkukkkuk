import React from 'react';
import { BlockChainTreatment } from '@/interfaces';

interface TreatmentHistoryProps {
  treatments: BlockChainTreatment[]
}


const TreatmentHistory: React.FC<TreatmentHistoryProps> = ({ treatments }) => {
  return (
    <div className="flex gap-5">
            <div className="flex-1">
              <h3 className="font-bold text-gray-800 m-1">우리 병원 기록</h3>

              <div className="flex flex-col gap-2 overflow-y-auto max-h-[calc(100vh-265px)]">
              {treatments.map((record, idx) => (
                          <div key={idx} className="bg-white p-4 rounded-lg border border-gray-200 hover:shadow transition cursor-pointer">
                            <div className="flex justify-between items-center">
                              <div className="flex items-center gap-2">
                                <div>
                                  <div className="font-semibold text-gray-800">{record.disease}</div>
                                  <div className="text-sm text-gray-500">{record.date}</div>
                                </div>
                              </div>
                              <div className="text-xs text-gray-600">
                                기록: {record.hospital}
                              </div>
                            </div>
                          </div>
              ))}
              </div>
            </div>

            <div className="flex-1">
              <h3 className="font-bold text-gray-800 m-1">전체 진료 기록</h3>

              <div className="flex flex-col gap-2 overflow-y-auto max-h-[calc(100vh-265px)]">
              {treatments.map((record, idx) => (
                          <div key={idx} className="bg-white p-4 rounded-lg border border-gray-200 hover:shadow transition cursor-pointer">
                            <div className="flex justify-between items-center">
                              <div className="flex items-center gap-2">
                                <div>
                                  <div className="font-semibold text-gray-800">{record.disease}</div>
                                  <div className="text-sm text-gray-500">{record.date}</div>
                                </div>
                              </div>
                              <div className="text-xs text-gray-600">
                                기록: {record.hospital}
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
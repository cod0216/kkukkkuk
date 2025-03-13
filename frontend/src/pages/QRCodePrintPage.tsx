import React, { useRef, useEffect } from 'react';
import { useAppSelector } from '../redux/hooks';
import { selectLoggedInHospital } from '../redux/slices/authSlice';
import { QRCodeSVG } from 'qrcode.react';

const QRCodePrintPage: React.FC = () => {
  const hospital = useAppSelector(selectLoggedInHospital) || { name: "동물사랑병원", did: "did:hospital:example" };
  const printRef = useRef<HTMLDivElement>(null);
  
  // 페이지 로딩 시 자동 인쇄 다이얼로그 표시
  useEffect(() => {
    // 약간의 지연을 두고 인쇄 다이얼로그 실행 (렌더링 완료 확보)
    const timer = setTimeout(() => {
      window.print();
    }, 500);
    
    return () => clearTimeout(timer);
  }, []);
  
  return (
    <div className="flex flex-col items-center justify-center min-h-screen bg-gray-100 p-8" ref={printRef}>
      <div className="bg-white shadow-lg rounded-lg p-8 max-w-md w-full print:shadow-none">
        <div className="text-center mb-6">
          <h1 className="text-2xl font-bold text-gray-800">{hospital.name}</h1>
          <p className="text-sm text-gray-600 mt-1">병원 DID: {hospital.did}</p>
        </div>
        
        <div className="flex justify-center mb-6">
          <div className="border p-4 bg-white rounded">
            <QRCodeSVG 
              value={hospital.did || "did:hospital:example"} 
              size={200}
              level="H"
            />
          </div>
        </div>
        
        <div className="text-center text-sm text-gray-600">
          <p>이 QR 코드를 스캔하여 병원 정보를 확인하세요.</p>
          <p className="mt-1">스캔 후 환자 앱에서 진료 기록을 조회할 수 있습니다.</p>
        </div>
        
        <div className="mt-8 text-center print:hidden">
          <button 
            onClick={() => window.print()}
            className="bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded transition-colors"
          >
            인쇄하기
          </button>
          <button 
            onClick={() => window.close()}
            className="ml-4 bg-gray-500 hover:bg-gray-600 text-white py-2 px-4 rounded transition-colors"
          >
            닫기
          </button>
        </div>
      </div>
    </div>
  );
};

export default QRCodePrintPage; 
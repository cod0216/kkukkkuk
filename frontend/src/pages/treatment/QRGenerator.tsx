import React from 'react';
import { QRCodeSVG } from 'qrcode.react';
import { useSelector } from 'react-redux';
import { RootState } from '@/redux/store';

/**
 * @module QRGenerator
 * @file QRGenerator.tsx
 * @author seonghun
 * @date 2025-03-28
 * @description 병원 정보를 담은 QR 코드를 생성하는 UI 컴포넌트입니다.
 *              병원 정보를 기반으로 QR 코드를 생성하고 표시합니다.
 *              
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         antd 의존성 제거 및 기본 HTML/CSS로 구현
 * 2025-03-28        seonghun         로그인 토큰에서 병원명 가져오기 추가
 */


interface QRGeneratorProps {
  visible: boolean;
  onClose: () => void;
  hospitalInfo: {
    name: string;
    address: string;
    did: string;
  };
}

const QRGenerator: React.FC<QRGeneratorProps> = ({ visible, onClose, hospitalInfo }) => {
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
      return payload.name || hospitalInfo.name;
    } catch (error) {
      console.error("토큰 디코딩 실패", error);
      return hospitalInfo.name;
    }
  };

  // 실제 병원명 가져오기 (토큰에서 가져오거나 props로 받은 값 사용)
  const actualHospitalName = accessToken 
    ? getHospitalNameFromToken(accessToken) 
    : hospitalInfo.name;
  
  // 병원 DID 형식 생성
  const hospitalDID = `did:hospital:${hospitalInfo.address}`;
  
  // QR 코드에 포함될 데이터 생성
  const qrData = JSON.stringify({
    type: 'hospital',
    name: actualHospitalName,
    address: hospitalInfo.address,
    did: hospitalDID
  });

  // QR 코드 다운로드 함수
  const handleDownload = () => {
    const canvas = document.getElementById('qr-code') as HTMLCanvasElement;
    if (canvas) {
      const url = canvas.toDataURL('image/png');
      const link = document.createElement('a');
      link.download = `hospital-qr-${actualHospitalName}.png`;
      link.href = url;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    }
  };

  if (!visible) return null;

  return (
    <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
      <div className="bg-white rounded-lg shadow-lg w-full max-w-md overflow-hidden">
        {/* 모달 헤더 */}
        <div className="border-b p-4 flex justify-between items-center">
          <h2 className="text-lg font-semibold text-gray-800">병원 QR 코드</h2>
          <button 
            onClick={onClose}
            className="text-gray-500 hover:text-gray-700"
          >
            <svg className="w-5 h-5" fill="currentColor" viewBox="0 0 20 20">
              <path fillRule="evenodd" d="M4.293 4.293a1 1 0 011.414 0L10 8.586l4.293-4.293a1 1 0 111.414 1.414L11.414 10l4.293 4.293a1 1 0 01-1.414 1.414L10 11.414l-4.293 4.293a1 1 0 01-1.414-1.414L8.586 10 4.293 5.707a1 1 0 010-1.414z" clipRule="evenodd" />
            </svg>
          </button>
        </div>
        
        {/* 모달 내용 */}
        <div className="p-6">
          <div className="flex flex-col space-y-6">
            {/* QR 코드 */}
            <div className="flex justify-center p-4">
              <QRCodeSVG
                id="qr-code"
                value={qrData}
                size={200}
                level="H"
                includeMargin={true}
              />
            </div>
            
            {/* 병원 정보 */}
            <div className="bg-gray-50 p-4 rounded-lg">
              <h3 className="font-bold text-gray-800 mb-2">병원 정보</h3>
              <div className="space-y-1 text-sm break-words">
                <p><span className="font-semibold">병원명:</span> {actualHospitalName}</p>
                <p className="break-all"><span className="font-semibold">주소:</span> {hospitalInfo.address}</p>
                <p className="break-all"><span className="font-semibold">DID:</span> {hospitalDID}</p>
              </div>
            </div>
            
            <p className="text-xs text-gray-500">
              * 이 QR 코드는 병원 정보를 포함하고 있으며, 보호자 앱에서 스캔하여 진료기록 공유를 시작할 수 있습니다.
            </p>
          </div>
        </div>
        
        {/* 모달 푸터 */}
        <div className="border-t p-4 flex justify-end space-x-2">
          <button 
            onClick={handleDownload}
            className="bg-primary-500 hover:bg-primary-600 text-white py-2 px-4 rounded-md text-sm flex items-center"
          >
            <svg className="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M4 16v1a3 3 0 003 3h10a3 3 0 003-3v-1m-4-4l-4 4m0 0l-4-4m4 4V4" />
            </svg>
            QR 코드 다운로드
          </button>
          <button 
            onClick={onClose}
            className="border border-gray-300 text-gray-700 py-2 px-4 rounded-md text-sm hover:bg-gray-50"
          >
            닫기
          </button>
        </div>
      </div>
    </div>
  );
};

export default QRGenerator;

import React, { useRef } from 'react';
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
  const qrContainerRef = useRef<HTMLDivElement>(null);
  
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

  // SVG를 이미지로 변환하는 함수
  const svgToImage = (callback: (dataUrl: string) => void) => {
    if (!qrContainerRef.current) return;
    
    const svg = qrContainerRef.current.querySelector('svg');
    if (!svg) return;
    
    const svgData = new XMLSerializer().serializeToString(svg);
    const canvas = document.createElement('canvas');
    const ctx = canvas.getContext('2d');
    
    // 해상도 향상을 위한 스케일 팩터 설정 (4배 더 높은 해상도)
    const scaleFactor = 4;
    
    const img = new Image();
    img.onload = () => {
      // 원본 크기의 4배로 캔버스 크기 설정
      canvas.width = img.width * scaleFactor;
      canvas.height = img.height * scaleFactor;
      
      // 배경색 하얀색으로 설정 (더 선명한 QR코드를 위해)
      if (ctx) {
        ctx.fillStyle = '#FFFFFF';
        ctx.fillRect(0, 0, canvas.width, canvas.height);
        
        // 이미지를 확대하여 그림
        ctx.drawImage(img, 0, 0, canvas.width, canvas.height);
      }
      
      // 고품질 PNG로 변환 (품질 설정)
      const dataUrl = canvas.toDataURL('image/png', 1.0);
      callback(dataUrl);
    };
    
    // SVG 데이터를 Base64로 인코딩
    img.src = 'data:image/svg+xml;base64,' + btoa(unescape(encodeURIComponent(svgData)));
  };

  // QR 코드 다운로드 함수
  const handleDownload = () => {
    svgToImage((dataUrl) => {
      const link = document.createElement('a');
      link.download = `hospital-qr-${actualHospitalName}.png`;
      link.href = dataUrl;
      document.body.appendChild(link);
      link.click();
      document.body.removeChild(link);
    });
  };
  
  // QR 코드 인쇄 함수
  const handlePrint = () => {
    svgToImage((dataUrl) => {
      const printWindow = window.open('', '_blank');
      if (!printWindow) {
        alert('팝업 차단을 해제해주세요.');
        return;
      }
      
      printWindow.document.write(`
        <html>
          <head>
            <title>병원 QR 코드 인쇄</title>
            <style>
              body { font-family: Arial, sans-serif; text-align: center; padding: 20px; }
              .container { max-width: 400px; margin: 0 auto; }
              .info { margin-top: 20px; text-align: left; padding: 10px; border: 1px solid #eee; }
              h2 { margin-bottom: 20px; }
              img { max-width: 100%; height: auto; }
              .qr-wrapper { padding: 10px; border: 1px solid #eee; display: inline-block; margin-bottom: 15px; }
              p { margin: 5px 0; }
              @media print {
                button { display: none; }
              }
            </style>
          </head>
          <body>
            <div class="container">
              <h2>${actualHospitalName} QR 코드</h2>
              <div class="qr-wrapper">
                <img src="${dataUrl}" alt="병원 QR 코드" />
              </div>
              <div class="info">
                <p><strong>병원명:</strong> ${actualHospitalName}</p>
                <p><strong>주소:</strong> ${hospitalInfo.address}</p>
                <p><strong>DID:</strong> ${hospitalDID}</p>
              </div>
              <button onclick="window.print();setTimeout(function(){window.close();},500);" style="margin-top: 20px; padding: 10px 20px; cursor: pointer;">인쇄하기</button>
            </div>
          </body>
        </html>
      `);
      
      printWindow.document.close();
    });
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
            <div ref={qrContainerRef} className="flex justify-center p-4">
              <QRCodeSVG
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
            onClick={handlePrint}
            className="bg-green-500 hover:bg-green-600 text-white py-2 px-4 rounded-md text-sm flex items-center"
          >
            <svg className="w-4 h-4 mr-1" fill="none" stroke="currentColor" viewBox="0 0 24 24" xmlns="http://www.w3.org/2000/svg">
              <path strokeLinecap="round" strokeLinejoin="round" strokeWidth="2" d="M17 17h2a2 2 0 002-2v-4a2 2 0 00-2-2H5a2 2 0 00-2 2v4a2 2 0 002 2h2m2 4h6a2 2 0 002-2v-4a2 2 0 00-2-2H9a2 2 0 00-2 2v4a2 2 0 002 2zm8-12V5a2 2 0 00-2-2H9a2 2 0 00-2 2v4h10z" />
            </svg>
            인쇄하기
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

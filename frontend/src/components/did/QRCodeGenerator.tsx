import React, { useState } from 'react';

const QRCodeGenerator: React.FC = () => {
  const [isOpen, setIsOpen] = useState(false);
  const [qrData] = useState({
    did: 'did:hospital:123456789',
    name: 'SSAFY 동물병원',
    createdAt: new Date().toISOString()
  });

  const openModal = () => setIsOpen(true);
  const closeModal = () => setIsOpen(false);
  
  // 실제 QR 코드는 추후 구현
  const mockQRCodeUrl = 'https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=' + encodeURIComponent(qrData.did);
  
  return (
    <>
      {/* 모달 */}
      {isOpen && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 dark:bg-gray-800">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-xl font-semibold text-gray-900 dark:text-gray-100">
                병원 식별 QR 코드
              </h3>
              <button 
                onClick={closeModal}
                className="text-gray-400 hover:text-gray-500 dark:text-gray-300 dark:hover:text-gray-200"
              >
                닫기
              </button>
            </div>
            
            <div className="flex flex-col items-center justify-center space-y-4">
              <div className="bg-white p-4 rounded-lg">
                <img src={mockQRCodeUrl} alt="QR Code" className="max-w-full h-auto" />
              </div>
              
              <div className="text-center space-y-2">
                <p className="text-sm text-gray-600 dark:text-gray-400">
                  <span className="font-medium">병원명:</span> {qrData.name}
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-400">
                  <span className="font-medium">DID:</span> {qrData.did}
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-400">
                  <span className="font-medium">생성일:</span> {new Date(qrData.createdAt).toLocaleDateString()}
                </p>
              </div>
              
              <div className="flex space-x-4">
                <button
                  onClick={() => {
                    /* 인쇄 기능 */
                    window.print();
                  }}
                  className="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                  인쇄하기
                </button>
                <button
                  onClick={() => {
                    /* 다운로드 기능 */
                    alert('QR 코드 이미지 다운로드 기능은 아직 구현되지 않았습니다.');
                  }}
                  className="px-4 py-2 bg-gray-200 text-gray-800 rounded-md hover:bg-gray-300 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-gray-500 dark:bg-gray-700 dark:text-gray-200 dark:hover:bg-gray-600"
                >
                  다운로드
                </button>
              </div>
            </div>
          </div>
        </div>
      )}
      
      {/* 실제 구현 시에는 App.tsx나 Dashboard.tsx에서 버튼 제공하여 모달 표시 */}
    </>
  );
};

export default QRCodeGenerator; 
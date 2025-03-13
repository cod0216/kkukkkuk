import React, { useEffect, useRef } from 'react';
import { useAppDispatch, useAppSelector } from '../../redux/store';
import { generateHospitalDID, toggleQRCodeVisibility, setShowQRCode, DIDInfo } from '../../redux/slices/didSlice';
import ReactQRCode from 'react-qr-code';
import { FiX, FiCopy, FiPrinter } from 'react-icons/fi';
import { toast } from 'react-toastify';

// 아이콘 props 인터페이스 정의
interface IconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  color?: string;
  className?: string;
}

// 아이콘 컴포넌트를 위한 타입 단언
const IconClose = FiX as unknown as React.ComponentType<IconProps>;
const IconCopy = FiCopy as unknown as React.ComponentType<IconProps>;
const IconPrinter = FiPrinter as unknown as React.ComponentType<IconProps>;

interface DIDState {
  didInfo: DIDInfo | null;
  showQRCode: boolean;
}

interface AuthState {
  user: {
    id: string;
    username: string;
    hospitalName?: string;
  } | null;
}

const QRCodeGenerator: React.FC = () => {
  const dispatch = useAppDispatch();
  const { didInfo, showQRCode } = useAppSelector(state => state.did as DIDState);
  const { user } = useAppSelector(state => state.auth as AuthState);
  const qrCodeRef = useRef<HTMLDivElement>(null);

  // 컴포넌트 마운트 시 로그 출력
  useEffect(() => {
    console.log('QRCodeGenerator 마운트됨, showQRCode:', showQRCode);
  }, [showQRCode]);

  useEffect(() => {
    // 병원 이름이 있고 DID가 아직 생성되지 않았다면 DID 생성
    if (user?.hospitalName && !didInfo) {
      dispatch(generateHospitalDID({ hospitalName: user.hospitalName }));
    }
  }, [user, didInfo, dispatch]);

  // QR 코드 생성이 필요한 경우 더미 데이터 사용
  const qrCodeValue = didInfo?.qrCodeValue || JSON.stringify({
    did: 'did:kkuk:dummy',
    hospitalName: user?.hospitalName || '테스트 병원',
    timestamp: new Date().toISOString(),
    type: 'hospital'
  });

  if (!showQRCode) {
    return null;
  }

  const handleClose = () => {
    console.log('QR 코드 닫기 버튼 클릭됨');
    dispatch(setShowQRCode(false));
  };

  // DID 복사 기능
  const handleCopyDID = () => {
    const didValue = didInfo?.did || 'did:kkuk:dummy';
    navigator.clipboard.writeText(didValue)
      .then(() => {
        toast.success('DID가 클립보드에 복사되었습니다.');
      })
      .catch((err) => {
        console.error('클립보드 복사 실패:', err);
        toast.error('복사에 실패했습니다. 직접 선택하여 복사해주세요.');
      });
  };

  // QR 코드 인쇄 기능
  const handlePrint = () => {
    if (!qrCodeRef.current) return;

    const printWindow = window.open('', '_blank');
    if (!printWindow) {
      toast.error('팝업 창이 차단되었습니다. 팝업 차단을 해제해주세요.');
      return;
    }

    const hospitalName = user?.hospitalName || '동물병원';
    
    printWindow.document.write(`
      <!DOCTYPE html>
      <html>
        <head>
          <title>${hospitalName} DID QR 코드</title>
          <style>
            body {
              font-family: Arial, sans-serif;
              display: flex;
              flex-direction: column;
              align-items: center;
              justify-content: center;
              height: 100vh;
              margin: 0;
              padding: 20px;
            }
            .container {
              text-align: center;
            }
            .qr-code {
              margin: 20px auto;
              padding: 20px;
              border: 1px solid #ccc;
              background: white;
              display: inline-block;
            }
            h1 {
              margin-bottom: 10px;
              color: #333;
            }
            p {
              color: #666;
              margin-bottom: 5px;
            }
            .did-text {
              font-size: 12px;
              color: #888;
              margin-top: 10px;
              word-break: break-all;
            }
            @media print {
              button {
                display: none;
              }
            }
          </style>
        </head>
        <body>
          <div class="container">
            <h1>${hospitalName}</h1>
            <p>블록체인 기반 반려동물 진료정보 공유 시스템</p>
            <div class="qr-code">
              ${qrCodeRef.current.innerHTML}
            </div>
            <div class="did-text">
              DID: ${didInfo?.did || 'did:kkuk:dummy'}
            </div>
            <p style="margin-top: 20px;">위 QR 코드를 보호자 앱에서 스캔하면 블록체인을 통한 진료정보 공유가 가능합니다.</p>
            <button style="margin-top: 30px; padding: 10px 20px;" onclick="window.print(); setTimeout(() => window.close(), 500);">
              인쇄하기
            </button>
          </div>
        </body>
      </html>
    `);
    
    printWindow.document.close();
  };

  return (
    <div className="fixed inset-0 z-50 flex items-center justify-center bg-black bg-opacity-50">
      <div className="relative w-full max-w-md p-6 bg-white rounded-lg shadow-lg dark:bg-gray-800">
        <button
          onClick={handleClose}
          className="absolute p-1 text-gray-400 bg-gray-100 rounded-full top-3 right-3 dark:bg-gray-700 dark:text-gray-300 hover:bg-gray-200 dark:hover:bg-gray-600"
          aria-label="닫기"
        >
          <IconClose size={20} />
        </button>
        
        <h2 className="mb-4 text-xl font-semibold text-center text-gray-800 dark:text-white">병원 DID QR 코드</h2>
        
        <div className="flex flex-col items-center">
          <div ref={qrCodeRef} className="p-4 bg-white rounded-lg">
            <ReactQRCode 
              value={qrCodeValue} 
              size={200}
              level="H"
              bgColor="#FFFFFF"
              fgColor="#000000"
            />
          </div>
          
          <div className="mt-4 text-center">
            <p className="text-sm text-gray-600 dark:text-gray-300">
              위 QR 코드를 보호자 앱에서 스캔하면<br />
              블록체인을 통한 진료정보 공유가 가능합니다.
            </p>
            
            <div className="mt-2 text-xs text-gray-500 dark:text-gray-400 break-all">
              <span>DID: {didInfo?.did || 'did:kkuk:dummy'}</span>
            </div>
            
            <div className="grid grid-cols-2 gap-2 mt-4">
              <button
                onClick={handleCopyDID}
                className="flex items-center justify-center px-4 py-2 text-white bg-primary rounded-md hover:bg-opacity-90"
              >
                <IconCopy className="mr-2" />
                복사하기
              </button>
              <button
                onClick={handlePrint}
                className="flex items-center justify-center px-4 py-2 text-white bg-green-600 rounded-md hover:bg-green-700"
              >
                <IconPrinter className="mr-2" />
                인쇄하기
              </button>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
};

export default QRCodeGenerator; 
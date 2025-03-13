import React, { useState, useRef } from 'react';
import { FiUpload, FiEdit2 } from 'react-icons/fi';
import { toast } from 'react-toastify';
// 실제 OCR 서비스가 구현되면 주석 해제
// import { processBusinessLicense } from '../../services/ocrService';

// 아이콘 props 인터페이스 정의
interface IconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  color?: string;
  className?: string;
}

// 아이콘 컴포넌트를 위한 타입 단언
const IconUpload = FiUpload as unknown as React.ComponentType<IconProps>;
const IconEdit = FiEdit2 as unknown as React.ComponentType<IconProps>;

interface BusinessLicenseData {
  registrationNumber: string;
  companyName: string;
  ownerName: string;
  openDate: string;
  address: string;
  businessType: string;
}

interface BusinessLicenseUploadProps {
  onDataExtracted: (data: BusinessLicenseData) => void;
}

const BusinessLicenseUpload: React.FC<BusinessLicenseUploadProps> = ({ onDataExtracted }) => {
  const [file, setFile] = useState<File | null>(null);
  const [preview, setPreview] = useState<string>('');
  const [isProcessing, setIsProcessing] = useState(false);
  const [extractedData, setExtractedData] = useState<BusinessLicenseData>({
    registrationNumber: '',
    companyName: '',
    ownerName: '',
    openDate: '',
    address: '',
    businessType: ''
  });
  const [isEditing, setIsEditing] = useState(false);
  const fileInputRef = useRef<HTMLInputElement>(null);

  // 임시 OCR 처리 함수 (테스트용)
  const simulateOCRProcessing = (file: File): Promise<BusinessLicenseData> => {
    return new Promise((resolve) => {
      // 실제 API 요청을 시뮬레이션하기 위해 약간의 지연 추가
      setTimeout(() => {
        // 더미 데이터 반환
        resolve({
          registrationNumber: '123-45-67890',
          companyName: '우수동물병원',
          ownerName: '홍길동',
          openDate: '2020년 01월 01일',
          address: '서울특별시 강남구 역삼동 123-45',
          businessType: '의료, 동물병원'
        });
      }, 1500);
    });
  };

  const handleFileChange = async (event: React.ChangeEvent<HTMLInputElement>) => {
    const selectedFile = event.target.files?.[0];
    if (!selectedFile) return;

    if (!['image/jpeg', 'image/png', 'application/pdf'].includes(selectedFile.type)) {
      toast.error('JPG, PNG 또는 PDF 파일만 업로드 가능합니다.');
      return;
    }

    setFile(selectedFile);
    setIsProcessing(true);

    // 파일 미리보기 생성
    if (selectedFile.type.startsWith('image/')) {
      const reader = new FileReader();
      reader.onloadend = () => {
        setPreview(reader.result as string);
      };
      reader.readAsDataURL(selectedFile);
    }

    try {
      // 실제 OCR 서비스가 구현되면 아래 주석을 해제하고 simulateOCRProcessing 호출 부분을 제거
      // const result = await processBusinessLicense(selectedFile);
      const result = await simulateOCRProcessing(selectedFile);
      setExtractedData(result);
      onDataExtracted(result);
      setIsProcessing(false);
      toast.success('사업자등록증 정보가 추출되었습니다.');
    } catch (error) {
      toast.error('사업자등록증 처리 중 오류가 발생했습니다.');
      setIsProcessing(false);
    }
  };

  const handleDrop = async (event: React.DragEvent<HTMLDivElement>) => {
    event.preventDefault();
    const droppedFile = event.dataTransfer.files[0];
    if (droppedFile && fileInputRef.current) {
      fileInputRef.current.files = event.dataTransfer.files;
      handleFileChange({ target: { files: event.dataTransfer.files } } as any);
    }
  };

  const handleDragOver = (event: React.DragEvent<HTMLDivElement>) => {
    event.preventDefault();
  };

  const handleEdit = (field: keyof BusinessLicenseData, value: string) => {
    setExtractedData(prev => ({
      ...prev,
      [field]: value
    }));
    onDataExtracted({ ...extractedData, [field]: value });
  };

  return (
    <div className="space-y-4">
      {/* 파일 업로드 영역 */}
      <div
        className="border-2 border-dashed border-gray-300 rounded-lg p-8 text-center cursor-pointer hover:border-primary dark:border-gray-600 dark:hover:border-primary"
        onClick={() => fileInputRef.current?.click()}
        onDrop={handleDrop}
        onDragOver={handleDragOver}
      >
        <input
          type="file"
          ref={fileInputRef}
          onChange={handleFileChange}
          accept=".jpg,.jpeg,.png,.pdf"
          className="hidden"
        />
        <IconUpload className="mx-auto h-12 w-12 text-gray-400" />
        <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
          사업자등록증을 드래그하여 놓거나 클릭하여 업로드하세요
        </p>
        <p className="text-xs text-gray-500 dark:text-gray-500">
          JPG, PNG 또는 PDF 파일 (최대 5MB)
        </p>
      </div>

      {/* 미리보기 영역 */}
      {preview && (
        <div className="mt-4">
          <img src={preview} alt="사업자등록증 미리보기" className="max-w-full h-auto rounded-lg" />
        </div>
      )}

      {/* 처리 중 표시 */}
      {isProcessing && (
        <div className="flex items-center justify-center py-4">
          <div className="w-8 h-8 border-t-2 border-b-2 border-primary rounded-full animate-spin"></div>
          <span className="ml-2 text-gray-600 dark:text-gray-400">처리 중...</span>
        </div>
      )}

      {/* 추출된 데이터 표시 및 수정 */}
      {!isProcessing && extractedData.registrationNumber && (
        <div className="mt-6 bg-gray-50 dark:bg-gray-800 rounded-lg p-4">
          <div className="flex items-center justify-between mb-4">
            <h3 className="text-lg font-medium text-gray-900 dark:text-white">추출된 정보</h3>
            <button
              onClick={() => setIsEditing(!isEditing)}
              className="text-primary hover:text-primary-dark"
            >
              <IconEdit className="w-5 h-5" />
            </button>
          </div>
          <div className="space-y-3">
            {Object.entries(extractedData).map(([key, value]) => (
              <div key={key} className="flex items-center">
                <span className="w-32 text-sm text-gray-500 dark:text-gray-400">
                  {key === 'registrationNumber' ? '사업자등록번호' :
                   key === 'companyName' ? '상호' :
                   key === 'ownerName' ? '대표자' :
                   key === 'openDate' ? '개업일자' :
                   key === 'address' ? '주소' :
                   '업태'}:
                </span>
                {isEditing ? (
                  <input
                    type="text"
                    value={value}
                    onChange={(e) => handleEdit(key as keyof BusinessLicenseData, e.target.value)}
                    className="flex-1 ml-2 p-1 text-sm border rounded dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                  />
                ) : (
                  <span className="flex-1 ml-2 text-sm text-gray-900 dark:text-gray-300">{value}</span>
                )}
              </div>
            ))}
          </div>
        </div>
      )}
    </div>
  );
};

export default BusinessLicenseUpload; 
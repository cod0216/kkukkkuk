import React, { useState } from 'react';
import { FiCheck, FiLoader } from 'react-icons/fi';
import { toast } from 'react-toastify';

// 아이콘 props 인터페이스 정의
interface IconProps extends React.SVGProps<SVGSVGElement> {
  size?: number;
  color?: string;
  className?: string;
}

// 아이콘 컴포넌트를 위한 타입 단언
const IconCheck = FiCheck as unknown as React.ComponentType<IconProps>;
const IconLoader = FiLoader as unknown as React.ComponentType<IconProps>;

interface MedicalPractitionerData {
  isVerified: boolean;
  doctorName: string;
  licenseNumber?: string;
}

interface MedicalPractitionerVerificationProps {
  onVerificationSuccess: (data: MedicalPractitionerData) => void;
}

const MedicalPractitionerVerification: React.FC<MedicalPractitionerVerificationProps> = ({ 
  onVerificationSuccess 
}) => {
  const [formData, setFormData] = useState({
    doctorName: '',
    phoneNumber: '',
    telecomProvider: '01',
    ssn1: '',
    ssn2: '',
  });
  const [isVerifying, setIsVerifying] = useState(false);
  const [isVerified, setIsVerified] = useState(false);

  // 폼 필드 변경 핸들러
  const handleChange = (e: React.ChangeEvent<HTMLInputElement | HTMLSelectElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  // 주민등록번호 앞자리 변경 핸들러 (6자리 제한)
  const handleSSN1Change = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.replace(/\D/g, '').slice(0, 6);
    setFormData(prev => ({
      ...prev,
      ssn1: value
    }));
  };

  // 주민등록번호 뒷자리 변경 핸들러 (7자리 제한)
  const handleSSN2Change = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.replace(/\D/g, '').slice(0, 7);
    setFormData(prev => ({
      ...prev,
      ssn2: value
    }));
  };

  // 전화번호 변경 핸들러 (숫자만 입력)
  const handlePhoneChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const value = e.target.value.replace(/\D/g, '');
    setFormData(prev => ({
      ...prev,
      phoneNumber: value
    }));
  };

  // API 인증 요청 핸들러
  const handleVerify = async () => {
    // 입력값 유효성 검사
    if (!formData.doctorName) {
      toast.error('의사 이름을 입력해주세요.');
      return;
    }
    
    if (!formData.phoneNumber || formData.phoneNumber.length < 10) {
      toast.error('올바른 전화번호를 입력해주세요.');
      return;
    }
    
    if (!formData.ssn1 || formData.ssn1.length !== 6 || !formData.ssn2 || formData.ssn2.length !== 7) {
      toast.error('올바른 주민등록번호를 입력해주세요.');
      return;
    }

    setIsVerifying(true);

    try {
      // 실제 API 호출을 위한 데이터 준비
      const apiRequestData = {
        name: formData.doctorName,
        phoneNumber: formData.phoneNumber,
        telecomProvider: formData.telecomProvider,
        ssn: `${formData.ssn1}-${formData.ssn2}`
      };

      // TODO: 실제 API 구현 시 아래 코드를 사용
      // const response = await verifyMedicalPractitioner(apiRequestData);
      
      // 테스트를 위한 임시 검증 로직 (실제 구현 시 대체 필요)
      await new Promise(resolve => setTimeout(resolve, 1500));
      const mockResponse = {
        isVerified: true,
        doctorName: formData.doctorName,
        licenseNumber: 'MV-' + Math.floor(10000 + Math.random() * 90000)
      };

      setIsVerified(mockResponse.isVerified);
      
      if (mockResponse.isVerified) {
        onVerificationSuccess({
          isVerified: true,
          doctorName: mockResponse.doctorName,
          licenseNumber: mockResponse.licenseNumber
        });
        toast.success('의료인 인증이 완료되었습니다.');
      } else {
        toast.error('의료인 인증에 실패했습니다. 정보를 확인해주세요.');
      }
    } catch (error) {
      toast.error('인증 과정에서 오류가 발생했습니다. 다시 시도해주세요.');
      console.error('의료인 인증 오류:', error);
    } finally {
      setIsVerifying(false);
    }
  };

  return (
    <div className="space-y-4">
      <div className="bg-blue-50 p-4 rounded-lg border border-blue-200 mb-4 dark:bg-blue-900/20 dark:border-blue-800">
        <h3 className="text-md font-medium text-blue-800 dark:text-blue-300 mb-2">의료인 인증</h3>
        <p className="text-sm text-blue-700 dark:text-blue-400">
          보건복지부의 의료인면허정보조회 API를 통해 수의사 인증이 필요합니다. 
          아래 정보를 입력해주세요.
        </p>
      </div>

      <div className="space-y-4">
        <div>
          <label htmlFor="doctorName" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
            의사 이름
          </label>
          <input
            id="doctorName"
            name="doctorName"
            type="text"
            value={formData.doctorName}
            onChange={handleChange}
            className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          />
        </div>

        <div>
          <label htmlFor="telecomProvider" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
            통신사
          </label>
          <select
            id="telecomProvider"
            name="telecomProvider"
            value={formData.telecomProvider}
            onChange={handleChange}
            className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          >
            <option value="01">SKT</option>
            <option value="02">KT</option>
            <option value="03">LG U+</option>
            <option value="04">알뜰폰</option>
          </select>
        </div>

        <div>
          <label htmlFor="phoneNumber" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
            전화번호
          </label>
          <input
            id="phoneNumber"
            name="phoneNumber"
            type="text"
            placeholder="'-' 없이 숫자만 입력"
            value={formData.phoneNumber}
            onChange={handlePhoneChange}
            className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            required
          />
        </div>

        <div>
          <label htmlFor="ssn" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
            주민등록번호
          </label>
          <div className="flex items-center space-x-2">
            <input
              id="ssn1"
              name="ssn1"
              type="text"
              value={formData.ssn1}
              onChange={handleSSN1Change}
              className="block w-1/2 px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              placeholder="앞 6자리"
              required
              maxLength={6}
            />
            <span className="mt-1 text-gray-500">-</span>
            <input
              id="ssn2"
              name="ssn2"
              type="password"
              value={formData.ssn2}
              onChange={handleSSN2Change}
              className="block w-1/2 px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              placeholder="뒤 7자리"
              required
              maxLength={7}
            />
          </div>
          <p className="mt-1 text-xs text-gray-500 dark:text-gray-400">
            주민등록번호는 인증 용도로만 사용되며 저장되지 않습니다.
          </p>
        </div>

        <button
          type="button"
          onClick={handleVerify}
          disabled={isVerifying || isVerified}
          className={`w-full px-4 py-2 text-white rounded-md ${
            isVerified 
              ? 'bg-green-500 hover:bg-green-600' 
              : 'bg-primary hover:bg-primary-dark'
          } disabled:opacity-50 disabled:cursor-not-allowed`}
        >
          {isVerifying ? (
            <span className="flex items-center justify-center">
              <IconLoader className="animate-spin -ml-1 mr-2 h-4 w-4" />
              인증 중...
            </span>
          ) : isVerified ? (
            <span className="flex items-center justify-center">
              <IconCheck className="-ml-1 mr-2 h-4 w-4" />
              인증 완료
            </span>
          ) : (
            '의료인 인증'
          )}
        </button>
      </div>

      {isVerified && (
        <div className="mt-4 p-3 bg-green-50 border border-green-200 rounded-md dark:bg-green-900/20 dark:border-green-800">
          <p className="text-sm text-green-700 dark:text-green-400">
            의료인 인증이 완료되었습니다. 다음 단계로 진행해주세요.
          </p>
        </div>
      )}
    </div>
  );
};

export default MedicalPractitionerVerification; 
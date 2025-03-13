import React, { useState } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAppDispatch, useAppSelector } from '../redux/store';
import { registerStart, registerSuccess, registerFailure } from '../redux/slices/authSlice';
import { toast } from 'react-toastify';
import MedicalPractitionerVerification from '../components/auth/MedicalPractitionerVerification';

// 폼 데이터 인터페이스를 업데이트
interface RegisterFormData {
  username: string;
  email: string;
  password: string;
  confirmPassword: string;
  hospitalName: string;
  ownerName: string;
  isVerified: boolean;
  licenseNumber: string;
  address: string;
}

const Register: React.FC = () => {
  // 업데이트된 폼 데이터 상태 초기화
  const [formData, setFormData] = useState<RegisterFormData>({
    username: '',
    email: '',
    password: '',
    confirmPassword: '',
    hospitalName: '',
    ownerName: '',
    isVerified: false,
    licenseNumber: '',
    address: ''
  });
  
  const dispatch = useAppDispatch();
  const navigate = useNavigate();
  const { loading, error } = useAppSelector(state => state.auth);

  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
  };

  // 의료인 인증 데이터 처리
  const handleVerificationSuccess = (data: any) => {
    setFormData(prev => ({
      ...prev,
      ownerName: data.doctorName,
      isVerified: data.isVerified,
      licenseNumber: data.licenseNumber || ''
    }));
    
    // 인증 성공 메시지는 컴포넌트 내부에서 처리됨
  };

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const { username, email, password, confirmPassword, hospitalName, isVerified } = formData;
    
    // 기본 유효성 검사
    if (!username || !email || !password || !confirmPassword || !hospitalName) {
      toast.error('필수 정보를 모두 입력해주세요.');
      return;
    }
    
    if (password !== confirmPassword) {
      toast.error('비밀번호가 일치하지 않습니다.');
      return;
    }
    
    if (!isVerified) {
      toast.error('의료인 인증이 필요합니다.');
      return;
    }
    
    try {
      dispatch(registerStart());
      
      // 실제 API 호출 대신 임시 처리
      // TODO: 실제 API 연동 시 수정 필요
      setTimeout(() => {
        // user 객체를 정의하여 전달
        const user = {
          id: Math.floor(Math.random() * 1000),
          username: formData.username,
          email: formData.email,
          hospitalName: formData.hospitalName,
          did: `did:kkuk:${Date.now().toString(36)}` // 임시 DID 생성
        };
        
        dispatch(registerSuccess(user));  // 사용자 데이터 전달
        toast.success('회원가입 성공! 로그인 페이지로 이동합니다.');
        navigate('/login');
      }, 1000);
      
    } catch (err) {
      dispatch(registerFailure('회원가입 중 오류가 발생했습니다.'));
      toast.error('회원가입 실패. 다시 시도해주세요.');
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-900">
      <div className="w-full max-w-2xl p-8 space-y-8 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <div className="text-center">
          <h1 className="text-4xl font-extrabold text-primary">KKuK KKuK</h1>
          <p className="mt-2 text-gray-600 dark:text-gray-300">동물병원 계정 등록</p>
        </div>
        
        {error && (
          <div className="p-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800">
            {error}
          </div>
        )}
        
        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div className="space-y-6">
              <div>
                <label htmlFor="username" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  사용자 이름
                </label>
                <input
                  id="username"
                  name="username"
                  type="text"
                  required
                  value={formData.username}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                />
              </div>
              
              <div>
                <label htmlFor="email" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  이메일
                </label>
                <input
                  id="email"
                  name="email"
                  type="email"
                  autoComplete="email"
                  required
                  value={formData.email}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                />
              </div>
              
              <div>
                <label htmlFor="password" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  비밀번호
                </label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  required
                  value={formData.password}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                />
              </div>
              
              <div>
                <label htmlFor="confirmPassword" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  비밀번호 확인
                </label>
                <input
                  id="confirmPassword"
                  name="confirmPassword"
                  type="password"
                  required
                  value={formData.confirmPassword}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                />
              </div>
            </div>
            
            <div>
              <MedicalPractitionerVerification onVerificationSuccess={handleVerificationSuccess} />
            </div>
          </div>
          
          <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
            <div>
              <label htmlFor="hospitalName" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                병원 이름
              </label>
              <input
                id="hospitalName"
                name="hospitalName"
                type="text"
                required
                value={formData.hospitalName}
                onChange={handleChange}
                className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              />
            </div>
            
            <div>
              <label htmlFor="address" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                주소
              </label>
              <input
                id="address"
                name="address"
                type="text"
                value={formData.address}
                onChange={handleChange}
                className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
              />
            </div>
          </div>
          
          <div>
            <button
              type="submit"
              disabled={loading || !formData.isVerified}
              className="w-full px-4 py-2 text-white bg-primary rounded-md hover:bg-opacity-90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <span className="flex items-center justify-center">
                  <svg className="w-5 h-5 mr-3 -ml-1 text-white animate-spin" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                    <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                    <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                  </svg>
                  처리 중...
                </span>
              ) : (
                '가입하기'
              )}
            </button>
          </div>
          
          <div className="text-center">
            <span className="text-sm text-gray-600 dark:text-gray-400">
              이미 계정이 있으신가요?{' '}
              <Link to="/login" className="font-medium text-primary hover:text-primary-dark">
                로그인하기
              </Link>
            </span>
          </div>
          
          <div className="text-center mt-2">
            <span className="text-sm text-gray-600 dark:text-gray-400">
              병원 관계자이신가요?{' '}
              <Link to="/hospital-register" className="font-medium text-primary hover:text-primary-dark">
                병원 회원가입
              </Link>
            </span>
          </div>
        </form>
      </div>
    </div>
  );
};

export default Register; 
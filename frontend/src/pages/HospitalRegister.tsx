import React, { useState, useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useAppDispatch, useAppSelector } from '../redux/store';
import { registerStart, registerSuccess, registerFailure } from '../redux/slices/authSlice';
import { toast } from 'react-toastify';
import DoctorRegistration, { Doctor } from '../components/auth/DoctorRegistration';
import { fetchHospitalInfo, registerHospital } from '../services/hospitalService';

interface HospitalFormData {
  hospitalName: string;
  address: string;
  phoneNumber: string;
  licenseNumber: string;
  username: string;
  password: string;
  confirmPassword: string;
  email: string;
}

const HospitalRegister: React.FC = () => {
  const [formData, setFormData] = useState<HospitalFormData>({
    hospitalName: '',
    address: '',
    phoneNumber: '',
    licenseNumber: '',
    username: '',
    password: '',
    confirmPassword: '',
    email: ''
  });
  
  const [doctors, setDoctors] = useState<Doctor[]>([]);
  const [isSearching, setIsSearching] = useState(false);
  const [licenseFound, setLicenseFound] = useState(false);
  
  const dispatch = useAppDispatch();
  const navigate = useNavigate();
  const { loading, error } = useAppSelector(state => state.auth);

  // 입력 필드 변경 핸들러
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({
      ...prev,
      [name]: value
    }));
    
    // 병원 정보가 검색된 후 라이센스 번호가 변경되면 검색 상태 초기화
    if (name === 'licenseNumber' && licenseFound) {
      setLicenseFound(false);
    }
  };

  // 병원 정보 검색 핸들러
  const searchHospitalInfo = async () => {
    const { licenseNumber } = formData;
    
    if (!licenseNumber.trim()) {
      toast.error('인허가 번호를 입력해주세요.');
      return;
    }
    
    try {
      setIsSearching(true);
      const result = await fetchHospitalInfo(licenseNumber);
      
      if (result.success) {
        const { hospitalName, address, phoneNumber } = result.data;
        
        setFormData(prev => ({
          ...prev,
          hospitalName,
          address,
          phoneNumber
        }));
        
        setLicenseFound(true);
        toast.success('병원 정보를 찾았습니다.');
      } else {
        toast.error('병원 정보를 찾을 수 없습니다.');
      }
    } catch (error) {
      toast.error('병원 정보 검색 중 오류가 발생했습니다.');
      console.error('병원 정보 검색 오류:', error);
    } finally {
      setIsSearching(false);
    }
  };

  // 회원가입 제출 핸들러
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    const { hospitalName, licenseNumber, username, password, confirmPassword, email } = formData;
    
    // 기본 유효성 검사
    if (!licenseNumber || !username || !password || !confirmPassword || !email) {
      toast.error('필수 정보를 모두 입력해주세요.');
      return;
    }
    
    if (!licenseFound) {
      toast.error('인허가 번호 검증이 필요합니다.');
      return;
    }
    
    if (password !== confirmPassword) {
      toast.error('비밀번호가 일치하지 않습니다.');
      return;
    }
    
    if (doctors.length === 0) {
      toast.error('최소 1명 이상의 의사를 등록해야 합니다.');
      return;
    }
    
    try {
      dispatch(registerStart());
      
      const doctorsData = doctors.map(doctor => ({
        name: doctor.name,
        licenseNumber: doctor.licenseNumber
      }));
      
      const result = await registerHospital({
        ...formData,
        doctors: doctorsData
      });
      
      if (result.success) {
        dispatch(registerSuccess(result.data));
        toast.success('병원 등록이 완료되었습니다! 로그인 페이지로 이동합니다.');
        navigate('/login');
      } else {
        throw new Error('병원 등록에 실패했습니다.');
      }
    } catch (err) {
      dispatch(registerFailure('회원가입 중 오류가 발생했습니다.'));
      toast.error('회원가입 실패. 다시 시도해주세요.');
    }
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-900">
      <div className="w-full max-w-4xl p-8 space-y-8 bg-white rounded-lg shadow-md dark:bg-gray-800 my-8">
        <div className="flex items-center justify-between">
          <div className="text-center flex-1">
            <h1 className="text-4xl font-extrabold text-primary">KKuK KKuK</h1>
            <p className="mt-2 text-gray-600 dark:text-gray-300">동물병원 회원가입</p>
          </div>
          <button
            onClick={() => navigate('/')}
            className="text-gray-500 hover:text-primary dark:text-gray-400 dark:hover:text-primary flex items-center"
          >
            <span className="mr-1">🏠</span>
            홈으로
          </button>
        </div>
        
        {error && (
          <div className="p-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800">
            {error}
          </div>
        )}
        
        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
          <div className="bg-blue-50 p-4 rounded-lg border border-blue-200 mb-6 dark:bg-blue-900/20 dark:border-blue-800">
            <h3 className="text-md font-medium text-blue-800 dark:text-blue-300 mb-2">병원 기본 정보</h3>
            <p className="text-sm text-blue-700 dark:text-blue-400">
              인허가 번호를 입력한 후 검색 버튼을 클릭하면 병원 정보가 자동으로 조회됩니다.
            </p>
          </div>
          
          <div className="grid grid-cols-1 gap-6 md:grid-cols-4">
            <div className="md:col-span-3">
              <label htmlFor="licenseNumber" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                인허가 번호 *
              </label>
              <div className="mt-1 flex rounded-md shadow-sm">
                <input
                  id="licenseNumber"
                  name="licenseNumber"
                  type="text"
                  required
                  value={formData.licenseNumber}
                  onChange={handleChange}
                  className="block w-full px-3 py-2 border border-gray-300 rounded-l-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
                  placeholder="보건복지부 인허가 번호"
                />
                <button
                  type="button"
                  onClick={searchHospitalInfo}
                  disabled={isSearching || !formData.licenseNumber}
                  className="inline-flex items-center px-4 py-2 border border-transparent text-sm font-medium rounded-r-md text-white bg-primary hover:bg-primary-dark focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50"
                >
                  {isSearching ? (
                    <span className="animate-spin h-5 w-5">⏳</span>
                  ) : licenseFound ? (
                    <span className="text-green-500 h-5 w-5">✓</span>
                  ) : (
                    <span className="h-5 w-5">🔎</span>
                  )}
                </button>
              </div>
            </div>
            
            <div className="md:col-span-1 flex items-end">
              <div className="w-full text-center">
                {licenseFound ? (
                  <span className="inline-flex items-center px-3 py-2 rounded-md text-sm font-medium bg-green-100 text-green-800 dark:bg-green-800 dark:text-green-100">
                    <span className="mr-1">✓</span> 인증완료
                  </span>
                ) : (
                  <span className="inline-flex items-center px-3 py-2 rounded-md text-sm font-medium bg-gray-100 text-gray-800 dark:bg-gray-700 dark:text-gray-300">
                    미인증
                  </span>
                )}
              </div>
            </div>
          </div>
          
          <div className="grid grid-cols-1 gap-6 md:grid-cols-3">
            <div>
              <label htmlFor="hospitalName" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                병원명 *
              </label>
              <input
                id="hospitalName"
                name="hospitalName"
                type="text"
                required
                value={formData.hospitalName}
                onChange={handleChange}
                disabled={!licenseFound}
                className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary disabled:bg-gray-100 disabled:text-gray-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:disabled:bg-gray-800 dark:disabled:text-gray-400"
                placeholder="병원명은 자동으로 입력됩니다"
              />
            </div>
            
            <div>
              <label htmlFor="address" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                주소 *
              </label>
              <input
                id="address"
                name="address"
                type="text"
                required
                value={formData.address}
                onChange={handleChange}
                disabled={!licenseFound}
                className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary disabled:bg-gray-100 disabled:text-gray-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:disabled:bg-gray-800 dark:disabled:text-gray-400"
                placeholder="주소는 자동으로 입력됩니다"
              />
            </div>
            
            <div>
              <label htmlFor="phoneNumber" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                전화번호 *
              </label>
              <input
                id="phoneNumber"
                name="phoneNumber"
                type="tel"
                required
                value={formData.phoneNumber}
                onChange={handleChange}
                disabled={!licenseFound}
                className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary disabled:bg-gray-100 disabled:text-gray-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white dark:disabled:bg-gray-800 dark:disabled:text-gray-400"
                placeholder="전화번호는 자동으로 입력됩니다"
              />
            </div>
          </div>
          
          <div className="pt-4 border-t border-gray-200 dark:border-gray-700">
            <h3 className="text-lg font-medium text-gray-900 dark:text-white mb-4">계정 정보</h3>
            
            <div className="grid grid-cols-1 gap-6 md:grid-cols-2">
              <div>
                <label htmlFor="username" className="block text-sm font-medium text-gray-700 dark:text-gray-300">
                  아이디 *
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
                  이메일 *
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
                  비밀번호 *
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
                  비밀번호 확인 *
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
          </div>
          
          <div className="pt-4 border-t border-gray-200 dark:border-gray-700">
            <DoctorRegistration doctors={doctors} setDoctors={setDoctors} />
          </div>
          
          <div className="pt-6">
            <p className="text-sm text-gray-500 dark:text-gray-400 mb-4">
              * 병원 계정 등록 시 DID(Decentralized Identifier)가 자동으로 생성됩니다. 이는 블록체인 네트워크에서 병원을 식별하는 고유 번호로 사용됩니다.
            </p>
            
            <button
              type="submit"
              disabled={loading || !licenseFound || doctors.length === 0}
              className="w-full px-4 py-2 text-white bg-primary rounded-md hover:bg-opacity-90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50 disabled:cursor-not-allowed"
            >
              {loading ? (
                <span className="flex items-center justify-center">
                  <span className="animate-spin mr-2 h-5 w-5">⏳</span>
                  처리 중...
                </span>
              ) : (
                '병원 등록하기'
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
        </form>
      </div>
    </div>
  );
};

export default HospitalRegister; 
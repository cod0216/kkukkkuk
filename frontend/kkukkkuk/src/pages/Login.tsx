import React, { useState, useEffect } from 'react';
import { useDispatch, useSelector } from 'react-redux';
import { useNavigate, Link } from 'react-router-dom';
import { login, LoginRequest, validateAccount, validatePassword, refreshToken } from '../services/authService';
import { setCredentials } from '../redux/slices/authSlice';
import { RootState } from '../redux/store';

const Login: React.FC = () => {
  const [formData, setFormData] = useState<LoginRequest>({
    account: '',
    password: ''
  });
  const [error, setError] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);
  const [tokenRefreshing, setTokenRefreshing] = useState(false);
  const [validationErrors, setValidationErrors] = useState({
    account: '',
    password: ''
  });
  
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const isLoggedIn = useSelector((state: RootState) => state.auth.isLoggedIn);
  
  // 리프레시 토큰으로 자동 로그인 시도
  useEffect(() => {
    const tryAutoLogin = async () => {
      const refreshTokenValue = localStorage.getItem('refresh_token');
      const savedHospital = localStorage.getItem('hospital');
      
      if (refreshTokenValue && savedHospital && !isLoggedIn) {
        try {
          setTokenRefreshing(true);
          const result = await refreshToken(refreshTokenValue);
          
          if (result.status === 'SUCCESS' && result.data) {
            // 저장된 병원 정보 파싱
            const hospitalData = JSON.parse(savedHospital);
            
            // Redux store 업데이트
            dispatch(setCredentials({
              user: {
                id: String(hospitalData.id),
                account: hospitalData.account,
                hospitalName: hospitalData.name
              },
              token: result.data.access_token
            }));
            
            // 대시보드로 이동
            navigate('/dashboard');
          } else {
            // 토큰 갱신 실패 시 로컬 스토리지 데이터 삭제
            localStorage.removeItem('access_token');
            localStorage.removeItem('refresh_token');
            localStorage.removeItem('hospital');
          }
        } catch (err) {
          console.error('자동 로그인 중 오류 발생:', err);
          // 오류 발생 시 로컬 스토리지 데이터 삭제
          localStorage.removeItem('access_token');
          localStorage.removeItem('refresh_token');
          localStorage.removeItem('hospital');
        } finally {
          setTokenRefreshing(false);
        }
      }
    };
    
    tryAutoLogin();
  }, [dispatch, navigate, isLoggedIn]);
  
  useEffect(() => {
    if (isLoggedIn) {
      navigate('/dashboard');
    }
  }, [isLoggedIn, navigate]);
  
  const validateField = (name: string, value: string) => {
    if (name === 'account') {
      if (!value) return '계정을 입력해주세요.';
      if (!validateAccount(value)) return '계정명은 5~10자의 영문 소문자, 숫자, 밑줄(_)만 허용됩니다.';
    }
    
    if (name === 'password') {
      if (!value) return '비밀번호를 입력해주세요.';
      if (!validatePassword(value)) return '비밀번호는 6~20자의 영문 대소문자, 숫자, 특수문자(!@#$%^&) 조합이어야 합니다.';
    }
    
    return '';
  };
  
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prevState => ({
      ...prevState,
      [name]: value
    }));
    
    // 유효성 검사 오류 업데이트
    const validationError = validateField(name, value);
    setValidationErrors(prev => ({
      ...prev,
      [name]: validationError
    }));
    
    // 에러 메시지 초기화
    if (error) setError(null);
  };
  
  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    // 전체 폼 유효성 검사
    const accountError = validateField('account', formData.account);
    const passwordError = validateField('password', formData.password);
    
    setValidationErrors({
      account: accountError,
      password: passwordError
    });
    
    if (accountError || passwordError) {
      return;
    }
    
    setLoading(true);
    setError(null);
    
    try {
      const result = await login(formData);
      
      if (result.status === 'SUCCESS' && result.data) {
        // 로그인 성공 시 Redux store 업데이트
        dispatch(setCredentials({
          user: {
            id: String(result.data.hospital.id),
            account: result.data.hospital.account,
            hospitalName: result.data.hospital.name
          },
          token: result.data.tokens.access_token
        }));
        
        // 로컬 스토리지에 토큰 저장
        localStorage.setItem('access_token', result.data.tokens.access_token);
        localStorage.setItem('refresh_token', result.data.tokens.refresh_token);
        localStorage.setItem('hospital', JSON.stringify({
          id: result.data.hospital.id,
          did: result.data.hospital.did,
          account: result.data.hospital.account,
          name: result.data.hospital.name
        }));
        
        // 대시보드로 이동
        navigate('/dashboard');
      } else {
        // 로그인 실패 시 에러 메시지 표시
        setError(result.message || '로그인에 실패했습니다.');
      }
    } catch (err) {
      console.error('로그인 중 오류 발생:', err);
      setError('로그인 중 오류가 발생했습니다. 다시 시도해주세요.');
    } finally {
      setLoading(false);
    }
  };
  
  return (
    <div className="min-h-screen flex items-center justify-center bg-gray-50 py-12 px-4 sm:px-6 lg:px-8">
      <div className="max-w-md w-full space-y-8">
        <div>
          <h2 className="mt-6 text-center text-3xl font-extrabold text-gray-900">
            동물병원 관리 시스템
          </h2>
          <p className="mt-2 text-center text-sm text-gray-600">
            계정 정보를 입력하여 로그인하세요
          </p>
        </div>
        
        {tokenRefreshing ? (
          <div className="text-center py-4">
            <p className="text-gray-600">자동 로그인 중...</p>
          </div>
        ) : (
          <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
            <div className="rounded-md shadow-sm space-y-4">
              <div>
                <label htmlFor="account" className="block text-sm font-medium text-gray-700 mb-1">계정</label>
                <input
                  id="account"
                  name="account"
                  type="text"
                  autoComplete="username"
                  required
                  className={`appearance-none relative block w-full px-3 py-2 border ${validationErrors.account ? 'border-red-300' : 'border-gray-300'} placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm`}
                  placeholder="계정 (5~10자, 영문 소문자/숫자/밑줄)"
                  value={formData.account}
                  onChange={handleChange}
                />
                {validationErrors.account && (
                  <p className="mt-1 text-sm text-red-600">{validationErrors.account}</p>
                )}
              </div>
              <div>
                <label htmlFor="password" className="block text-sm font-medium text-gray-700 mb-1">비밀번호</label>
                <input
                  id="password"
                  name="password"
                  type="password"
                  autoComplete="current-password"
                  required
                  className={`appearance-none relative block w-full px-3 py-2 border ${validationErrors.password ? 'border-red-300' : 'border-gray-300'} placeholder-gray-500 text-gray-900 rounded-md focus:outline-none focus:ring-indigo-500 focus:border-indigo-500 focus:z-10 sm:text-sm`}
                  placeholder="비밀번호 (6~20자, 영대소문자/숫자/특수문자 조합)"
                  value={formData.password}
                  onChange={handleChange}
                />
                {validationErrors.password && (
                  <p className="mt-1 text-sm text-red-600">{validationErrors.password}</p>
                )}
              </div>
            </div>
            
            {error && (
              <div className="rounded-md bg-red-50 p-4">
                <div className="flex">
                  <div className="ml-3">
                    <h3 className="text-sm font-medium text-red-800">
                      {error}
                    </h3>
                  </div>
                </div>
              </div>
            )}
            
            <div className="flex items-center justify-between">
              <div className="flex items-center">
                <input
                  id="remember-me"
                  name="remember-me"
                  type="checkbox"
                  className="h-4 w-4 text-indigo-600 focus:ring-indigo-500 border-gray-300 rounded"
                />
                <label htmlFor="remember-me" className="ml-2 block text-sm text-gray-900">
                  로그인 상태 유지
                </label>
              </div>
            </div>
            
            <div>
              <button
                type="submit"
                disabled={loading}
                className={`group relative w-full flex justify-center py-2 px-4 border border-transparent text-sm font-medium rounded-md text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500 ${loading ? 'opacity-70 cursor-not-allowed' : ''}`}
              >
                {loading ? '로그인 중...' : '로그인'}
              </button>
            </div>
            
            <div className="text-center">
              <Link 
                to="/register" 
                className="font-medium text-indigo-600 hover:text-indigo-500"
              >
                병원 계정 등록하기
              </Link>
            </div>
          </form>
        )}
      </div>
    </div>
  );
};

export default Login; 
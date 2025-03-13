import React, { useState } from 'react';
import { Link } from 'react-router-dom';
import { useAppDispatch, useAppSelector } from '../redux/store';
import { loginStart, loginSuccess, loginFailure } from '../redux/slices/authSlice';
import { setDevModeEnabled, selectDevModeEnabled, initializeDevModeData } from '../redux/slices/devModeSlice';
import { toast } from 'react-toastify';
import { store } from '../redux/store';

const Login: React.FC = () => {
  const [email, setEmail] = useState('');
  const [password, setPassword] = useState('');
  const dispatch = useAppDispatch();
  const { loading, error } = useAppSelector(state => state.auth);
  const devModeEnabled = useAppSelector(selectDevModeEnabled);

  const handleSubmit = async (e: React.FormEvent) => {
    e.preventDefault();
    
    if (!email || !password) {
      toast.error('이메일과 비밀번호를 모두 입력해주세요.');
      return;
    }
    
    try {
      dispatch(loginStart());
      
      // 실제 API 호출 대신 임시 로그인 처리
      // TODO: 실제 API 연동 시 수정 필요
      setTimeout(() => {
        // 임시 로그인 성공 처리
        let userData = {
          id: '1',
          username: '동물병원',
          email: email,
          hospitalName: '강원대병원'
        };
        
        // 테스트용 계정 처리
        if (email === 'ssafy@example.com') {
          userData = {
            id: 'hospital-1',
            username: '병원 관리자',
            email: email,
            hospitalName: '싸피 병원'
          };
          
          // 개발 모드 데이터 초기화
          if (devModeEnabled) {
            initializeDevModeData();
          }
        }
        
        dispatch(loginSuccess({
          user: userData,
          token: 'dummy-token'
        }));
        toast.success('로그인 성공!');
      }, 1000);
      
    } catch (err) {
      dispatch(loginFailure('로그인 중 오류가 발생했습니다.'));
      toast.error('로그인 실패. 다시 시도해주세요.');
    }
  };

  // 개발 모드 토글 핸들러
  const handleToggleDevMode = () => {
    const newState = !devModeEnabled;
    console.log(`[Login] Toggling development mode to: ${newState}`);
    dispatch(setDevModeEnabled(newState));
    toast.info(`개발 모드가 ${newState ? '활성화' : '비활성화'}되었습니다.`);
    console.log(`[Login] Development mode state after toggle:`, store.getState().devMode);
  };
  
  // 더미 계정 자동 로그인
  const handleQuickLogin = (email: string) => {
    setEmail(email);
    setPassword('dummy');
    
    setTimeout(() => {
      // 자동 로그인 처리
      dispatch(loginStart());
      
      setTimeout(() => {
        // 임시 로그인 성공 처리
        let userData = {
          id: 'hospital-1',
          username: '병원 관리자',
          email: email,
          hospitalName: '싸피 병원'
        };
        
        dispatch(loginSuccess({
          user: userData,
          token: 'dummy-token'
        }));
        
        // 개발 모드 데이터 초기화
        if (devModeEnabled) {
          initializeDevModeData();
        }
        
        toast.success('개발 모드로 로그인 성공!');
      }, 500);
    }, 100);
  };

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-100 dark:bg-gray-900">
      <div className="w-full max-w-md p-8 space-y-8 bg-white rounded-lg shadow-md dark:bg-gray-800">
        <div className="text-center">
          <h1 className="text-4xl font-extrabold text-primary">KKuK KKuK</h1>
          <p className="mt-2 text-gray-600 dark:text-gray-300">동물병원 진료 기록 시스템</p>
        </div>
        
        {error && (
          <div className="p-4 text-sm text-red-700 bg-red-100 rounded-lg dark:bg-red-200 dark:text-red-800">
            {error}
          </div>
        )}
        
        <form className="mt-8 space-y-6" onSubmit={handleSubmit}>
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
              value={email}
              onChange={(e) => setEmail(e.target.value)}
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
              autoComplete="current-password"
              required
              value={password}
              onChange={(e) => setPassword(e.target.value)}
              className="block w-full px-3 py-2 mt-1 border border-gray-300 rounded-md shadow-sm focus:outline-none focus:ring-primary focus:border-primary dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            />
          </div>
          
          <div>
            <button
              type="submit"
              disabled={loading}
              className="flex justify-center w-full px-4 py-2 text-sm font-medium text-white bg-primary border border-transparent rounded-md shadow-sm hover:bg-opacity-90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary disabled:opacity-50"
            >
              {loading ? '로그인 중...' : '로그인'}
            </button>
          </div>
        </form>
        
        <div className="text-center mt-4">
          <p className="text-sm text-gray-600 dark:text-gray-400">
            계정이 없으신가요?{' '}
            <Link to="/register" className="font-medium text-primary hover:text-opacity-80">
              병원 회원가입
            </Link>
          </p>
        </div>
        
        {/* 개발 모드 토글 */}
        <div className="mt-6 border-t pt-4 dark:border-gray-700">
          <div className="flex items-center justify-between">
            <span className="text-sm font-medium text-gray-700 dark:text-gray-300">개발 모드</span>
            <button
              type="button"
              onClick={handleToggleDevMode}
              className={`relative inline-flex items-center h-6 rounded-full w-11 ${
                devModeEnabled ? 'bg-primary' : 'bg-gray-300 dark:bg-gray-600'
              }`}
            >
              <span className="sr-only">개발 모드 토글</span>
              <span
                className={`inline-block h-4 w-4 transform rounded-full bg-white transition ${
                  devModeEnabled ? 'translate-x-6' : 'translate-x-1'
                }`}
              />
            </button>
          </div>
          <p className="mt-1 text-xs text-gray-500 dark:text-gray-400">
            개발 모드를 활성화하면 블록체인 데이터가 가상으로 생성됩니다. {devModeEnabled ? '(활성화됨)' : '(비활성화됨)'}
          </p>
          
          {devModeEnabled && (
            <div className="mt-2">
              <button
                type="button"
                onClick={() => handleQuickLogin('ssafy@example.com')}
                className="w-full mt-2 py-2 px-4 bg-indigo-500 text-white text-sm font-medium rounded-md hover:bg-indigo-600 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
              >
                📊 개발 모드 데이터로 빠른 로그인
              </button>
              <p className="mt-1 text-xs text-gray-500 dark:text-gray-400">
                ssafy@example.com 계정으로 자동 로그인하고 개발 데이터를 로드합니다.
              </p>
            </div>
          )}
        </div>
        
        {/* 더미 계정 정보 */}
        <div className="mt-6 p-4 bg-gray-50 dark:bg-gray-700 rounded-md">
          <h3 className="text-sm font-medium text-gray-700 dark:text-gray-300 mb-2">테스트용 더미 계정</h3>
          <div className="text-xs text-gray-600 dark:text-gray-400 space-y-1">
            <p>• <strong>싸피 병원:</strong> ssafy@example.com (진료 기록 수정 가능)</p>
            <p>• <strong>김철수:</strong> kim@example.com (보호자)</p>
            <p>• <strong>이영희:</strong> lee@example.com (보호자)</p>
            <p>• <strong>박민수:</strong> park@example.com (보호자)</p>
            <p className="mt-2 text-xs text-gray-500 dark:text-gray-500">* 비밀번호는 아무거나 입력해도 로그인됩니다.</p>
          </div>
        </div>
      </div>
    </div>
  );
};

export default Login; 
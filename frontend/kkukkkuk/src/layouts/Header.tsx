import React, { useEffect } from 'react';
import { Link, useNavigate } from 'react-router-dom';
import { useSelector, useDispatch } from 'react-redux';
import { logout } from '../services/authService';
import { logout as logoutAction, setHospitalInfo } from '../redux/slices/authSlice';
import { selectCurrentUser, selectLoggedInHospital } from '../redux/slices/authSlice';
import { RootState } from '../redux/store';
import { fetchHospitalMe } from '../services/hospitalService';
import { toast } from 'react-toastify';

const Header: React.FC = () => {
  const user = useSelector(selectCurrentUser);
  const hospital = useSelector(selectLoggedInHospital);
  const isLoggedIn = useSelector((state: RootState) => state.auth.isLoggedIn);
  const dispatch = useDispatch();
  const navigate = useNavigate();

  // 컴포넌트 마운트 시 병원 정보 가져오기
  useEffect(() => {
    const fetchHospitalData = async () => {
      // 로그인 상태이고 병원 정보가 없는 경우만 API 호출
      if (isLoggedIn && !hospital) {
        try {
          const response = await fetchHospitalMe();
          
          if (response.status === 'SUCCESS' && response.data) {
            // 병원 정보 받아서 Redux에 저장
            const hospitalData = {
              id: response.data.id,
              name: response.data.name,
              did: response.data.did,
              address: response.data.address,
              phone_number: response.data.phone_number,
              account: response.data.account,
              license_number: response.data.license_number,
              doctor_name: response.data.doctor_name,
              authoriazation_number: response.data.authoriazation_number,
              x_axis: response.data.x_axis,
              y_axis: response.data.y_axis,
              public_key: response.data.public_key,
              doctors: [] // 빈 배열로 초기화
            };
            
            dispatch(setHospitalInfo(hospitalData));
          } else if (response.status === 'error' && response.message?.includes('token')) {
            // 토큰 오류인 경우 로그아웃 처리
            dispatch(logoutAction());
            navigate('/login');
          }
        } catch (error) {
          console.error('병원 정보 조회 오류:', error);
        }
      }
    };
    
    fetchHospitalData();
  }, [isLoggedIn, hospital, dispatch, navigate]);

  const handleLogout = async () => {
    try {
      const response = await logout();
      
      // 서버 응답에 관계없이 로컬 로그아웃 처리
      dispatch(logoutAction());
      
      // 로그아웃 결과 메시지 표시
      if (response.status === 'success') {
        console.log('로그아웃 성공:', response.message);
      } else {
        console.warn('로그아웃 문제 발생:', response.message);
      }
      
      // 로그인 페이지로 리다이렉트
      navigate('/login');
    } catch (error) {
      console.error('로그아웃 중 오류 발생:', error);
      
      // 오류가 발생해도 로컬에서는 로그아웃 처리
      dispatch(logoutAction());
      navigate('/login');
    }
  };

  return (
    <header className="bg-white shadow dark:bg-gray-800">
      <div className="container mx-auto px-4 py-3 flex justify-between items-center">
        <div className="flex items-center">
          <Link to={isLoggedIn ? '/dashboard' : '/'} className="text-2xl font-bold text-indigo-600 dark:text-indigo-400">
            KKuK KKuK
          </Link>
          {isLoggedIn && (
            <nav className="ml-8 hidden md:flex">
              <Link to="/dashboard" className="px-3 py-2 text-gray-700 hover:text-indigo-600 dark:text-gray-300 dark:hover:text-indigo-400">
                대시보드
              </Link>
              <Link to="/pets" className="px-3 py-2 text-gray-700 hover:text-indigo-600 dark:text-gray-300 dark:hover:text-indigo-400">
                반려동물 관리
              </Link>
              <Link to="/qr-print" className="px-3 py-2 text-gray-700 hover:text-indigo-600 dark:text-gray-300 dark:hover:text-indigo-400">
                QR 코드
              </Link>
              <Link to="/hospital-settings" className="px-3 py-2 text-gray-700 hover:text-indigo-600 dark:text-gray-300 dark:hover:text-indigo-400">
                병원 설정
              </Link>
            </nav>
          )}
        </div>
        
        <div className="flex items-center">
          {isLoggedIn && (user || hospital) ? (
            <div className="flex items-center">
              <span className="mr-4 text-sm text-gray-700 dark:text-gray-300 hidden md:inline">
                {hospital?.name || user?.hospitalName || '동물병원'}
              </span>
              <button
                onClick={handleLogout}
                className="px-4 py-2 text-sm rounded text-white bg-red-600 hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2"
              >
                로그아웃
              </button>
            </div>
          ) : (
            <div className="flex items-center space-x-4">
              <Link
                to="/login"
                className="px-4 py-2 text-sm rounded text-indigo-600 hover:text-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                로그인
              </Link>
              <Link
                to="/register"
                className="px-4 py-2 text-sm rounded text-white bg-indigo-600 hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
              >
                회원가입
              </Link>
            </div>
          )}
        </div>
      </div>
    </header>
  );
};

export default Header; 
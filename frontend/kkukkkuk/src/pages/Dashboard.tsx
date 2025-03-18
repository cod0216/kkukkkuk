import React, { useState, useEffect, useRef } from 'react';
import { useSelector, useDispatch } from 'react-redux';
import { useNavigate } from 'react-router-dom';
import { RootState } from '../redux/store';
import { selectCurrentUser, logout as logoutAction } from '../redux/slices/authSlice';
import { logout } from '../services/authService';
import TreatmentForm from '../components/treatment/TreatmentForm';
import TreatmentHistory from '../components/treatment/TreatmentHistory';
import QRCodeGenerator from '../components/did/QRCodeGenerator';

// 레이아웃 타입 정의
type LayoutMode = 'tab' | 'column';
type ActiveTab = 'treatment' | 'history';

const Dashboard: React.FC = () => {
  const user = useSelector(selectCurrentUser);
  const dispatch = useDispatch();
  const navigate = useNavigate();
  
  const [isLoggingOut, setIsLoggingOut] = useState(false);
  const [activePetId, setActivePetId] = useState<string | null>('1'); // 임시로 설정
  const [showQRCode, setShowQRCode] = useState(false);
  const [layoutMode, setLayoutMode] = useState<LayoutMode>('column');
  const [activeTab, setActiveTab] = useState<ActiveTab>('treatment');
  const [splitPosition, setSplitPosition] = useState(50); // 분할 위치 (%)
  const containerRef = useRef<HTMLDivElement>(null);
  
  // 레이아웃 설정 저장 및 복원
  useEffect(() => {
    // 로컬 스토리지에서 설정 로드
    const savedLayoutMode = localStorage.getItem('dashboardLayoutMode') as LayoutMode;
    const savedSplitPosition = localStorage.getItem('dashboardSplitPosition');
    const savedActiveTab = localStorage.getItem('dashboardActiveTab') as ActiveTab;
    
    if (savedLayoutMode) setLayoutMode(savedLayoutMode);
    if (savedSplitPosition) setSplitPosition(parseInt(savedSplitPosition));
    if (savedActiveTab) setActiveTab(savedActiveTab);
  }, []);
  
  // 레이아웃 설정 변경 시 저장
  useEffect(() => {
    localStorage.setItem('dashboardLayoutMode', layoutMode);
    localStorage.setItem('dashboardSplitPosition', splitPosition.toString());
    localStorage.setItem('dashboardActiveTab', activeTab);
  }, [layoutMode, splitPosition, activeTab]);
  
  // 레이아웃 모드 변경
  const toggleLayoutMode = () => {
    if (layoutMode === 'tab') {
      setLayoutMode('column');
    } else if (layoutMode === 'column') {
      setLayoutMode('tab');
    }
  };
  
  // 탭 변경 처리 함수
  const handleTabChange = (tab: ActiveTab) => {
    setActiveTab(tab);
  };
  
  // 로그아웃 처리
  const handleLogout = async () => {
    try {
      setIsLoggingOut(true);
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
    } finally {
      setIsLoggingOut(false);
    }
  };
  
  // 레이아웃 모드에 따른 콘텐츠 렌더링
  const renderContent = () => {
    // 탭 모드 콘텐츠
    if (layoutMode === 'tab') {
      return (
        <div className="bg-white rounded-lg shadow dark:bg-gray-800">
          {/* 탭 헤더 */}
          <div className="border-b dark:border-gray-700 px-6 pt-4">
            <div className="flex border-b dark:border-gray-700">
              <button
                onClick={() => handleTabChange('treatment')}
                className={`px-4 py-2 font-medium rounded-t-md -mb-px
                  ${activeTab === 'treatment'
                    ? 'border-b-2 border-indigo-500 text-indigo-600 dark:text-indigo-400'
                    : 'border-b border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300'
                  }`}
              >
                진료 입력
              </button>
              <button
                onClick={() => handleTabChange('history')}
                className={`px-4 py-2 font-medium rounded-t-md -mb-px
                  ${activeTab === 'history'
                    ? 'border-b-2 border-indigo-500 text-indigo-600 dark:text-indigo-400'
                    : 'border-b border-transparent text-gray-500 hover:text-gray-700 dark:text-gray-400 dark:hover:text-gray-300'
                  }`}
              >
                진료 내역
              </button>
              <div className="flex-grow"></div>
              <button
                onClick={toggleLayoutMode}
                className="px-3 py-2 mr-2 text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-300"
                title="컬럼 모드로 전환"
              >
                <span className="text-sm">분할 보기</span>
              </button>
            </div>
          </div>
          
          {/* 탭 콘텐츠 */}
          <div className="p-6">
            {activeTab === 'treatment' && activePetId && (
              <TreatmentForm petId={activePetId} />
            )}
            {activeTab === 'history' && (
              <TreatmentHistory />
            )}
          </div>
        </div>
      );
    }
    
    // 컬럼 모드 콘텐츠
    return (
      <div className="bg-white rounded-lg shadow dark:bg-gray-800">
        {/* 컬럼 헤더 */}
        <div className="border-b dark:border-gray-700 px-6 pt-4">
          <div className="flex border-b dark:border-gray-700">
            <div className="flex-grow"></div>
            <button
              onClick={toggleLayoutMode}
              className="px-3 py-2 mr-2 text-gray-600 hover:text-gray-800 dark:text-gray-400 dark:hover:text-gray-300"
              title="탭 모드로 전환"
            >
              <span className="text-sm">단일 화면</span>
            </button>
          </div>
        </div>
        
        {/* 컬럼 콘텐츠 */}
        <div ref={containerRef} className="p-6">
          <div className="flex flex-col md:flex-row gap-6">
            {/* 첫 번째 컬럼 */}
            <div className="md:w-1/2">
              <TreatmentForm petId={activePetId || '1'} />
            </div>
            
            {/* 두 번째 컬럼 */}
            <div className="md:w-1/2">
              <TreatmentHistory />
            </div>
          </div>
        </div>
      </div>
    );
  };
  
  return (
    <div className="container mx-auto px-4 py-6">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800 dark:text-gray-200">병원 대시보드</h1>
        <div className="flex items-center space-x-4">
          <button
            onClick={() => setShowQRCode(true)}
            className="px-4 py-2 bg-indigo-600 text-white rounded hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-indigo-500 focus:ring-offset-2"
          >
            QR 코드 생성
          </button>
          <button
            onClick={handleLogout}
            disabled={isLoggingOut}
            className="px-4 py-2 bg-red-600 text-white rounded hover:bg-red-700 focus:outline-none focus:ring-2 focus:ring-red-500 focus:ring-offset-2 disabled:opacity-50"
          >
            {isLoggingOut ? '로그아웃 중...' : '로그아웃'}
          </button>
        </div>
      </div>
      
      {user && (
        <div className="bg-white rounded-lg shadow p-6 mb-6 dark:bg-gray-800">
          <h2 className="text-xl font-semibold mb-4 text-gray-800 dark:text-gray-200">병원 정보</h2>
          <div className="grid grid-cols-1 md:grid-cols-2 gap-4">
            <div>
              <p className="text-gray-600 dark:text-gray-400">병원명</p>
              <p className="font-medium text-gray-900 dark:text-gray-100">{user.hospitalName}</p>
            </div>
            <div>
              <p className="text-gray-600 dark:text-gray-400">계정 ID</p>
              <p className="font-medium text-gray-900 dark:text-gray-100">{user.account}</p>
            </div>
          </div>
        </div>
      )}
      
      <div className="grid grid-cols-1 md:grid-cols-3 gap-6 mb-6">
        <div className="bg-white rounded-lg shadow p-6 dark:bg-gray-800">
          <h2 className="text-xl font-semibold mb-4 text-gray-800 dark:text-gray-200">오늘의 진료</h2>
          <div className="flex justify-between items-center">
            <span className="text-3xl font-bold text-gray-900 dark:text-gray-100">0</span>
            <span className="text-sm text-gray-500 dark:text-gray-400">건</span>
          </div>
        </div>
        
        <div className="bg-white rounded-lg shadow p-6 dark:bg-gray-800">
          <h2 className="text-xl font-semibold mb-4 text-gray-800 dark:text-gray-200">대기 환자</h2>
          <div className="flex justify-between items-center">
            <span className="text-3xl font-bold text-gray-900 dark:text-gray-100">0</span>
            <span className="text-sm text-gray-500 dark:text-gray-400">명</span>
          </div>
        </div>
        
        <div className="bg-white rounded-lg shadow p-6 dark:bg-gray-800">
          <h2 className="text-xl font-semibold mb-4 text-gray-800 dark:text-gray-200">미완료 진료</h2>
          <div className="flex justify-between items-center">
            <span className="text-3xl font-bold text-gray-900 dark:text-gray-100">0</span>
            <span className="text-sm text-gray-500 dark:text-gray-400">건</span>
          </div>
        </div>
      </div>
      
      {/* 진료 입력/기록 섹션 */}
      {renderContent()}
      
      {/* QR 코드 모달 */}
      {showQRCode && (
        <div className="fixed inset-0 bg-black bg-opacity-50 flex items-center justify-center z-50">
          <div className="bg-white rounded-lg shadow-xl max-w-md w-full p-6 dark:bg-gray-800">
            <div className="flex justify-between items-center mb-4">
              <h3 className="text-xl font-semibold text-gray-900 dark:text-gray-100">
                병원 식별 QR 코드
              </h3>
              <button 
                onClick={() => setShowQRCode(false)}
                className="text-gray-400 hover:text-gray-500 dark:text-gray-300 dark:hover:text-gray-200"
              >
                닫기
              </button>
            </div>
            
            <div className="flex flex-col items-center justify-center space-y-4">
              <div className="bg-white p-4 rounded-lg">
                <img 
                  src={`https://api.qrserver.com/v1/create-qr-code/?size=200x200&data=${user?.id || 'hospital'}`} 
                  alt="QR Code" 
                  className="max-w-full h-auto" 
                />
              </div>
              
              <div className="text-center space-y-2">
                <p className="text-sm text-gray-600 dark:text-gray-400">
                  <span className="font-medium">병원명:</span> {user?.hospitalName || '병원명'}
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-400">
                  <span className="font-medium">DID:</span> {`did:hospital:${user?.id}` || 'did:hospital:unknown'}
                </p>
                <p className="text-sm text-gray-600 dark:text-gray-400">
                  <span className="font-medium">생성일:</span> {new Date().toLocaleDateString()}
                </p>
              </div>
              
              <div className="flex space-x-4">
                <button
                  onClick={() => {
                    window.print();
                  }}
                  className="px-4 py-2 bg-indigo-600 text-white rounded-md hover:bg-indigo-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-indigo-500"
                >
                  인쇄하기
                </button>
                <button
                  onClick={() => {
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
    </div>
  );
};

export default Dashboard; 
import React, { useState, useEffect } from 'react';
import { BrowserRouter as Router, Routes, Route, Navigate, useLocation } from 'react-router-dom';
import Dashboard from './pages/Dashboard';
import Login from './pages/Login';
import HospitalRegister from './pages/HospitalRegister';
import Header from './components/layout/Header';
import Footer from './components/layout/Footer';
import GuardianList from './components/guardian/GuardianList';
import { useAppSelector } from './redux/hooks';
import { selectIsAuthenticated } from './redux/slices/authSlice';
import QRCodePrintPage from './pages/QRCodePrintPage';
import HospitalSettings from './pages/HospitalSettings';
import { ToastContainer } from 'react-toastify';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faChevronLeft, faChevronRight } from '@fortawesome/free-solid-svg-icons';
import 'react-toastify/dist/ReactToastify.css';
import './App.css';

// 사이드바 토글 버튼 컴포넌트 Props 타입 정의
interface SidebarToggleProps {
  isOpen: boolean;
  onToggle: () => void;
}

// 사이드바 토글 버튼 컴포넌트
const SidebarToggle: React.FC<SidebarToggleProps> = ({ isOpen, onToggle }) => {
  return (
    <div 
      className="sidebar-toggle" 
      onClick={onToggle} 
      title={isOpen ? "사이드바 접기" : "사이드바 펼치기"}
      aria-label={isOpen ? "사이드바 접기" : "사이드바 펼치기"}
      role="button"
      tabIndex={0}
      onKeyDown={(e) => {
        if (e.key === 'Enter' || e.key === ' ') {
          onToggle();
        }
      }}
    >
      <FontAwesomeIcon 
        icon={isOpen ? faChevronLeft : faChevronRight} 
        size="xs" 
        className="text-gray-600 dark:text-gray-300" 
      />
    </div>
  );
};

// App 컴포넌트 래퍼 - Router 내부에서 useLocation을 사용하기 위한 컴포넌트
function AppContent() {
  const isAuthenticated = useAppSelector(selectIsAuthenticated);
  const [sidebarOpen, setSidebarOpen] = useState(false);
  const location = useLocation();
  
  // 현재 페이지가 병원 설정 페이지인지 확인
  const isSettingsPage = location.pathname.includes('hospital-settings');
  
  // 사이드바 토글 함수
  const toggleSidebar = () => {
    setSidebarOpen(!sidebarOpen);
    document.body.classList.toggle('sidebar-open');
  };
  
  // 사이드바 닫기 함수
  const closeSidebar = () => {
    setSidebarOpen(false);
    document.body.classList.remove('sidebar-open');
  };
  
  // 로그인 상태가 변경될 때 사이드바 상태 초기화
  useEffect(() => {
    if (!isAuthenticated) {
      closeSidebar();
    }
  }, [isAuthenticated]);
  
  // 창 크기가 변경될 때 모바일에서 사이드바 자동 닫기
  useEffect(() => {
    const handleResize = () => {
      if (window.innerWidth < 768 && sidebarOpen) {
        closeSidebar();
      }
    };
    
    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, [sidebarOpen]);

  return (
    <div className="flex flex-col min-h-screen">
      {isAuthenticated && <Header toggleSidebar={toggleSidebar} />}
      
      {/* 사이드바 토글 버튼 - 병원 설정 페이지에서는 표시하지 않음 */}
      {isAuthenticated && !isSettingsPage && (
        <SidebarToggle isOpen={sidebarOpen} onToggle={toggleSidebar} />
      )}
      
      {/* 사이드바로 변경된 보호자 리스트 */}
      {isAuthenticated && (
        <div className={`sidebar-container ${sidebarOpen ? 'open' : ''}`}>
          <GuardianList />
        </div>
      )}
      
      {/* 메인 콘텐츠 */}
      <div className={`main-content flex-grow ${isAuthenticated ? 'pt-16' : ''} ${sidebarOpen ? 'sidebar-adjusted' : ''}`}>
        <Routes>
          <Route path="/login" element={isAuthenticated ? <Navigate to="/" /> : <Login />} />
          <Route path="/register" element={isAuthenticated ? <Navigate to="/" /> : <HospitalRegister />} />
          <Route path="/hospital-register" element={isAuthenticated ? <Navigate to="/" /> : <HospitalRegister />} />
          <Route path="/" element={isAuthenticated ? <Dashboard /> : <Navigate to="/login" />} />
          <Route path="/qr-print" element={<QRCodePrintPage />} />
          <Route path="/hospital-settings" element={isAuthenticated ? <HospitalSettings /> : <Navigate to="/login" />} />
        </Routes>
      </div>
      
      {isAuthenticated && <Footer />}
    </div>
  );
}

function App() {
  return (
    <Router>
      <AppContent />
      <ToastContainer position="top-right" autoClose={3000} />
    </Router>
  );
}

export default App;

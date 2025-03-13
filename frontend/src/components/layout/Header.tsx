import React, { useState, useEffect } from 'react';
import { useAppSelector, useAppDispatch } from '../../redux/hooks';
import { logout, setCurrentDoctor } from '../../redux/slices/authSlice';
import { useNavigate } from 'react-router-dom';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { 
  faBars, 
  faQrcode, 
  faCog, 
  faSignOutAlt,
  faUserMd,
  faSun,
  faMoon,
  faChevronDown
} from '@fortawesome/free-solid-svg-icons';

// 반려동물 슬라이스에서 필요한 selector 추가
import { selectSelectedPet } from '../../redux/slices/petSlice';
// 보호자 슬라이스에서 필요한 selector 추가
import { selectSelectedGuardian } from '../../redux/slices/guardianSlice';
// 의사 선택 관련 리덕스 상태 (추후 구현)
import { selectLoggedInHospital, selectCurrentDoctor } from '../../redux/slices/authSlice';
// DID 관련 액션 추가
import { setShowQRCode } from '../../redux/slices/didSlice';
// 개발 모드 관련
import { selectDevModeEnabled, selectMockHospitalData } from '../../redux/slices/devModeSlice';

// props 타입 정의
interface HeaderProps {
  toggleSidebar: () => void;
}

const Header: React.FC<HeaderProps> = ({ toggleSidebar }) => {
  const navigate = useNavigate();
  const dispatch = useAppDispatch();
  
  // 다크모드 상태 관리
  const [darkMode, setDarkMode] = useState(false);
  
  // 의사 선택 드롭다운 상태
  const [doctorDropdownOpen, setDoctorDropdownOpen] = useState(false);
  
  // 페이지 로드 시 다크모드 설정 확인
  useEffect(() => {
    // 로컬 스토리지에서 다크모드 설정 확인
    const isDarkMode = localStorage.getItem('darkMode') === 'true';
    setDarkMode(isDarkMode);
    
    // HTML 태그에 다크 클래스 추가/제거
    if (isDarkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  }, []);
  
  // 다크모드 토글 함수
  const toggleDarkMode = () => {
    const newDarkMode = !darkMode;
    setDarkMode(newDarkMode);
    
    // 로컬 스토리지에 설정 저장
    localStorage.setItem('darkMode', newDarkMode.toString());
    
    // HTML 태그에 다크 클래스 추가/제거
    if (newDarkMode) {
      document.documentElement.classList.add('dark');
    } else {
      document.documentElement.classList.remove('dark');
    }
  };
  
  // 현재 선택된 반려동물과 보호자 정보 가져오기
  const selectedPet = useAppSelector(selectSelectedPet);
  const selectedGuardian = useAppSelector(selectSelectedGuardian);
  
  // 로그인된 병원 정보
  const hospital = useAppSelector(selectLoggedInHospital) || { name: "동물사랑병원", doctors: [] };
  
  // 개발 모드 상태 확인
  const isDevMode = useAppSelector(selectDevModeEnabled);
  
  // 현재 선택된 의사 정보
  const currentDoctor = useAppSelector(selectCurrentDoctor);
  
  // 의사 선택 핸들러
  const handleDoctorSelect = (doctor: any) => {
    dispatch(setCurrentDoctor(doctor));
    setDoctorDropdownOpen(false);
  };
  
  // 드롭다운 외부 클릭 시 닫기
  useEffect(() => {
    const handleClickOutside = (event: MouseEvent) => {
      const dropdown = document.getElementById('doctor-dropdown');
      if (dropdown && !dropdown.contains(event.target as Node) && doctorDropdownOpen) {
        setDoctorDropdownOpen(false);
      }
    };
    
    document.addEventListener('mousedown', handleClickOutside);
    return () => {
      document.removeEventListener('mousedown', handleClickOutside);
    };
  }, [doctorDropdownOpen]);
  
  // QR 코드 출력 처리 - 모달로 처리하도록 변경
  const handleQRCodePrint = () => {
    dispatch(setShowQRCode(true));
  };
  
  // 설정 페이지로 이동
  const handleSettings = () => {
    navigate('/hospital-settings');
  };
  
  // 로그아웃 핸들러
  const handleLogout = () => {
    dispatch(logout());
    navigate('/login');
  };
  
  // 반려동물 나이 계산 함수
  const calculateAge = (birthDate: string) => {
    if (!birthDate) return '';
    
    const birth = new Date(birthDate);
    const today = new Date();
    let age = today.getFullYear() - birth.getFullYear();
    
    // 생일이 아직 지나지 않았는지 확인
    const monthDiff = today.getMonth() - birth.getMonth();
    if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
      age--;
    }
    
    return `${age}세`;
  };

  return (
    <header className="bg-white shadow-md p-4 fixed top-0 left-0 right-0 z-50 dark:bg-gray-800 dark:text-white">
      <div className="container mx-auto flex justify-between items-center">
        <div className="flex items-center">
          {/* 햄버거 버튼 */}
          <button 
            onClick={toggleSidebar}
            className="text-gray-700 mr-4 hover:text-blue-500 transition-colors dark:text-gray-300 dark:hover:text-blue-400"
            aria-label="메뉴 열기"
          >
            <FontAwesomeIcon icon={faBars} size="lg" />
          </button>
          
          {/* 반려동물 정보 표시 - 볼드 처리 수정 */}
          {selectedGuardian && selectedPet ? (
            <div className="flex items-center space-x-2 text-sm font-medium text-gray-700 overflow-x-auto whitespace-nowrap dark:text-gray-300">
              <span>{selectedGuardian.name}의 반려동물</span>
              <span>|</span>
              <span className="font-bold">{selectedPet.name}</span>
              <span>|</span>
              <span>{calculateAge(selectedPet.birthDate)}</span>
              <span>|</span>
              <span>{selectedPet.species}</span>
              <span>|</span>
              <span>{selectedPet.breed}</span>
              <span>|</span>
              <span>{selectedPet.gender}</span>
              <span>|</span>
              <span>{selectedPet.birthDate}</span>
            </div>
          ) : (
            <div 
              className="text-lg font-semibold text-gray-700 dark:text-white cursor-pointer hover:text-blue-500 dark:hover:text-blue-400 transition-colors"
              onClick={() => navigate('/')}
            >
              KKuk KKuk - 동물병원 진료 시스템
            </div>
          )}
        </div>
        
        <div className="flex items-center space-x-4">
          {/* 다크모드 토글 버튼 추가 */}
          <button 
            onClick={toggleDarkMode}
            className="text-gray-700 hover:text-blue-500 transition-colors dark:text-gray-300 dark:hover:text-yellow-300"
            aria-label={darkMode ? "라이트 모드로 전환" : "다크 모드로 전환"}
          >
            <FontAwesomeIcon icon={darkMode ? faSun : faMoon} size="lg" />
          </button>
          
          {/* QR 코드 버튼 */}
          <button 
            onClick={handleQRCodePrint}
            className="text-gray-700 hover:text-blue-500 transition-colors dark:text-gray-300 dark:hover:text-blue-400"
            aria-label="QR 코드 출력"
          >
            <FontAwesomeIcon icon={faQrcode} size="lg" />
          </button>
          
          {/* 병원 이름 */}
          <div className="text-sm font-medium text-gray-700 dark:text-gray-300">
            {hospital.name}
          </div>
          
          {/* 의사 선택 드롭다운 */}
          <div className="relative" id="doctor-dropdown">
            <button 
              onClick={() => setDoctorDropdownOpen(!doctorDropdownOpen)}
              className="flex items-center space-x-1 text-sm font-medium text-gray-700 hover:text-blue-500 dark:text-gray-300 dark:hover:text-blue-400"
            >
              <FontAwesomeIcon icon={faUserMd} className="mr-1" />
              <span>{currentDoctor ? currentDoctor.name : '의사 선택'}</span>
              <FontAwesomeIcon icon={faChevronDown} size="xs" />
            </button>
            
            {doctorDropdownOpen && (
              <div className="absolute right-0 mt-2 w-48 bg-white rounded-md shadow-lg py-1 z-10 dark:bg-gray-700">
                {hospital.doctors && hospital.doctors.length > 0 ? (
                  hospital.doctors.map((doctor: any) => (
                    <button
                      key={doctor.id}
                      onClick={() => handleDoctorSelect(doctor)}
                      className={`block w-full text-left px-4 py-2 text-sm ${
                        currentDoctor && currentDoctor.id === doctor.id
                          ? 'bg-blue-100 text-blue-700 dark:bg-blue-800 dark:text-blue-200'
                          : 'text-gray-700 hover:bg-gray-100 dark:text-gray-200 dark:hover:bg-gray-600'
                      }`}
                    >
                      {doctor.name} {doctor.specialization ? `(${doctor.specialization})` : ''}
                    </button>
                  ))
                ) : (
                  <div className="px-4 py-2 text-sm text-gray-500 dark:text-gray-400">
                    등록된 의사가 없습니다
                  </div>
                )}
              </div>
            )}
          </div>
          
          {/* 설정 버튼 */}
          <button 
            onClick={handleSettings}
            className="text-gray-700 hover:text-blue-500 transition-colors dark:text-gray-300 dark:hover:text-blue-400"
            aria-label="병원 설정"
          >
            <FontAwesomeIcon icon={faCog} size="lg" />
          </button>
          
          {/* 로그아웃 버튼 */}
          <button 
            onClick={handleLogout}
            className="flex items-center space-x-1 bg-red-500 hover:bg-red-600 text-white py-1 px-3 rounded text-sm transition-colors"
          >
            <FontAwesomeIcon icon={faSignOutAlt} size="sm" />
            <span>로그아웃</span>
          </button>
        </div>
      </div>
    </header>
  );
};

export default Header; 
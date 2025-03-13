import React, { useState, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAppSelector, useAppDispatch } from '../redux/hooks';
import { selectLoggedInHospital, updateHospitalInfo } from '../redux/slices/authSlice';
import { selectDevModeEnabled, updateMockHospitalData, addDoctorToMockHospital, removeDoctorFromMockHospital } from '../redux/slices/devModeSlice';
import { FontAwesomeIcon } from '@fortawesome/react-fontawesome';
import { faUserMd, faHospital, faIdCard, faPhone, faMapMarkerAlt, faEnvelope, faHome, faCode } from '@fortawesome/free-solid-svg-icons';

interface Doctor {
  id: string;
  name: string;
  specialization: string;
  licenseNumber?: string;
}

const HospitalSettings: React.FC = () => {
  const dispatch = useAppDispatch();
  const navigate = useNavigate();
  const hospital = useAppSelector(selectLoggedInHospital) || { 
    name: "", 
    did: "", 
    address: "", 
    phone: "", 
    email: "",
    doctors: []
  };
  
  const isDevMode = useAppSelector(selectDevModeEnabled);
  
  const [formData, setFormData] = useState({
    name: hospital.name,
    address: hospital.address,
    phone: hospital.phone,
    email: hospital.email
  });
  
  const [doctors, setDoctors] = useState(hospital.doctors || []);
  const [newDoctor, setNewDoctor] = useState({ name: "", specialization: "", licenseNumber: "" });
  
  // 병원 정보가 로드되면 폼 데이터 업데이트
  useEffect(() => {
    if (hospital) {
      setFormData({
        name: hospital.name || "",
        address: hospital.address || "",
        phone: hospital.phone || "",
        email: hospital.email || ""
      });
      setDoctors(hospital.doctors || []);
    }
  }, [hospital]);
  
  // 폼 데이터 변경 핸들러
  const handleChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setFormData(prev => ({ ...prev, [name]: value }));
  };
  
  // 새 의사 정보 변경 핸들러
  const handleDoctorChange = (e: React.ChangeEvent<HTMLInputElement>) => {
    const { name, value } = e.target;
    setNewDoctor(prev => ({ ...prev, [name]: value }));
  };
  
  // 의사 추가 핸들러
  const handleAddDoctor = () => {
    if (newDoctor.name && newDoctor.specialization) {
      const newDoctorWithId = { ...newDoctor, id: Date.now().toString() };
      
      if (isDevMode) {
        // 개발 모드에서는 Redux에 의사 추가
        dispatch(addDoctorToMockHospital(newDoctorWithId));
      } else {
        // 일반 모드에서는 로컬 상태에 의사 추가
        setDoctors([...doctors, newDoctorWithId]);
      }
      
      setNewDoctor({ name: "", specialization: "", licenseNumber: "" });
    }
  };
  
  // 의사 삭제 핸들러
  const handleRemoveDoctor = (id: string) => {
    if (isDevMode) {
      // 개발 모드에서는 Redux에서 의사 삭제
      dispatch(removeDoctorFromMockHospital(id));
    } else {
      // 일반 모드에서는 로컬 상태에서 의사 삭제
      setDoctors(doctors.filter((doctor: Doctor) => doctor.id !== id));
    }
  };
  
  // 폼 제출 핸들러
  const handleSubmit = (e: React.FormEvent) => {
    e.preventDefault();
    
    if (isDevMode) {
      // 개발 모드에서는 Redux의 mockHospitalData 업데이트
      dispatch(updateMockHospitalData({ ...formData }));
      alert("개발 모드: 병원 정보가 업데이트되었습니다.");
    } else {
      // 일반 모드에서는 authSlice의 병원 정보 업데이트
      dispatch(updateHospitalInfo({ ...formData, doctors }));
      alert("병원 정보가 업데이트되었습니다.");
    }
  };
  
  return (
    <div className="container mx-auto py-8 px-4 max-w-4xl">
      <div className="flex justify-between items-center mb-6">
        <h1 className="text-2xl font-bold text-gray-800">병원 설정</h1>
        <div className="flex gap-2">
          {isDevMode && (
            <div className="flex items-center bg-purple-500 text-white px-3 py-1 rounded-md">
              <FontAwesomeIcon icon={faCode} className="mr-2" />
              개발 모드
            </div>
          )}
          <button
            onClick={() => navigate('/')}
            className="flex items-center px-4 py-2 bg-blue-500 hover:bg-blue-600 text-white rounded-md transition-colors"
          >
            <FontAwesomeIcon icon={faHome} className="mr-2" />
            대시보드로 돌아가기
          </button>
        </div>
      </div>
      
      <div className="bg-white shadow-md rounded-lg p-6 mb-8">
        <h2 className="text-xl font-semibold mb-4 text-gray-700 flex items-center">
          <FontAwesomeIcon icon={faHospital} className="mr-2 text-blue-500" />
          기본 정보
        </h2>
        
        <form onSubmit={handleSubmit}>
          <div className="grid md:grid-cols-2 gap-4 mb-6">
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">병원명</label>
              <div className="relative">
                <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                  <FontAwesomeIcon icon={faHospital} />
                </span>
                <input
                  type="text"
                  name="name"
                  value={formData.name}
                  onChange={handleChange}
                  className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="병원 이름"
                  required
                />
              </div>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">DID 식별자</label>
              <div className="relative">
                <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                  <FontAwesomeIcon icon={faIdCard} />
                </span>
                <input
                  type="text"
                  value={hospital.did || "자동 생성됨"}
                  className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md bg-gray-100 cursor-not-allowed"
                  readOnly
                />
              </div>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">연락처</label>
              <div className="relative">
                <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                  <FontAwesomeIcon icon={faPhone} />
                </span>
                <input
                  type="text"
                  name="phone"
                  value={formData.phone}
                  onChange={handleChange}
                  className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="병원 연락처"
                />
              </div>
            </div>
            
            <div>
              <label className="block text-sm font-medium text-gray-700 mb-1">이메일</label>
              <div className="relative">
                <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                  <FontAwesomeIcon icon={faEnvelope} />
                </span>
                <input
                  type="email"
                  name="email"
                  value={formData.email}
                  onChange={handleChange}
                  className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                  placeholder="hospital@example.com"
                />
              </div>
            </div>
          </div>
          
          <div className="mb-6">
            <label className="block text-sm font-medium text-gray-700 mb-1">주소</label>
            <div className="relative">
              <span className="absolute inset-y-0 left-0 flex items-center pl-3 text-gray-500">
                <FontAwesomeIcon icon={faMapMarkerAlt} />
              </span>
              <input
                type="text"
                name="address"
                value={formData.address}
                onChange={handleChange}
                className="w-full pl-10 pr-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="병원 주소"
              />
            </div>
          </div>
          
          <button
            type="submit"
            className="bg-blue-500 hover:bg-blue-600 text-white py-2 px-4 rounded-md transition-colors"
          >
            정보 저장
          </button>
        </form>
      </div>
      
      <div className="bg-white shadow-md rounded-lg p-6">
        <h2 className="text-xl font-semibold mb-4 text-gray-700 flex items-center">
          <FontAwesomeIcon icon={faUserMd} className="mr-2 text-blue-500" />
          의사 관리
        </h2>
        
        <div className="mb-6">
          <div className="grid md:grid-cols-3 gap-4 mb-3">
            <div>
              <input
                type="text"
                name="name"
                value={newDoctor.name}
                onChange={handleDoctorChange}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="의사 이름"
              />
            </div>
            <div>
              <input
                type="text"
                name="specialization"
                value={newDoctor.specialization}
                onChange={handleDoctorChange}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="전문 분야"
              />
            </div>
            <div>
              <input
                type="text"
                name="licenseNumber"
                value={newDoctor.licenseNumber}
                onChange={handleDoctorChange}
                className="w-full px-3 py-2 border border-gray-300 rounded-md focus:outline-none focus:ring-2 focus:ring-blue-500"
                placeholder="면허 번호 (선택)"
              />
            </div>
          </div>
          
          <button
            type="button"
            onClick={handleAddDoctor}
            className="mt-2 bg-green-500 hover:bg-green-600 text-white py-1 px-3 rounded-md text-sm transition-colors"
          >
            의사 추가
          </button>
        </div>
        
        {doctors.length > 0 ? (
          <div className="overflow-x-auto">
            <table className="min-w-full divide-y divide-gray-200">
              <thead className="bg-gray-50">
                <tr>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">이름</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">전문 분야</th>
                  <th className="px-4 py-3 text-left text-xs font-medium text-gray-500 uppercase tracking-wider">면허 번호</th>
                  <th className="px-4 py-3 text-right text-xs font-medium text-gray-500 uppercase tracking-wider">관리</th>
                </tr>
              </thead>
              <tbody className="bg-white divide-y divide-gray-200">
                {doctors.map((doctor: Doctor) => (
                  <tr key={doctor.id} className="hover:bg-gray-50">
                    <td className="px-4 py-3 text-sm text-gray-900">{doctor.name}</td>
                    <td className="px-4 py-3 text-sm text-gray-900">{doctor.specialization}</td>
                    <td className="px-4 py-3 text-sm text-gray-900">{doctor.licenseNumber || "-"}</td>
                    <td className="px-4 py-3 text-sm text-right">
                      <button
                        onClick={() => handleRemoveDoctor(doctor.id)}
                        className="text-red-500 hover:text-red-700 transition-colors"
                      >
                        삭제
                      </button>
                    </td>
                  </tr>
                ))}
              </tbody>
            </table>
          </div>
        ) : (
          <div className="text-center py-4 text-gray-500">
            등록된 의사가 없습니다. 의사 정보를 추가해주세요.
          </div>
        )}
      </div>
    </div>
  );
};

export default HospitalSettings; 
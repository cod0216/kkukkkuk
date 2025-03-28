import React, { useState, useEffect, useRef } from 'react';
import { FaSearch, FaQrcode } from 'react-icons/fa';
import PetListItem from '@/pages/treatment/layout/PetListItem';
import { Treatment, TreatmentState, Gender } from '@/interfaces';
import { getHospitalPetsWithRecords } from '@/services/treatmentService';
import { DID_REGISTRY_ADDRESS } from '@/utils/constants';
import QRGenerator from '@/pages/treatment/QRGenerator';
import { getAccountAddress } from '@/services/blockchainAuthService';
/**
 * @module TreatmentSidebar
 * @file TreatmentSidebar.tsx
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 진단 페이지 내부의 좌측 사이드바 역할을 수행합니다. 
 *              병원에 진료했던 반려동물를 출력하는 UI 컴포넌트입니다.   
 *              
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         블록체인 서비스 연동
 */

/**
 * TreatmentSidebar 컴포넌트의 Props 타입 정의
 */
interface SidebarProps {
    treatments: Treatment[];
    selectedPetIndex : number;
    setSelectedPetIndex: (index : number) => void;
    getStateBadgeColor: (state: TreatmentState) => string;
    getStateColor: (state: TreatmentState) => string;
    onBlockchainPetsLoad?: (pets: Treatment[]) => void; // 블록체인 반려동물 목록을 상위 컴포넌트로 전달하는 콜백
}

/**
 * 병원 정보 인터페이스
 */
interface HospitalInfo {
  name: string;
  address: string;
  did: string;
}

/**
 * 진단 페이지 내부의 좌측 사이드바 역할을 수행합니다. 
 * 병원에 진료했던 반려동물를 출력하는 UI 컴포넌트입니다.  
 */
const TreatmentSidebar: React.FC<SidebarProps> = ({
    treatments,
    selectedPetIndex,
    setSelectedPetIndex,
    getStateBadgeColor,
    getStateColor,
    onBlockchainPetsLoad,
}) => {
    const [searchTerm, setSearchTerm] = useState('');
    const [filters, setFilters] = useState({
      dateRange: { start: '', end: '' },
      state: TreatmentState.NONE,
    });
    
    const [blockchainPets, setBlockchainPets] = useState<Treatment[]>([]);
    const [isLoading, setIsLoading] = useState(false);
    const [error, setError] = useState<string | null>(null);
    const hasLoadedData = useRef(false);
    
    // QR 코드 생성 모달 상태
    const [qrModalVisible, setQrModalVisible] = useState(false);
    
    // 병원 정보 상태
    const [hospitalInfo, setHospitalInfo] = useState<HospitalInfo>({
      name: '샘플 동물병원',
      address: '',
      did: ''
    });

    // 병원 정보 가져오기
    useEffect(() => {
      const fetchHospitalInfo = async () => {
        try {
          // 현재 연결된 계정 주소를 DID로 사용
          const accountAddress = await getAccountAddress();
          
          if (accountAddress) {
            setHospitalInfo(prev => ({
              ...prev,
              address: accountAddress,
              did: accountAddress // 이더리움 주소를 DID로 사용
            }));
          }
        } catch (error) {
          console.error('병원 정보 가져오기 오류:', error);
        }
      };
      
      fetchHospitalInfo();
    }, []);

    // 블록체인 데이터 불러오기 함수
    const fetchPetsData = async () => {
      try {
        setIsLoading(true);
        setError(null);
        
        const result = await getHospitalPetsWithRecords(DID_REGISTRY_ADDRESS);
        
        if (result.success) {
          // 디버깅: 블록체인에서 받아온 원본 데이터 확인
          console.log('블록체인에서 받아온 반려동물 원본 데이터:', result.pets);
          
          // 블록체인 데이터를 Treatment 형식으로 변환
          const convertedTreatments = result.pets.map((pet, index) => {
            // 디버깅: 각 반려동물의 출생일과 중성화 정보 확인
            console.log(`반려동물 ${index} (${pet.name}) 정보:`, {
              petDID: pet.petDID,
              birth: pet.birth,
              birthType: typeof pet.birth,
              parsedDate: pet.birth ? new Date(pet.birth) : 'Invalid Date',
              calculatedAge: pet.birth ? calculateAge(pet.birth) : 0,
              gender: pet.gender,
              neutering: (pet as any).neutering || (pet as any).flagNeutering || false,
              rawPet: pet
            });
            
            // 성별 처리 - 한글 "암컷"/"수컷" 또는 영문 "female"/"male" 모두 지원
            let genderValue = Gender.FEMALE; // 기본값
            if (pet.gender) {
              const genderLower = pet.gender.toLowerCase();
              if (genderLower === 'male' || genderLower === '수컷') {
                genderValue = Gender.MALE;
              } else if (genderLower === 'female' || genderLower === '암컷') {
                genderValue = Gender.FEMALE;
              }
            }
            
            // 중성화 정보 처리
            const isNeutered = Boolean((pet as any).neutering || (pet as any).flagNeutering || false);
            
            return {
              id: index,
              petId: index, // Treatment 인터페이스에 필요한 필드
              petDid: pet.petDID,
              state: TreatmentState.WAITING, // 초기 상태는 대기중으로 설정
              name: pet.name || '이름 없음',
              age: pet.birth ? calculateAge(pet.birth) : 0,
              gender: genderValue,
              breedName: pet.breed || '품종 정보 없음',
              birth: pet.birth || '',
              // 중성화 정보를 다양한 필드명으로 시도
              flagNeutering: isNeutered,
              createdAt: new Date().toISOString(),
              expireDate: '',
            };
          });
          
          // 디버깅: 변환 완료된 반려동물 데이터 확인
          console.log('변환된 Treatment 형식 반려동물 데이터:', convertedTreatments);
          
          setBlockchainPets(convertedTreatments);
          hasLoadedData.current = true;
          
          // 상위 컴포넌트로 블록체인 반려동물 목록 전달
          if (onBlockchainPetsLoad) {
            onBlockchainPetsLoad(convertedTreatments);
          }
        } else {
          setError(result.error || '반려동물 목록을 가져오는데 실패했습니다.');
        }
      } catch (err: any) {
        console.error('반려동물 목록 가져오기 오류:', err);
        setError(err.message || '반려동물 목록을 가져오는 중 오류가 발생했습니다.');
      } finally {
        setIsLoading(false);
      }
    };

    // 블록체인에서 병원에 공유된 반려동물 목록 가져오기 (최초 1회만)
    useEffect(() => {
      // 이미 데이터를 불러왔으면 다시 불러오지 않음
      if (hasLoadedData.current) {
        return;
      }
      
      fetchPetsData();
    }, []); // 의존성 배열 비움 - 최초 1회만 실행
    
    // 반려동물 나이 계산 함수
    const calculateAge = (birthDate: string): number => {
      try {
        // 디버깅: 날짜 변환 과정 확인
        console.log('나이 계산 시도 - 입력 날짜:', birthDate);
        
        const today = new Date();
        const birth = new Date(birthDate);
        
        // 디버깅: 날짜 파싱 결과 확인
        console.log('파싱된 출생일:', birth, 'isValid:', !isNaN(birth.getTime()));
        
        // 유효하지 않은 날짜 처리
        if (isNaN(birth.getTime())) {
          console.warn('유효하지 않은 출생일 형식:', birthDate);
          return 0;
        }
        
        // 미래 날짜 검사
        if (birth > today) {
          console.warn('출생일이 미래 날짜입니다. 0살로 처리합니다:', birthDate);
          return 0;
        }
        
        let age = today.getFullYear() - birth.getFullYear();
        const monthDiff = today.getMonth() - birth.getMonth();
        
        if (monthDiff < 0 || (monthDiff === 0 && today.getDate() < birth.getDate())) {
          age--;
        }
        
        console.log('계산된 나이:', age);
        return age;
      } catch (error) {
        console.error('나이 계산 중 오류 발생:', error);
        return 0;
      }
    };
    
    // QR 코드 모달 열기
    const openQrModal = () => {
      setQrModalVisible(true);
    };
    
    // QR 코드 모달 닫기
    const closeQrModal = () => {
      setQrModalVisible(false);
    };
    
    // 검색어로 필터링된 반려동물 목록
    const filteredPets = [...blockchainPets, ...treatments].filter(pet => 
      pet.name.toLowerCase().includes(searchTerm.toLowerCase()) ||
      pet.breedName.toLowerCase().includes(searchTerm.toLowerCase())
    );
    
  return (
    <>
      <div className="w-80 bg-white rounded-lg border p-4 mr-6">
          <div className="mb-6">
              {/* 검색 및 새로고침 */}
              <div className="flex items-center gap-2 mb-3">
                <FaSearch className="text-gray-400" />
                <input
                  className="text-xs p-1 bg-gray-50 border rounded-md flex-1 focus:outline-none focus:ring-2 focus:ring-primary-500 focus:border-transparent"
                  type="search"
                  placeholder="환자 검색"
                  value={searchTerm}
                  onChange={(e) => setSearchTerm(e.target.value)}
                />
                <button
                  onClick={fetchPetsData}
                  disabled={isLoading}
                  className="bg-primary-50 hover:bg-primary-100 text-primary-700 text-xs px-2 py-1 rounded"
                  title="목록 새로고침"
                >
                  {isLoading ? '로딩중' : '새로고침'}
                </button>
              </div>
              
              {/* 날짜 필터링 */}
              <div className="flex items-center gap-2 mb-3">
                  <input
                  type="date"
                  value={filters.dateRange.start}
                  onChange={(e) => setFilters({ 
                      ...filters, 
                      dateRange: { ...filters.dateRange, start: e.target.value } 
                  })}
                  className="text-xs py-1 px-2 bg-gray-50 border rounded-md flex-1"
                  />
                  <input
                  type="date"
                  value={filters.dateRange.end}
                  onChange={(e) => setFilters({ 
                      ...filters, 
                      dateRange: { ...filters.dateRange, end: e.target.value } 
                  })}
                  className="text-xs py-1 px-2 bg-gray-50 border rounded-md flex-1"
                  />
              </div>

              {/* 진료중 필터링 */}
              <div className="flex gap-1">
                  <div className="flex gap-2 text-xs h-6">
                      <select
                          className="bg-gray-50 w-full px-1 border rounded-md"
                          value={filters.state}
                          onChange={(e) => setFilters({ 
                              ...filters, 
                              state: e.target.value as TreatmentState 
                          })}
                          >
                          {Object.values(TreatmentState).map((state) => (
                              <option key={state} value={state}>{state}</option>
                          ))}
                      </select>

                      <select
                          className="bg-gray-50 w-full px-1 border rounded-md"
                          value={filters.state}
                          onChange={(e) => setFilters({ 
                              ...filters, 
                              state: e.target.value as TreatmentState 
                          })}
                          >
                          {Object.values(TreatmentState).map((state) => (
                              <option key={state} value={state}>{state}</option>
                          ))}
                      </select>
                  </div>
              </div>
          </div>

          {/* 제목과 QR 코드 버튼 */}
          <div className="flex justify-between items-center mb-3">
            <h2 className="font-semibold text-gray-700">목록</h2>
            <button
              onClick={openQrModal}
              className="bg-primary-500 hover:bg-primary-600 text-white text-xs rounded-md p-2 flex items-center"
              title="병원 QR 코드 생성"
            >
              <FaQrcode className="mr-1" /> QR 생성
            </button>
          </div>

          {/* 로딩 상태 표시 */}
          {isLoading && (
            <div className="text-center text-gray-500 text-sm py-4">
              반려동물 목록을 불러오는 중...
            </div>
          )}
          
          {/* 에러 메시지 표시 */}
          {error && (
            <div className="text-center text-red-500 text-sm py-2 px-3 bg-red-50 rounded-md mb-3">
              {error}
            </div>
          )}

          {/* 동물 목록 List */}
          <div className="flex flex-col gap-3 overflow-y-auto max-h-[calc(100vh-320px)]">
            {filteredPets.length > 0 ? (
              filteredPets.map((treatment, index) => (
                <PetListItem
                  key={`${treatment.id}-${index}`}
                  treatment={treatment}
                  isSelected={selectedPetIndex === index}
                  onSelect={() => setSelectedPetIndex(index)}
                  getStateColor={getStateColor}
                  getStateBadgeColor={getStateBadgeColor}
                />
              ))
            ) : (
              <div className="text-center text-gray-500 text-sm py-4">
                {isLoading ? '반려동물 목록을 불러오는 중...' : '반려동물 목록이 없습니다.'}
              </div>
            )}
          </div>
      </div>
      
      {/* QR 코드 생성 모달 */}
      <QRGenerator 
        visible={qrModalVisible} 
        onClose={closeQrModal} 
        hospitalInfo={hospitalInfo} 
      />
    </>
  );
};

export default TreatmentSidebar;


import { BlockchainInfo } from '../redux/slices/petSlice';
import { store } from '../redux/store';
import { selectMockDataForPet, generateMockDataForPet, selectDevModeEnabled } from '../redux/slices/devModeSlice';

// 개발 환경에서 블록체인 연결 여부 설정
export const DEV_USE_MOCK_BLOCKCHAIN = true;

// 개발 환경에서 사용할 가상 블록체인 데이터 생성 함수
export const generateMockBlockchainData = (id: string): BlockchainInfo => {
  return {
    transactionId: `0x${Math.random().toString(16).substring(2, 30)}${Math.random().toString(16).substring(2, 10)}`,
    timestamp: new Date().toISOString(),
    blockNumber: Math.floor(12340000 + Math.random() * 10000),
    dataHash: `0x${Math.random().toString(16).substring(2, 30)}${Math.random().toString(16).substring(2, 30)}`
  };
};

// 초기 목업 데이터
export const mockBlockchainData: Record<string, BlockchainInfo> = {
  'pet-1': {
    transactionId: '0x7f9a12e4b1b5c7d8e9f0a1b2c3d4e5f6a7b8c9d0',
    timestamp: '2023-03-01T15:30:45Z',
    blockNumber: 12345678,
    dataHash: '0xabcdef1234567890abcdef1234567890abcdef1234567890abcdef1234567890'
  },
  'pet-2': {
    transactionId: '0x8a2b3c4d5e6f7a8b9c0d1e2f3a4b5c6d7e8f9a0b',
    timestamp: '2023-03-02T10:15:20Z',
    blockNumber: 12345800,
    dataHash: '0x123456789abcdef0123456789abcdef0123456789abcdef0123456789abcdef0'
  },
  'pet-3': {
    transactionId: '0x9b0c1d2e3f4a5b6c7d8e9f0a1b2c3d4e5f6a7b8c',
    timestamp: '2023-03-03T08:45:30Z',
    blockNumber: 12346000,
    dataHash: '0xfedcba9876543210fedcba9876543210fedcba9876543210fedcba9876543210'
  }
};

// 블록체인 데이터 가져오기 (실제 또는 가상)
export const getBlockchainData = (petId: string): BlockchainInfo | null => {
  // 개발 모드 상태 확인
  const devModeEnabled = selectDevModeEnabled(store.getState());
  
  if (devModeEnabled) {
    console.log(`[DEV MODE] Getting blockchain data for pet ID: ${petId} with devMode: ${devModeEnabled}`);
    
    // 먼저 데이터를 생성 액션을 디스패치
    store.dispatch(generateMockDataForPet(petId));

    // 그리고 리덕스 스토어에서 데이터 가져오기
    const state = store.getState();
    const allMockData = state.devMode.mockBlockchainData;
    
    // 데이터가 존재하는지 확인
    if (allMockData && allMockData[petId]) {
      // 저장된 데이터 사용
      const data = allMockData[petId];
      console.log(`[DEV MODE] Data from store for ${petId}:`, data);
      return data;
    } else {
      // 데이터가 없으면 직접 생성 - 백업 방법
      console.log(`[DEV MODE] No data in store for ${petId}, creating backup data`);
      const backupData: BlockchainInfo = {
        transactionId: `0x${Math.random().toString(16).substring(2, 30)}${Math.random().toString(16).substring(2, 10)}`,
        timestamp: new Date().toISOString(),
        blockNumber: Math.floor(12340000 + Math.random() * 10000),
        dataHash: `0x${Math.random().toString(16).substring(2, 30)}${Math.random().toString(16).substring(2, 30)}`
      };
      
      // 생성한 데이터 직접 저장
      store.dispatch({ 
        type: 'devMode/setMockDataForPet', 
        payload: { petId, data: backupData } 
      });
      
      console.log(`[DEV MODE] Created backup data:`, backupData);
      return backupData;
    }
  }
  
  // 개발 모드가 꺼져 있으면 실제 블록체인 API 호출 (현재는 구현되지 않았으므로 null 반환)
  console.log(`[PROD MODE] No blockchain connection available for pet ID: ${petId}`);
  return null;
}; 
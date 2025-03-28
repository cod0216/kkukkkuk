/**
 * @module blockchainAuthService
 * @file blockchainAuthService.ts
 * @author haelim
 * @date 2025-03-26
 * @author seonghun
 * @date 2025-03-28
 * @description 블록체인 연결 및 MetaMask 계정 인증을 관리하는 서비스 모듈입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-28        seonghun         블록체인 서비스 연동
 */

import { ethers } from 'ethers';
import { NETWORK_CONFIG, DID_REGISTRY_ADDRESS, GAS_SETTINGS, didRegistryABI } from '@/utils/constants';

const CHAIN_ID = NETWORK_CONFIG.chainId.toString();

const CONTRACT_ADDRESSES = {
  didRegistry: DID_REGISTRY_ADDRESS
};

const REGISTRY_ABI = didRegistryABI;
// MetaMask가 연결된 계정 상태
interface AccountState {
  isConnected: boolean;
  address: string | null;
  chainId: string | null;
  provider: ethers.BrowserProvider | null;
  signer: ethers.JsonRpcSigner | null;
  registryContract: ethers.Contract | null;
}

// 초기 상태
const initialState: AccountState = {
  isConnected: false,
  address: null,
  chainId: null,
  provider: null,
  signer: null,
  registryContract: null
};

// 현재 상태를 저장할 변수
let accountState: AccountState = { ...initialState };

// 윈도우 객체 타입 확장 (전역)
declare global {
  interface Window {
    ethereum?: {
      isMetaMask?: boolean;
      request: (args: { method: string; params?: any[] }) => Promise<any>;
      on: (eventName: string, callback: (...args: any[]) => void) => void;
      removeListener: (eventName: string, callback: (...args: any[]) => void) => void;
    };
  }
}

/**
 * 현재 네트워크가 올바른지 확인하고, 필요시 네트워크 전환을 요청합니다.
 * @param provider ethers 프로바이더
 * @returns 네트워크 유효성 여부
 */
const ensureCorrectNetwork = async (provider: ethers.BrowserProvider): Promise<boolean> => {
  try {
    const network = await provider.getNetwork();
    const currentChainId = network.chainId.toString();
    
    // 사용자가 올바른 네트워크에 연결되어 있는지 확인
    if (currentChainId !== CHAIN_ID) {
      console.log(`현재 연결된 체인 ID: ${currentChainId}, 필요한 체인 ID: ${CHAIN_ID}`);
      
      // 네트워크 전환 요청
      try {
        if (!window.ethereum) {
          throw new Error('MetaMask가 설치되어 있지 않습니다.');
        }
        
        await window.ethereum.request({
          method: 'wallet_switchEthereumChain',
          params: [{ chainId: '0x' + parseInt(CHAIN_ID).toString(16) }],
        });
        return true;
      } catch (switchError: any) {
        // 네트워크가 지갑에 없는 경우, 추가 요청
        if (switchError.code === 4902) {
          try {
            if (!window.ethereum) {
              throw new Error('MetaMask가 설치되어 있지 않습니다.');
            }
            
            await window.ethereum.request({
              method: 'wallet_addEthereumChain',
              params: [
                {
                    chainId: '0x' + parseInt(CHAIN_ID).toString(16),
                  chainName: NETWORK_CONFIG.chainName,
                  rpcUrls: [NETWORK_CONFIG.rpcUrl],
                  nativeCurrency: NETWORK_CONFIG.nativeCurrency,
                  blockExplorerUrls: [], // 필요시 추가
                },
              ],
            });
            return true;
          } catch (addError) {
            console.error('네트워크 추가 실패:', addError);
            return false;
          }
        }
        console.error('네트워크 전환 실패:', switchError);
        return false;
      }
    }
    
    return true;
  } catch (error) {
    console.error('네트워크 확인 중 오류 발생:', error);
    return false;
  }
};

/**
 * MetaMask 연결 상태를 확인하고 필요시 연결합니다.
 * @returns 연결된 계정 정보
 */
export const connectWallet = async (): Promise<AccountState> => {
  if (typeof window === 'undefined' || !window.ethereum) {
    console.error('MetaMask가 설치되어 있지 않습니다.');
    throw new Error('MetaMask가 설치되어 있지 않습니다.');
  }

  try {
    const provider = new ethers.BrowserProvider(window.ethereum);
    
    // 네트워크 확인 및 전환
    const isCorrectNetwork = await ensureCorrectNetwork(provider);
    if (!isCorrectNetwork) {
      throw new Error('올바른 네트워크로 연결해주세요.');
    }
    
    // MetaMask에 연결 요청
    const accounts = await provider.send('eth_requestAccounts', []);
    
    if (accounts.length === 0) {
      throw new Error('계정 접근이 거부되었습니다.');
    }
    
    const signer = await provider.getSigner();
    const address = await signer.getAddress();
    const network = await provider.getNetwork();
    const chainId = network.chainId.toString();
    
    // 레지스트리 컨트랙트 초기화 (didRegistry만 사용)
    const registryContract = new ethers.Contract(
      CONTRACT_ADDRESSES.didRegistry, 
      REGISTRY_ABI, 
      signer
    );

    // 디버깅을 위한 컨트랙트 정보 출력
    console.log('컨트랙트 주소:', {
      registry: CONTRACT_ADDRESSES.didRegistry,
    });
    
    console.log('레지스트리 ABI에 getHospitalPets 함수가 있는지 확인:', 
      REGISTRY_ABI.some((item: any) => 
        item.name === 'getHospitalPets'
      )
    );

    // 상태 업데이트
    accountState = {
      isConnected: true,
      address,
      chainId,
      provider,
      signer,
      registryContract
    };

    // 연결 이벤트 리스너 설정
    setupEventListeners();
    
    console.log('MetaMask 연결 성공:', { address, chainId });
    return accountState;
  } catch (error: any) {
    console.error('MetaMask 연결 실패:', error);
    throw new Error(`MetaMask 연결 실패: ${error.message}`);
  }
};

/**
 * 현재 연결된 MetaMask 계정 정보를 조회합니다.
 * 연결되지 않은 경우 자동으로 연결을 시도합니다.
 * @returns 연결된 계정 정보
 */
export const getAccount = async (): Promise<AccountState> => {
  // 이미 연결되어 있으면 현재 상태 반환
  if (accountState.isConnected && accountState.signer) {
    try {
      // 연결 상태 검증
      const address = await accountState.signer.getAddress();
      return accountState;
    } catch (e) {
      // 상태가 유효하지 않으면 재연결
      return connectWallet();
    }
  }
  
  // 아직 연결되지 않았으면 연결 시도
  return connectWallet();
};

/**
 * MetaMask 계정 변경, 네트워크 변경 등의 이벤트를 처리하기 위한 리스너를 설정합니다.
 */
const setupEventListeners = () => {
  if (typeof window === 'undefined' || !window.ethereum) return;

  // 계정 변경 이벤트
  window.ethereum.on('accountsChanged', async (accounts: string[]) => {
    if (accounts.length === 0) {
      // 계정 연결 해제
      accountState = { ...initialState };
      console.log('MetaMask 계정 연결이 해제되었습니다.');
    } else {
      // 계정 변경 - 상태 업데이트
      try {
        await connectWallet();
      } catch (error) {
        console.error('계정 변경 후 재연결 실패:', error);
      }
    }
  });

  // 네트워크 변경 이벤트
  window.ethereum.on('chainChanged', async (chainId: string) => {
    // 네트워크 변경 - 상태 업데이트
    try {
      await connectWallet();
    } catch (error) {
      console.error('네트워크 변경 후 재연결 실패:', error);
    }
  });

  // 연결 해제 이벤트
  window.ethereum.on('disconnect', () => {
    accountState = { ...initialState };
    console.log('MetaMask 연결이 해제되었습니다.');
  });
};

/**
 * 현재 연결된 네트워크의 Chain ID를 반환합니다.
 * @returns Chain ID
 */
export const getChainId = async (): Promise<string | null> => {
  try {
    const { chainId } = await getAccount();
    return chainId;
  } catch (error) {
    console.error('Chain ID 조회 실패:', error);
    return null;
  }
};

/**
 * 현재 연결된 계정의 주소를 반환합니다.
 * @returns 계정 주소
 */
export const getAccountAddress = async (): Promise<string | null> => {
  try {
    const { address } = await getAccount();
    return address;
  } catch (error) {
    console.error('계정 주소 조회 실패:', error);
    return null;
  }
};

/**
 * 특정 네트워크로 전환을 요청합니다.
 * @param chainId 전환할 네트워크의 Chain ID (hex 형식, 예: '0x1')
 * @returns 성공 여부
 */
export const switchNetwork = async (chainId: string): Promise<boolean> => {
  if (typeof window === 'undefined' || !window.ethereum) {
    console.error('MetaMask가 설치되어 있지 않습니다.');
    return false;
  }

  try {
    await window.ethereum.request({
      method: 'wallet_switchEthereumChain',
      params: [{ chainId }],
    });
    return true;
  } catch (error: any) {
    console.error('네트워크 전환 실패:', error);
    return false;
  }
};

/**
 * 현재 연결 상태를 반환합니다.
 * @returns 연결 상태
 */
export const getConnectionStatus = (): boolean => {
  return accountState.isConnected;
};

/**
 * 서명자(signer)를 반환합니다.
 * @returns ethers Signer 객체
 */
export const getSigner = async (): Promise<ethers.JsonRpcSigner | null> => {
  try {
    const { signer } = await getAccount();
    return signer;
  } catch (error) {
    console.error('서명자 조회 실패:', error);
    return null;
  }
};

/**
 * 공급자(provider)를 반환합니다.
 * @returns ethers Provider 객체
 */
export const getProvider = async (): Promise<ethers.BrowserProvider | null> => {
  try {
    const { provider } = await getAccount();
    return provider;
  } catch (error) {
    console.error('Provider 조회 실패:', error);
    return null;
  }
};

/**
 * DID 레지스트리 컨트랙트를 반환합니다.
 * @returns 레지스트리 컨트랙트 객체
 */
export const getRegistryContract = async (): Promise<ethers.Contract | null> => {
  try {
    const { registryContract } = await getAccount();
    return registryContract;
  } catch (error) {
    console.error('레지스트리 컨트랙트 조회 실패:', error);
    return null;
  }
};

/**
 * 공유 컨트랙트 대신 DID 레지스트리 컨트랙트를 반환합니다.
 * 모든 공유 기능이 DID 레지스트리 컨트랙트로 통합되었습니다.
 * @returns 레지스트리 컨트랙트 객체
 */
export const getSharingContract = async (): Promise<ethers.Contract | null> => {
  // 호환성을 위해 유지하되, 실제로는 registryContract를 반환
  return getRegistryContract();
};

/**
 * 컨트랙트 주소를 반환합니다.
 * @returns 컨트랙트 주소 객체
 */
export const getContractAddresses = () => {
  return CONTRACT_ADDRESSES;
};

/**
 * 네트워크 설정을 반환합니다.
 * @returns 네트워크 설정 객체
 */
export const getNetworkConfig = () => {
  return NETWORK_CONFIG;
}; 
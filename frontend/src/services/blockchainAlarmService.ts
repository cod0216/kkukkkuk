/**
 * @module blockchainAlarmService
 * @file blockchainAlarmService.ts
 * @author AI assistant
 * @date 2025-03-31
 * @description 블록체인 이벤트를 구독하고 처리하는 서비스 모듈입니다.
 *              DID 레지스트리의 이벤트를 WebSocket을 통해 구독하고
 *              공유 계약 생성, 취소, 만료 예정 알림 등을 처리합니다.
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-31        seonghun     최초 생성
 */

import { ethers } from 'ethers';
import { NETWORK_CONFIG, DID_REGISTRY_ADDRESS, didRegistryABI } from '@/utils/constants';
import { Log } from 'ethers';

// 이벤트 타입 정의
export interface SharingAgreementEvent {
  petAddress: string;
  hospitalAddress: string;
  scope?: string;
  expireDate?: number;
  createdAt?: number;
  timestamp?: number;
  notificationTime?: number;
  transactionHash?: string;
}

// 이벤트 리스너 타입 정의
export type SharingEventListener = (event: SharingAgreementEvent) => void;

// 이벤트 구독 상태
interface SubscriptionState {
  provider: ethers.WebSocketProvider | null;
  contract: ethers.Contract | null;
  isConnected: boolean;
  listeners: {
    created: SharingEventListener[];
    revoked: SharingEventListener[];
    expiring: SharingEventListener[];
  };
}

// 초기 상태
const subscriptionState: SubscriptionState = {
  provider: null,
  contract: null,
  isConnected: false,
  listeners: {
    created: [],
    revoked: [],
    expiring: []
  }
};

/**
 * WebSocket 프로바이더를 초기화하고 컨트랙트에 연결합니다.
 * @returns 연결 성공 여부
 */
export const initWebSocketProvider = async (): Promise<boolean> => {
  try {
    // 기존 연결이 있다면 닫기
    if (subscriptionState.provider) {
      closeWebSocketConnection();
    }

    // WebSocket 프로바이더 생성
    const provider = new ethers.WebSocketProvider(NETWORK_CONFIG.wsUrl);
    
    // 연결 확인
    await provider.getBlockNumber();
    
    // 컨트랙트 인스턴스 생성
    const contract = new ethers.Contract(
      DID_REGISTRY_ADDRESS,
      didRegistryABI,
      provider
    );
    
    // 상태 업데이트
    subscriptionState.provider = provider;
    subscriptionState.contract = contract;
    subscriptionState.isConnected = true;
    
    console.log('WebSocket 연결 성공');
    
    // 자동 재연결 설정
    setupReconnection(provider);
    
    return true;
  } catch (error) {
    console.error('WebSocket 연결 실패:', error);
    subscriptionState.isConnected = false;
    return false;
  }
};

/**
 * 프로바이더 연결이 끊어질 경우 자동 재연결을 설정합니다.
 * @param provider WebSocket 프로바이더
 */
const setupReconnection = (provider: ethers.WebSocketProvider) => {
  // 웹소켓 객체 접근
  const websocket = (provider.provider as any)._websocket;
  
  if (websocket) {
    // 연결 종료 이벤트 리스너
    websocket.onclose = (event: CloseEvent) => {
      console.log('WebSocket 연결 종료, 재연결 시도 중...', event.code, event.reason);
      subscriptionState.isConnected = false;
      
      // 1초 후 재연결 시도
      setTimeout(() => {
        initWebSocketProvider().then(success => {
          if (success) {
            // 재연결 성공 시 이벤트 리스너 재등록
            subscribeToAllEvents();
          }
        });
      }, 1000);
    };
  }
};

/**
 * WebSocket 연결을 종료합니다.
 */
export const closeWebSocketConnection = () => {
  try {
    if (subscriptionState.provider) {
      (subscriptionState.provider.provider as any)._websocket.close();
      subscriptionState.provider = null;
      subscriptionState.contract = null;
      subscriptionState.isConnected = false;
      console.log('WebSocket 연결 종료');
    }
  } catch (error) {
    console.error('WebSocket 연결 종료 실패:', error);
  }
};

/**
 * SharingAgreementCreated 이벤트를 구독합니다.
 * @param listener 이벤트 처리 콜백 함수
 * @returns 구독 성공 여부
 */
export const subscribeSharingCreated = async (listener: SharingEventListener): Promise<boolean> => {
  if (!ensureConnection()) return false;
  
  try {
    subscriptionState.listeners.created.push(listener);
    
    if (subscriptionState.listeners.created.length === 1) {
      // 첫 번째 리스너일 경우에만 이벤트 구독 설정
      subscriptionState.contract?.on('SharingAgreementCreated', 
        (petAddress: string, hospitalAddress: string, scope: string, expireDate: bigint, createdAt: bigint, event: Log) => {
          const eventData: SharingAgreementEvent = {
            petAddress,
            hospitalAddress,
            scope,
            expireDate: Number(expireDate),
            createdAt: Number(createdAt),
            transactionHash: event.transactionHash
          };
          
          // 모든 리스너에게 이벤트 전달
          subscriptionState.listeners.created.forEach(cb => cb(eventData));
        }
      );
    }
    
    return true;
  } catch (error) {
    console.error('SharingAgreementCreated 이벤트 구독 실패:', error);
    return false;
  }
};

/**
 * SharingAgreementRevoked 이벤트를 구독합니다.
 * @param listener 이벤트 처리 콜백 함수
 * @returns 구독 성공 여부
 */
export const subscribeSharingRevoked = async (listener: SharingEventListener): Promise<boolean> => {
  if (!ensureConnection()) return false;
  
  try {
    subscriptionState.listeners.revoked.push(listener);
    
    if (subscriptionState.listeners.revoked.length === 1) {
      // 첫 번째 리스너일 경우에만 이벤트 구독 설정
      subscriptionState.contract?.on('SharingAgreementRevoked', 
        (petAddress: string, hospitalAddress: string, timestamp: bigint, event: Log) => {
          const eventData: SharingAgreementEvent = {
            petAddress,
            hospitalAddress,
            timestamp: Number(timestamp),
            transactionHash: event.transactionHash
          };
          
          // 모든 리스너에게 이벤트 전달
          subscriptionState.listeners.revoked.forEach(cb => cb(eventData));
        }
      );
    }
    
    return true;
  } catch (error) {
    console.error('SharingAgreementRevoked 이벤트 구독 실패:', error);
    return false;
  }
};

/**
 * SharingAgreementExpiringSoon 이벤트를 구독합니다.
 * @param listener 이벤트 처리 콜백 함수
 * @returns 구독 성공 여부
 */
export const subscribeSharingExpiring = async (listener: SharingEventListener): Promise<boolean> => {
  if (!ensureConnection()) return false;
  
  try {
    subscriptionState.listeners.expiring.push(listener);
    
    if (subscriptionState.listeners.expiring.length === 1) {
      // 첫 번째 리스너일 경우에만 이벤트 구독 설정
      subscriptionState.contract?.on('SharingAgreementExpiringSoon', 
        (petAddress: string, hospitalAddress: string, expireDate: bigint, notificationTime: bigint, event: Log) => {
          const eventData: SharingAgreementEvent = {
            petAddress,
            hospitalAddress,
            expireDate: Number(expireDate),
            notificationTime: Number(notificationTime),
            transactionHash: event.transactionHash
          };
          
          // 모든 리스너에게 이벤트 전달
          subscriptionState.listeners.expiring.forEach(cb => cb(eventData));
        }
      );
    }
    
    return true;
  } catch (error) {
    console.error('SharingAgreementExpiringSoon 이벤트 구독 실패:', error);
    return false;
  }
};

/**
 * 모든 공유 계약 관련 이벤트를 구독합니다.
 */
export const subscribeToAllEvents = async () => {
  await Promise.all([
    subscribeSharingCreated(() => {}),
    subscribeSharingRevoked(() => {}),
    subscribeSharingExpiring(() => {})
  ]);
};

/**
 * 공유 계약 이벤트 구독을 해제합니다.
 * @param listener 제거할 리스너 함수
 * @param eventType 이벤트 타입 (created, revoked, expiring)
 */
export const unsubscribeFromEvent = (
  listener: SharingEventListener, 
  eventType: 'created' | 'revoked' | 'expiring'
) => {
  const listeners = subscriptionState.listeners[eventType];
  const index = listeners.indexOf(listener);
  
  if (index !== -1) {
    listeners.splice(index, 1);
  }
  
  // 모든 리스너가 제거되면 이벤트 구독 해제
  if (listeners.length === 0 && subscriptionState.contract) {
    const eventName = 
      eventType === 'created' ? 'SharingAgreementCreated' :
      eventType === 'revoked' ? 'SharingAgreementRevoked' : 'SharingAgreementExpiringSoon';
    
    subscriptionState.contract.removeAllListeners(eventName);
  }
};

/**
 * 모든 이벤트 구독을 해제합니다.
 */
export const unsubscribeFromAllEvents = () => {
  if (subscriptionState.contract) {
    subscriptionState.contract.removeAllListeners('SharingAgreementCreated');
    subscriptionState.contract.removeAllListeners('SharingAgreementRevoked');
    subscriptionState.contract.removeAllListeners('SharingAgreementExpiringSoon');
    
    // 리스너 배열 초기화
    subscriptionState.listeners.created = [];
    subscriptionState.listeners.revoked = [];
    subscriptionState.listeners.expiring = [];
  }
};

/**
 * WebSocket 연결 상태를 확인하고, 필요시 재연결합니다.
 * @returns 연결 성공 여부
 */
const ensureConnection = async (): Promise<boolean> => {
  if (!subscriptionState.isConnected || !subscriptionState.provider || !subscriptionState.contract) {
    return await initWebSocketProvider();
  }
  return true;
};

/**
 * 공유 계약 생성 시간과 만료 시간을 가져옵니다.
 * @param petAddress 반려동물 주소
 * @param hospitalAddress 병원 주소
 * @returns 계약 정보 (존재 여부, 생성 시간, 만료 시간)
 */
export const getSharingAgreementTimes = async (
  petAddress: string,
  hospitalAddress: string
): Promise<{ exists: boolean; createdAt: number; expireDate: number }> => {
  if (!ensureConnection()) {
    return { exists: false, createdAt: 0, expireDate: 0 };
  }
  
  try {
    const agreement = await subscriptionState.contract?.getAgreementDetails(petAddress, hospitalAddress);
    
    if (!agreement || !agreement.exists) {
      return { exists: false, createdAt: 0, expireDate: 0 };
    }
    
    return {
      exists: true,
      createdAt: Number(agreement.createdAt),
      expireDate: Number(agreement.expireDate)
    };
  } catch (error) {
    console.error('공유 계약 정보 조회 실패:', error);
    return { exists: false, createdAt: 0, expireDate: 0 };
  }
};

/**
 * 연결 상태를 확인합니다.
 * @returns 현재 WebSocket 연결 상태
 */
export const getConnectionStatus = (): boolean => {
  return subscriptionState.isConnected;
};

/**
 * 시간 변환 유틸리티: 유닉스 타임스탬프를 Date 객체로 변환
 * @param timestamp 유닉스 타임스탬프
 * @returns Date 객체
 */
export const timestampToDate = (timestamp: number): Date => {
  return new Date(timestamp * 1000);
};

/**
 * 날짜 포맷팅 유틸리티: Date 객체를 'YYYY-MM-DD HH:mm:ss' 형식 문자열로 변환
 * @param date Date 객체
 * @returns 포맷팅된 날짜 문자열
 */
export const formatDate = (date: Date): string => {
  const pad = (num: number) => num.toString().padStart(2, '0');
  
  const year = date.getFullYear();
  const month = pad(date.getMonth() + 1);
  const day = pad(date.getDate());
  const hours = pad(date.getHours());
  const minutes = pad(date.getMinutes());
  const seconds = pad(date.getSeconds());
  
  return `${year}-${month}-${day} ${hours}:${minutes}:${seconds}`;
};

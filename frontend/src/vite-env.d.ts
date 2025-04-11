/// <reference types="vite/client" />


interface Window {
    ethereum?: {
      isMetaMask?: boolean;
      request: (args: { method: string; params?: any[] }) => Promise<any>;
      on: (eventName: string, callback: (...args: any[]) => void) => void;
      removeListener: (eventName: string, callback: (...args: any[]) => void) => void;
    };
    
    // ethers 라이브러리 전역 정의
    ethers?: {
      BrowserProvider: new (provider: any) => any;
      Contract: new (address: string, abi: any, signerOrProvider: any) => any;
    };
  } 
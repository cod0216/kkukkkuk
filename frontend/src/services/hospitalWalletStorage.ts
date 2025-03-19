import CryptoJS from "crypto-js";
import { ethers } from "ethers";

// 병원 개인키를 암호화하여 로컬 스토리지에 저장
export const encryptAndStorePrivateKey = (
  credentials: {
    privateKey: string;
    publicKey: string;
    address: string;
    did: string;
    mnemonic: string;
  },
  password: string,
  hospitalId: string
): void => {
  try {
    // 1. 개인키와 니모닉 암호화 (AES 알고리즘 사용)
    const encryptedPrivateKey = CryptoJS.AES.encrypt(
      credentials.privateKey,
      password
    ).toString();

    const encryptedMnemonic = CryptoJS.AES.encrypt(
      credentials.mnemonic,
      password
    ).toString();

    // 2. 저장할 데이터 구조 생성
    const walletData = {
      encryptedPrivateKey,
      encryptedMnemonic,
      publicKey: credentials.publicKey,
      address: credentials.address,
      did: credentials.did,
      version: "1.0",
      timestamp: Date.now(),
    };

    // 3. 로컬 스토리지에 저장
    localStorage.setItem(`wallet_${hospitalId}`, JSON.stringify(walletData));

    // 4. 주소와 DID는 별도로 저장 (복호화 없이 접근 가능하도록)
    localStorage.setItem(`address_${hospitalId}`, credentials.address);
    localStorage.setItem(`did_${hospitalId}`, credentials.did);
  } catch (error) {
    console.error("개인키 암호화 및 저장 실패:", error);
    throw new Error("개인키를 암호화하여 저장하는 데 실패했습니다.");
  }
};

// 로컬 스토리지에서 암호화된 개인키 복호화
export const decryptPrivateKey = (
  password: string,
  hospitalId: string
): {
  privateKey: string;
  publicKey: string;
  address: string;
  did: string;
  mnemonic: string;
} => {
  try {
    // 1. 로컬 스토리지에서 암호화된 데이터 가져오기
    const walletDataJson = localStorage.getItem(`wallet_${hospitalId}`);

    if (!walletDataJson) {
      throw new Error("저장된 지갑 정보를 찾을 수 없습니다.");
    }

    const walletData = JSON.parse(walletDataJson);

    // 2. 개인키 복호화
    const privateKeyBytes = CryptoJS.AES.decrypt(
      walletData.encryptedPrivateKey,
      password
    );
    const privateKey = privateKeyBytes.toString(CryptoJS.enc.Utf8);

    // 3. 개선된 개인키 유효성 검증
    try {
      // ethers.js의 Wallet을 사용하여 개인키 유효성 검증
      const wallet = new ethers.Wallet(privateKey);

      // 로컬 스토리지의 주소와 일치하는지 추가 검증
      if (wallet.address.toLowerCase() !== walletData.address.toLowerCase()) {
        throw new Error("복호화된 개인키가 저장된 주소와 일치하지 않습니다.");
      }
    } catch (error) {
      throw new Error("비밀번호가 올바르지 않거나 개인키가 유효하지 않습니다.");
    }

    // 4. 니모닉 복호화
    const mnemonicBytes = CryptoJS.AES.decrypt(
      walletData.encryptedMnemonic,
      password
    );
    const mnemonic = mnemonicBytes.toString(CryptoJS.enc.Utf8);

    // 5. 복호화된 개인키와 관련 정보 반환
    return {
      privateKey,
      publicKey: walletData.publicKey,
      address: walletData.address,
      did: walletData.did,
      mnemonic,
    };
  } catch (error) {
    console.error("개인키 복호화 실패:", error);
    throw error;
  }
};

// 니모닉을 이용한 지갑 복구 기능
export const recoverWalletFromMnemonic = (
  mnemonic: string
): {
  privateKey: string;
  publicKey: string;
  address: string;
  did: string;
} => {
  try {
    // 니모닉으로부터 지갑 복구
    const wallet = ethers.Wallet.fromPhrase(mnemonic);

    // 복구된 지갑 정보 반환
    return {
      privateKey: wallet.privateKey,
      publicKey: wallet.publicKey,
      address: wallet.address,
      did: `did:ethr:${wallet.address.toLowerCase()}`,
    };
  } catch (error) {
    console.error("니모닉을 이용한 지갑 복구 실패:", error);
    throw new Error("유효하지 않은 니모닉 구문입니다.");
  }
};

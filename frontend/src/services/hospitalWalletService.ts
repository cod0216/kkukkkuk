import { ethers } from "ethers";

export const createHospitalCredentials = (): {
  privateKey: string;
  publicKey: string;
  address: string;
  did: string;
  mnemonic: string;
} => {
  try {
    // 1. 무작위 지갑 생성 (BIP39 표준의 니모닉 포함)
    const wallet = ethers.Wallet.createRandom();

    // 2. 지갑 정보 추출
    const privateKey = wallet.privateKey;
    const publicKey = wallet.publicKey;
    const address = wallet.address;

    // 3. 이더리움 기반 DID 생성 (did:ethr: 형식 사용)
    const did = `did:ethr:${address.toLowerCase()}`;

    // 4. 니모닉 구문 추출 (지갑 복구용)
    const mnemonic = wallet.mnemonic?.phrase;

    if (!mnemonic) {
      throw new Error("니모닉 구문 생성에 실패했습니다.");
    }

    // 5. 생성된 자격 증명 반환
    return {
      privateKey,
      publicKey,
      address,
      did,
      mnemonic,
    };
  } catch (error) {
    console.error("병원 자격 증명 생성 실패:", error);
    throw new Error("암호화폐 자격 증명을 생성하는 데 실패했습니다.");
  }
};

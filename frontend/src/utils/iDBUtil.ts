import { openDB, DBSchema } from "idb";

/**
 * @module iDBUtil
 * @file iDBUtil.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description IndexedDB를 활용한 refreshToken 저장 유틸을 제공하는 모듈입니다.
 *
 * 이 모듈은 RefreshToken을 저장하고 조회 및 삭제를 합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

/**
 * IndexedDB 스키마 정의 인터페이스
 */
interface AuthDB extends DBSchema {
  auth: {
    key: string;
    value: string;
  };
}

const DB_NAME = "KukkKukk";
const DB_VERSION = 1;
const STORE_NAME = "auth";

/**
 * IndexedDB 데이터베이스를 초기화하고 변환합니다
 *
 * @returns AuthDB 타입의 IndexedDB 인스턴스
 */
async function getDB() {
  return openDB<AuthDB>(DB_NAME, DB_VERSION, {
    upgrade(db) {
      if (!db.objectStoreNames.contains(STORE_NAME)) {
        db.createObjectStore(STORE_NAME);
      }
    },
  });
}

/**
 * refreshToken을 IndexedDB에 저장합니다.
 *
 * @param token - refreshToken
 */
export async function setRefreshtoken(token: string): Promise<void> {
  console.log("저장할 refreshToken:", token);
  const db = await getDB();
  await db.put(STORE_NAME, token, "refreshToken");
}

/**
 * IndexedDB에서 저장된 refreshToken을 조회합니다.
 *
 * @returns refreshToken
 */
export async function getRefreshToken(): Promise<string | undefined> {
  const db = await getDB();
  return await db.get(STORE_NAME, "refreshToken");
}

/**
 * IndexedDB에서 저장된 refreshToken을 삭제합니다.
 */
export async function removeRefreshToken(): Promise<void> {
  const db = await getDB();
  await db.delete(STORE_NAME, "refreshToken");
}

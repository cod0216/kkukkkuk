import {openDB, DBSchema} from "idb";

interface AuthDB extends DBSchema {
    auth: {
        key: string;
        value: string;
    };
}

const DB_NAME = "KukkKukk";
const DB_VERSION = 1;
const STORE_NAME = "auth";

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
 * 리프래쉬 토큰을 iDB에 저장합니다.
 */
export async function setRefreshtoken(token: string): Promise<void> {
    const db = await getDB();
    await db.put(STORE_NAME, token, "refreshToken");
}

/**
 * 저장된 리프래쉬 토큰을 조회합니다.
 */
export async function getRefreshToken(): Promise<string | undefined> {
    const db = await getDB();
    return await db.get(STORE_NAME, "refreshToken");
}

/**
 * 리프래쉬 토큰 삭제
 */
export async function removeRefreshToken(): Promise<void> {
    const db = await getDB();
    await db.delete(STORE_NAME, "refreshToken");
}

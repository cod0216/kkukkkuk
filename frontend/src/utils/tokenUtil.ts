import { store } from "@/redux/store";
// import { StorageKey } from "@/types";

/**
 * getAccessToken from Redux
 */
export const getAccessToken = (): string | null => {
  const state = store.getState();
  return state.auth.accessToken;
};

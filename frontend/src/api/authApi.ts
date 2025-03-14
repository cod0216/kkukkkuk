import { AxiosResponse } from "axios";
import api from "./interceptors";

// --------로그인 API-------------

export interface Hospital {
  id: number;
  did: string;
  account: string;
  name: string;
  email: string;
}

export interface Tokens {
  access_token: string;
  refresh_token: string;
}

export interface LoginResponseData {
  hospital: Hospital;
  tokens: Tokens;
}

export interface LoginResponse {
  status: string;
  message: string;
  data: LoginResponseData | null;
}

export async function login(
  account: string,
  password: string
): Promise<LoginResponseData> {
  try {
    const response: AxiosResponse<LoginResponse> = await api.post(
      "/api/auth/hospitals/login",
      {
        account,
        password,
      }
    );

    if (response.data.status === "SUCCESS" && response.data.data) {
      const { hospital, tokens } = response.data.data;

      localStorage.setItem("accessToken", tokens.access_token);

      document.cookie = `refresh_token=${tokens.refresh_token}; path=/;`;

      return { hospital, tokens };
    } else {
      throw new Error(
        response.data.message || "로그인에 실패했습니다. 다시 시도해 주세요."
      );
    }
  } catch (error: any) {
    throw new Error(error?.response?.data?.message || error.message);
  }
}

// --------회원가입 API-------------
export interface SignupResponseData {
  id: number;
  did: string;
  account: string;
  name: string;
}

export interface SingupResponse {
  status: string;
  message: string;
  data: SignupResponseData | null;
}

export async function signup(
  account: string,
  password: string,
  hospitalId: number,
  did: string,
  license_number: string,
  doctor_name: string
): Promise<SignupResponseData> {
  try {
    const response: AxiosResponse<SingupResponse> = await api.post(
      "/api/auth/hospitals/signup",
      {
        account,
        password,
        id: hospitalId,
        did,
        license_number,
        doctor_name,
      }
    );

    if (response.data.status === "SUCCESS" && response.data.data) {
      return response.data.data;
    } else {
      throw new Error(response.data.message || "회원가입이 완료되었습니다.");
    }
  } catch (error: any) {
    throw new Error(error?.response?.data?.message || error.message);
  }
}

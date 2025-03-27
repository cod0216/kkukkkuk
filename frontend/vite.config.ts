import { defineConfig } from "vite";
import react from "@vitejs/plugin-react-swc";
import path from "path";

/**
 * @module vite.config
 * @file Logvite.config.ts
 * @author eunchang
 * @date 2025-03-26
 * @description Vite 빌드 도구 설정 모듈입니다.
 *
 * 이 모듈은 React SWC 플러그인을 사용한 Vite 환경 설정을
 * 정의하며, 절대경로 설정 및 별칭(alias) 기능을 구성합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

/**
 * 절대경로 설정 및 별칭을 지정합니다.
 */
export default defineConfig({
  plugins: [react()],
  resolve: {
    alias: [{ find: "@", replacement: path.resolve(__dirname, "src") }],
  },
  server: {
    port: 3000, 
  }
});

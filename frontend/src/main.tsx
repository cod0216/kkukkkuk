import { StrictMode } from "react";
import { Provider } from "react-redux";
import { createRoot } from "react-dom/client";
import "./index.css";
import App from "./App.tsx";
import { store } from "@/redux/store.ts";
import { BrowserRouter } from "react-router-dom";

/**
 * @module main
 * @file main.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 애플리케이션의 진입점 모듈입니다.
 *
 * 이 모듈은 앱의 전역 상태와 라우팅 환경을 설정합니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        eunchang         최초 생성
 */

createRoot(document.getElementById("root")!).render(
  <StrictMode>
    <Provider store={store}>
      <BrowserRouter>
        <App />
      </BrowserRouter>
    </Provider>
  </StrictMode>
);

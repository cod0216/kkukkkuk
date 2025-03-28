import { useNavigate } from "react-router-dom";

/**
 * @module useAppNavigation
 * @file useAppNavigation.ts
 * @author haelim
 * @date 2025-03-27
 * @description 네비게이션 사용을 위한 커스텀 훅입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-27        haelim         최초 생성
 */


const useAppNavigation = () => {
  const navigate = useNavigate();

  return {
    goHome: () => navigate("/"),
    goToTreatment: () => navigate("/"),
    goToSignUp: () => navigate("/sign-up"),
    goToLogin: () => navigate("/login"),
    goToFindPw: () => navigate("/find-password"),
  };
};

export default useAppNavigation;

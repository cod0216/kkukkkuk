import { useNavigate } from "react-router-dom";
import { ErrorType } from "@/pages/common/ErrorPage";

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
 * 2025-03-30        sangmuk        마이페이지 네비게이션 추가
 * 2025-04-07        AI-Assistant   에러 페이지 네비게이션 추가
 */


const useAppNavigation = () => {
  const navigate = useNavigate();

  // 에러 페이지로 이동하는 함수
  const goToError = (type: ErrorType) => {
    if (type === '404') {
      navigate('/non-existent-path', { replace: true });  // 404는 catch-all 라우트로 자동 리다이렉트
    } else {
      navigate(`/error/${type}`);
    }
  };

  return {
    goHome: () => navigate("/"),
    goToTreatment: () => navigate("/"),
    goToSignUp: () => navigate("/sign-up"),
    goToLogin: () => navigate("/login"),
    goToFindPw: () => navigate("/find-password"),
    goToMyPage: () => navigate("/my-page"),
    
    // 에러 페이지 네비게이션
    goToError,
    goTo404: () => goToError('404'),
    goTo403: () => goToError('403'),
    goTo500: () => goToError('500'),
    goToNetworkError: () => goToError('network'),
    goToBlockchainError: () => goToError('blockchain'),
  };
};

export default useAppNavigation;

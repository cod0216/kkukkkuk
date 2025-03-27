import { useNavigate } from "react-router-dom";

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

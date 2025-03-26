import React from "react";
import { FaPaw } from "react-icons/fa";
import { useDispatch, useSelector } from "react-redux";
import { RootState } from "@/redux/store";
import { logout as logoutApi } from "@/services/authService";
import { clearAccessToken } from "@/redux/store";
import { removeRefreshToken } from "@/utils/iDBUtil";
import { useNavigate } from "react-router-dom";

const Header: React.FC = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const hospital = useSelector((state: RootState) => state.auth.hospital);

  const handleLogout = async () => {
    try {
      await logoutApi();
      dispatch(clearAccessToken());
      await removeRefreshToken();
      navigate("/");
    } catch (error) {
      console.error(error);
    }
  };
  return (
    <header className="bg-white border border-gray-100 border-2 py-1">
      <div className="container mx-auto px-3 py-2 flex justify-between items-center">
        <div className="flex items-center cursor-pointer">
          <FaPaw className="text-primary-500 text-2xl mr-2" />
          <div className="text-xl font-bold text-primary-500">KKUK KKUK</div>
        </div>
        <div className="flex items-center space-x-2">
          <div className="text-sm font-medium">
            {hospital ? hospital.name : "사용자"}
          </div>
          <button
            onClick={handleLogout}
            className="px-2 py-1 border rounded-md text-xs font-medium text-nowrap w-20 justify-center hover:bg-neutral-200"
          >
            로그아웃
          </button>
        </div>
      </div>
    </header>
  );
};

export default Header;

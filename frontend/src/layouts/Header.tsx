import React, { useEffect, useState } from "react";
import { FaPaw } from "react-icons/fa";
import { useDispatch, useSelector } from "react-redux";
import { RootState, clearAccessToken, setHospital } from "@/redux/store";
import { logout as logoutApi } from "@/services/authService";
import { removeRefreshToken } from "@/utils/iDBUtil";
import { useNavigate } from "react-router-dom";
import useAppNavigation from "@/hooks/useAppNavigation"
import { HospitalDetail } from "@/interfaces";
import { request } from "@/services/apiRequest"
import { ApiResponse, ResponseStatus } from "@/types"
import QRGenerator from '@/pages/treatment/QRGenerator';
import { getAccountAddress } from '@/services/blockchainAuthService';
import { LuLogIn, LuLogOut, LuUser, LuQrCode } from 'react-icons/lu';

/**
 * @module Header
 * @file Header.tsx
 * @author eunchang
 * @date 2025-03-26
 * @description 상단에 헤더를 표시하는 모듈입니다.
 *
 * 이 모듈은 해더를 보여줍니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-03-26        haelim           최초 생성
 * 2025-03-26        eunchang         로그아웃 버튼 생성
 * 2025-03-27        eunchang         로그인 표시 및 토큰 미 존재 시 리다이렉션
 * 2025-03-28        eunchang         토큰 name으로 사용자 이름 표시
 * 2025-03-30        sangmuk          헤더 병원 이름 클릭 시 마이페이지로 이동하도록 수정
 * 2025-03-31        sangmuk          회원정보 수정 시 헤더의 병원 이름이 같이 변경되도록 수정
 * 2025-03-31        seonghun         QR 보기 버튼 로그아웃 버튼 우측으로 이동
 * 2025-04-01        seonghun         QR 보기 버튼 높이 너비 조정
 * 2025-04-02        seonghun         QR, 마이페이지, 로그인/로그아웃 아이콘으로 변경
 */

const Header: React.FC = () => {
  const dispatch = useDispatch();
  const navigate = useNavigate();
  const accessToken = useSelector((state: RootState) => state.auth.accessToken);
  const hospital = useSelector((state: RootState) => state.auth.hospital as HospitalDetail | null);
  const [qrModalVisible, setQrModalVisible] = React.useState(false);
  const [hospitalInfo, setHospitalInfo] = useState({
    name: '',
    address: '',
    did: ''
  });

  const { goToMyPage, goHome } = useAppNavigation()

  useEffect(() => {
    const fetchHospitalInfo = async () => {
      if (accessToken && !hospital) {
        const response: ApiResponse<any> = await request.get("/api/hospitals/me")

        if (response.status === ResponseStatus.SUCCESS && response.data) {
          const hospitalForDispatch: HospitalDetail = {
            id: response.data.id,
            email: response.data.email,
            name: response.data.name,
            phone_number: response.data.phoneNumber,
            account: response.data.account,
            address: response.data.address,
            public_key: response.data.publicKey,
            authorization_number: response.data.authorizationNumber,
            doctor_name: response.data.doctorName,
            x_axis: response.data.xaxis,
            y_axis: response.data.yaxis,
          }
          dispatch(setHospital(hospitalForDispatch))
        }
      }
    }

    fetchHospitalInfo()
  }, [accessToken, hospital, dispatch])

  // const decodeTokenPayload = (token: string) => {
  //   try {
  //     const payloadBase64 = token.split(".")[1];
  //     const decoded = decodeURIComponent(
  //       atob(payloadBase64)
  //         .split("")
  //         .map((c) => "%" + ("00" + c.charCodeAt(0).toString(16)).slice(-2))
  //         .join("")
  //     );
  //     return JSON.parse(decoded);
  //   } catch (error) {
  //     console.error("Token decoding failed", error);
  //     return null;
  //   }
  // };

  let userName = hospital?.name ?? "사용자"
  // if (accessToken) {
  //   const payload = decodeTokenPayload(accessToken);
  //   if (payload && payload.name) {
  //     userName = payload.name;
  //   }
  // }

  // 병원 정보 가져오기
  useEffect(() => {
    const fetchHospitalInfo = async () => {
      try {
        const accountAddress = await getAccountAddress();
        if (accountAddress) {
          setHospitalInfo({
            name: userName, // 토큰에서 가져온 병원명 사용
            address: accountAddress,
            did: accountAddress // 이더리움 주소를 DID로 사용
          });
        }
      } catch (error) {
        console.error('병원 정보 가져오기 오류:', error);
      }
    };
    
    if (accessToken) {
      fetchHospitalInfo();
    }
  }, [accessToken, userName]);

  const handleLogout = async () => {
    try {
      await logoutApi();
      dispatch(clearAccessToken());
      await removeRefreshToken();
      navigate("/login");
    } catch (error) {
      console.error(error);
    }
  };

  const openQrModal = () => {
    setQrModalVisible(true);
  };

  const closeQrModal = () => {
    setQrModalVisible(false);
  };

  return (
    <header className="bg-white border-gray-100 border-2 py-1">
      <div className="container mx-auto px-3 py-2 flex justify-between items-center">
        <div className="flex items-center cursor-pointer" onClick={goHome}>
          <FaPaw className="text-primary-500 text-2xl mr-2" />
          <div className="text-xl font-bold text-primary-500">KKUK KKUK</div>
        </div>
        <div className="flex items-center space-x-4">
          <span className="text-sm font-medium text-gray-700">{userName}</span>
          {accessToken ? (
            <>
              <button
                onClick={goToMyPage}
                className="p-2 rounded-full hover:bg-gray-200 text-gray-600 flex items-center justify-center"
                title="마이페이지"
              >
                <LuUser className="w-5 h-5" />
              </button>
              <button
                onClick={openQrModal}
                className="p-2 rounded-full hover:bg-gray-200 text-gray-600 flex items-center justify-center"
                title="병원 QR 코드 보기"
              >
                <LuQrCode className="w-5 h-5" />
              </button>
              <button
                onClick={handleLogout}
                className="p-2 rounded-full hover:bg-gray-200 text-gray-600 flex items-center justify-center"
                title="로그아웃"
              >
                <LuLogOut className="w-5 h-5" />
              </button>
            </>
          ) : (
            <button
              onClick={() => navigate("/login")}
              className="p-2 rounded-full hover:bg-gray-200 text-gray-600 flex items-center justify-center"
              title="로그인"
            >
              <LuLogIn className="w-5 h-5" />
            </button>
          )}
        </div>
      </div>
      <QRGenerator 
        visible={qrModalVisible} 
        onClose={closeQrModal} 
        hospitalInfo={hospitalInfo}
      />
    </header>
  );
};

export default Header;

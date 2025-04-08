import React from 'react';
import { FaExclamationTriangle, FaHome, FaRedoAlt } from 'react-icons/fa';
import { useNavigate } from 'react-router-dom';

/**
 * @module ErrorPage
 * @file ErrorPage.tsx
 * @author AI-Assistant
 * @date 2025-04-07
 * @description 에러 페이지 컴포넌트
 * 
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-07        AI-Assistant     최초 생성
 */

export type ErrorType = '404' | '403' | '500' | 'network' | 'blockchain';

interface ErrorPageProps {
  type?: ErrorType;
  title?: string;
  message?: string;
  onRetry?: () => void;
}

const ErrorPage: React.FC<ErrorPageProps> = ({ 
  type = '404', 
  title,
  message,
  onRetry 
}) => {
  const navigate = useNavigate();

  // 에러 타입별 기본 설정
  const errorConfigs = {
    '404': {
      title: '페이지를 찾을 수 없습니다',
      message: '요청하신 페이지가 존재하지 않거나 이동되었습니다.',
      icon: <FaExclamationTriangle className="w-16 h-16 text-yellow-500" />
    },
    '403': {
      title: '접근 권한이 없습니다',
      message: '이 페이지에 대한 접근 권한이 없습니다. 로그인이 필요할 수 있습니다.',
      icon: <FaExclamationTriangle className="w-16 h-16 text-red-500" />
    },
    '500': {
      title: '서버 오류가 발생했습니다',
      message: '서버에서 오류가 발생했습니다. 잠시 후 다시 시도해주세요.',
      icon: <FaExclamationTriangle className="w-16 h-16 text-red-500" />
    },
    'network': {
      title: '네트워크 연결 오류',
      message: '네트워크 연결이 불안정합니다. 인터넷 연결을 확인하고 다시 시도해주세요.',
      icon: <FaExclamationTriangle className="w-16 h-16 text-blue-500" />
    },
    'blockchain': {
      title: '블록체인 트랜잭션 오류',
      message: '블록체인 트랜잭션 처리 중 오류가 발생했습니다. 메타마스크 상태를 확인하고 다시 시도해주세요.',
      icon: <FaExclamationTriangle className="w-16 h-16 text-primary-500" />
    }
  };

  const config = errorConfigs[type];

  return (
    <div className="flex items-center justify-center min-h-screen bg-gray-50">
      <div className="text-center p-6 max-w-md mx-auto">
        <div className="mb-6 flex justify-center">
          {config.icon}
        </div>
        
        <h1 className="text-2xl font-bold text-gray-800 mb-3">
          {title || config.title}
        </h1>
        
        <p className="text-gray-600 mb-8">
          {message || config.message}
        </p>
        
        <div className="flex justify-center gap-4">
          <button
            onClick={() => navigate('/')}
            className="px-4 py-2 bg-gray-200 text-gray-700 rounded-md hover:bg-gray-300 flex items-center gap-2"
          >
            <FaHome className="w-4 h-4" />
            <span>홈으로</span>
          </button>
          
          {onRetry && (
            <button
              onClick={onRetry}
              className="px-4 py-2 bg-primary-500 text-white rounded-md hover:bg-primary-600 flex items-center gap-2"
            >
              <FaRedoAlt className="w-4 h-4" />
              <span>다시 시도</span>
            </button>
          )}
        </div>
      </div>
    </div>
  );
};

export default ErrorPage; 
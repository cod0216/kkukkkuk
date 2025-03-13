import React from 'react';
import { Link } from 'react-router-dom';
import { useAppSelector } from '../redux/store';

const NotFound: React.FC = () => {
  const { isAuthenticated } = useAppSelector(state => state.auth);
  
  return (
    <div className="flex flex-col items-center justify-center min-h-screen px-4 py-12 bg-gray-100 dark:bg-gray-900">
      <div className="w-full max-w-md p-8 space-y-8 text-center bg-white rounded-lg shadow-md dark:bg-gray-800">
        <h1 className="text-6xl font-bold text-primary">404</h1>
        <h2 className="text-2xl font-semibold text-gray-800 dark:text-gray-200">페이지를 찾을 수 없습니다</h2>
        <p className="text-gray-600 dark:text-gray-400">
          요청하신 페이지가 존재하지 않거나 이동되었을 수 있습니다.
        </p>
        <div className="mt-6">
          <Link
            to={isAuthenticated ? "/dashboard" : "/login"}
            className="inline-flex items-center px-4 py-2 text-sm font-medium text-white bg-primary border border-transparent rounded-md shadow-sm hover:bg-opacity-90 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-primary"
          >
            {isAuthenticated ? '대시보드로 돌아가기' : '로그인 페이지로 이동'}
          </Link>
        </div>
      </div>
    </div>
  );
};

export default NotFound; 
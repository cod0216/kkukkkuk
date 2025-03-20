import React from 'react';
import { Link } from 'react-router-dom';

const Footer: React.FC = () => {
  const currentYear = new Date().getFullYear();
  
  return (
    <footer className="bg-gray-100 dark:bg-gray-900 mt-auto">
      <div className="container mx-auto px-4 py-6">
        <div className="flex flex-col md:flex-row justify-between items-center">
          <div className="mb-4 md:mb-0">
            <Link to="/" className="text-xl font-semibold text-indigo-600 dark:text-indigo-400">
              KKuK KKuK
            </Link>
            <p className="mt-2 text-sm text-gray-600 dark:text-gray-400">
              동물병원 진료 기록 관리 시스템
            </p>
          </div>
          
          <div className="text-sm text-gray-600 dark:text-gray-400">
            &copy; {currentYear} KKuK KKuK. All rights reserved.
          </div>
        </div>
      </div>
    </footer>
  );
};

export default Footer; 
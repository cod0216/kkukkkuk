import React from 'react';

const Footer: React.FC = () => {
  return (
    <footer className="bg-white dark:bg-gray-800 border-t border-gray-200 dark:border-gray-700 py-4 mt-6">
      <div className="container mx-auto px-4">
        <div className="text-center text-gray-600 dark:text-gray-300 text-sm">
          &copy; {new Date().getFullYear()} KKuk KKuk - 동물병원 진료 시스템. All rights reserved.
        </div>
      </div>
    </footer>
  );
};

export default Footer; 
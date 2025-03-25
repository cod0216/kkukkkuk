import React from 'react';
import { FaPaw } from 'react-icons/fa';


const Header: React.FC = () => {



  return (
    <header className="bg-white border border-gray-100 border-2 py-1">
      <div className="container mx-auto px-3 py-2 flex justify-between items-center">
        
        <div className="flex items-center cursor-pointer">
          <FaPaw className="text-primary-500 text-2xl mr-2" />
          <div className="text-xl font-bold text-primary-500">
            KKUK KKUK
          </div>
        </div>
        
      </div>
    </header>
  );
};

export default Header; 
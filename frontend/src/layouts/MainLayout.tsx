import React from 'react';
import { Outlet } from 'react-router-dom';
import Header from '@/layouts/Header';

const MainLayout: React.FC = () => {
  return (
    <div className="flex flex-col min-h-screen">
      <Header />
      <main className="flex flex-1 justify-around bg-gray-50">
        <Outlet/>
      </main>

    </div>
  );
};

export default MainLayout; 
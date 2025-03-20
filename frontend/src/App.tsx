import { Routes, Route } from 'react-router-dom';
import HospitalRegister from './pages/HospitalRegister';
import Login from './pages/Login';
import Dashboard from './pages/Dashboard';
import NotFound from './pages/NotFound';
import MainLayout from './layouts/MainLayout';
import ProtectedRoute from './components/ProtectedRoute';
import HospitalSettings from './pages/HospitalSettings';
import PetManagement from './pages/PetManagement';

function App() {
  return (
    <Routes>
      <Route element={<MainLayout />}>
        <Route path="/" element={<Login />} />
        <Route path="/login" element={<Login />} />
        <Route path="/register" element={<HospitalRegister />} />
        <Route path="/dashboard" element={
          <ProtectedRoute>
            <Dashboard />
          </ProtectedRoute>
        } />
        <Route path="/pets" element={
          <ProtectedRoute>
            <PetManagement />
          </ProtectedRoute>
        } />
        <Route path="/qr-print" element={
          <ProtectedRoute>
            <div className="container mx-auto p-6">
              <h1 className="text-2xl font-bold mb-6">QR 코드 생성</h1>
              <p>QR 코드 생성 페이지입니다. 구현 중입니다.</p>
            </div>
          </ProtectedRoute>
        } />
        <Route path="/hospital-settings" element={
          <ProtectedRoute>
            <HospitalSettings />
          </ProtectedRoute>
        } />
        <Route path="*" element={<NotFound />} />
      </Route>
    </Routes>
  );
}

export default App;

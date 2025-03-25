import { Routes, Route } from 'react-router-dom';

import MainLayout from '@/layouts/MainLayout';
import TreatmentMain from '@/pages/treatment/TreatmentMain';

function App() {
  return (
    <Routes>
      <Route element={<MainLayout />}>
      <Route path="/" element={<TreatmentMain />} />
      <Route path="/treatment" element={<TreatmentMain />} />
      
      </Route>
    </Routes>
  );
}

export default App;

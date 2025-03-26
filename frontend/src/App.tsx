import { Routes, Route } from "react-router-dom";

import MainLayout from "@/layouts/MainLayout";
import TreatmentMain from "@/pages/treatment/TreatmentMain";
import Login from "@/pages/auth/Login";

function App() {
  return (
    <Routes>
      <Route path="/" element={<Login />} />
      <Route element={<MainLayout />}>
        <Route path="/TreatmentMain" element={<TreatmentMain />} />
        <Route path="/treatment" element={<TreatmentMain />} />
      </Route>
    </Routes>
  );
}

export default App;

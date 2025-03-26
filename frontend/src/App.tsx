import { Routes, Route } from "react-router-dom";

import MainLayout from "@/layouts/MainLayout";
import TreatmentMain from "@/pages/treatment/TreatmentMain";
import Login from "@/pages/auth/Login";
import FindPw from "@/pages/auth/FindPw";
// import AutoLogin from "@/components/AutoLogin";

function App() {
  return (
    // <AutoLogin>
    <Routes>
      <Route path="/" element={<Login />} />
      <Route path="/find-password" element={<FindPw />} />
      <Route element={<MainLayout />}>
        <Route path="/TreatmentMain" element={<TreatmentMain />} />
        <Route path="/treatment" element={<TreatmentMain />} />
      </Route>
    </Routes>
    // </AutoLogin>
  );
}

export default App;

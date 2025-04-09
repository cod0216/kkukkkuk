import React, { useState } from "react";

const Image: React.FC = () => {
  const [file, setFile] = useState<File | null>(null);
  const [message, setMessage] = useState<string>("");

  const handleFileChange = (event: React.ChangeEvent<HTMLInputElement>) => {
    if (event.target.files && event.target.files.length > 0) {
      setFile(event.target.files[0]);
    }
  };

  const handleUpload = async () => {
    if (!file) {
      setMessage("이미지 파일을 선택해주세요.");
      return;
    }

    const formData = new FormData();
    formData.append("domain", "pet"); 
    formData.append("image", file); // 서버에서 @RequestParam("image")로 받음
    const token = "eyJhbGciOiJIUzM4NCJ9.eyJpZCI6MjQsIm5hbWUiOiLqtoztlbTrprwiLCJ0eXBlIjoiT1dORVIiLCJ1dWlkIjoiZmE4OGEyNmYtNjgyYS00NGZmLTkyZDAtMWU1MjkxMmJmN2Q0IiwiaWF0IjoxNzQzNDc2NjkyLCJleHAiOjE3NDM0ODAyOTJ9.i3ahV-FoqUnkGDyMs_RhJ43SfRjKSaFLjIulG19E64juVdRp4L9oawFG4Ez0PIsA"
    
    try {
      const response = await fetch("https://kukkkukk.duckdns.org/api/images/permanent", {
        method: "POST",
        headers: {
          Authorization: `Bearer ${token}`,
        },
        body: formData,
      });

      const result = await response.text();
      setMessage(result);
    } catch (error) {
      console.error("업로드 실패", error);
      setMessage("업로드 실패");
    }
  };

  return (
    <div className="p-4 max-w-md mx-auto bg-white shadow-md rounded-lg">
      <h2 className="text-xl font-bold mb-4">이미지 업로드</h2>
      <input
        type="file"
        accept="image/*"
        onChange={handleFileChange}
        className="mb-2"
      />
      <button
        onClick={handleUpload}
        className="bg-blue-500 text-white px-4 py-2 rounded"
      >
        업로드
      </button>
      {message && <p className="mt-2 text-gray-700">{message}</p>}
    </div>
  );
};

export default Image;

/**
 * @module VaccinationManagement
 * @file VaccinationManagement.tsx
 * @author eunchang
 * @date 2025-04-09
 * @description 백신 접종 항목 관리 컴포넌트입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-09        eunchang         최초 생성
 */
import React, { useState, useEffect, ChangeEvent } from "react";
import {
  Vaccination,
  VaccinationResponse,
  VaccinationListResponse,
} from "@/interfaces"; // 백신 접종 관련 인터페이스
import { ResponseStatus } from "@/types";
import {
  getVaccinations,
  createVaccination,
  updateVaccination,
  deleteVaccination,
} from "@/services/vaccinationSearchService";

const VaccinationManagement: React.FC = () => {
  const [vaccinations, setVaccinations] = useState<Vaccination[]>([]);
  const [newVaccination, setNewVaccination] = useState<string>("");
  const [loading, setLoading] = useState<boolean>(true);
  const [editingId, setEditingId] = useState<number | null>(null);
  const [editingName, setEditingName] = useState<string>("");

  useEffect(() => {
    const fetchVaccinations = async () => {
      const response: VaccinationListResponse = await getVaccinations();
      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setVaccinations(response.data);
      }
      setLoading(false);
    };
    fetchVaccinations();
  }, []);

  const handleAddVaccination = async () => {
    if (!newVaccination.trim()) {
      alert("추가할 백신 접종 항목 이름을 입력해주세요.");
      return;
    }
    try {
      const response: VaccinationResponse = await createVaccination({
        name: newVaccination,
      });
      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setVaccinations([...vaccinations, response.data]);
        setNewVaccination("");
      } else {
        alert(response.message);
      }
    } catch (error) {
      console.error("백신 접종 항목 추가 실패", error);
    }
  };

  const handleDeleteVaccination = async (id: number) => {
    if (!window.confirm("해당 백신 접종 항목을 삭제하겠습니까?")) return;
    try {
      const response = await deleteVaccination(id);
      if (response.status === ResponseStatus.SUCCESS) {
        setVaccinations(vaccinations.filter((item) => item.id !== id));
      } else {
        alert(response.message);
      }
    } catch (error) {
      console.error("백신 접종 항목 삭제 실패", error);
    }
  };

  const startEditing = (id: number, currentName: string) => {
    setEditingId(id);
    setEditingName(currentName);
  };

  const handleUpdateVaccination = async (id: number) => {
    if (!editingName.trim()) {
      alert("수정할 백신 접종 항목 이름을 입력해주세요.");
      return;
    }
    try {
      const response: VaccinationResponse = await updateVaccination(id, {
        name: editingName,
      });
      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setVaccinations(
          vaccinations.map((item) => (item.id === id ? response.data! : item))
        );
        setEditingId(null);
        setEditingName("");
      } else {
        alert(response.message);
      }
    } catch (error) {
      console.error("백신 접종 항목 수정 실패", error);
    }
  };

  const cancelEditing = () => {
    setEditingId(null);
    setEditingName("");
  };

  return (
    <div className="p-4">
      <h2 className="text-2xl font-bold mb-4">백신 접종 항목 관리</h2>
      <div className="mb-6">
        <input
          type="text"
          className="border border-gray-300 rounded p-2 mr-2"
          placeholder="백신 접종 항목 이름 입력"
          value={newVaccination}
          onChange={(e: ChangeEvent<HTMLInputElement>) =>
            setNewVaccination(e.target.value)
          }
          onKeyDown={(e) => {
            if (e.key === "Enter") {
              handleAddVaccination();
            }
          }}
        />
        <button
          className="bg-primary-500 text-white p-2 rounded"
          onClick={handleAddVaccination}
        >
          추가
        </button>
      </div>
      {loading ? (
        <div>백신 접종 항목 로딩 중...</div>
      ) : (
        <div className="max-h-[400px] overflow-y-auto border bg-white">
          {vaccinations.map((item) => (
            <div
              key={item.id}
              className="flex items-center justify-between border-b border-gray-200 p-3"
            >
              {editingId === item.id ? (
                <>
                  <input
                    type="text"
                    className="border border-gray-300 rounded p-1 flex-1 mr-2"
                    value={editingName}
                    onChange={(e: ChangeEvent<HTMLInputElement>) =>
                      setEditingName(e.target.value)
                    }
                  />
                  <button
                    className="bg-green-500 text-white p-1 rounded mr-2"
                    onClick={() => handleUpdateVaccination(item.id)}
                  >
                    저장
                  </button>
                  <button
                    className="bg-gray-500 text-white p-1 rounded"
                    onClick={cancelEditing}
                  >
                    취소
                  </button>
                </>
              ) : (
                <>
                  <span className="flex-1">{item.name}</span>
                  <button
                    className="px-3 py-1 bg-primary-500 text-white text-xs rounded hover:bg-primary-600 focus:outline-none"
                    onClick={() => startEditing(item.id, item.name)}
                  >
                    수정
                  </button>
                  <button
                    className="px-3 py-1 ml-1 bg-secondary-500 text-white text-xs rounded hover:bg-primary-600 focus:outline-none"
                    onClick={() => handleDeleteVaccination(item.id)}
                  >
                    삭제
                  </button>
                </>
              )}
            </div>
          ))}
        </div>
      )}
    </div>
  );
};

export default VaccinationManagement;

import React, { useState } from 'react';

interface WithdrawalModalProps {
  isOpen: boolean;
  onClose: () => void;
  onConfirm: () => void;
  hospitalName: string;
}

const WithdrawalModal: React.FC<WithdrawalModalProps> = ({ isOpen, onClose, onConfirm, hospitalName }) => {
  const [confirmText, setConfirmText] = useState('');
  const [isProcessing, setIsProcessing] = useState(false);
  
  if (!isOpen) return null;
  
  const handleConfirm = () => {
    if (confirmText === hospitalName) {
      setIsProcessing(true);
      onConfirm();
    }
  };
  
  return (
    <div className="fixed inset-0 flex items-center justify-center z-50">
      <div className="fixed inset-0 bg-black opacity-50" onClick={onClose}></div>
      <div className="bg-white dark:bg-gray-800 rounded-lg p-6 w-full max-w-md mx-auto relative z-10">
        <h2 className="text-xl font-bold text-red-600 dark:text-red-400 mb-4">회원 탈퇴 확인</h2>
        
        <div className="mb-6">
          <p className="text-gray-700 dark:text-gray-300 mb-4">
            회원 탈퇴를 진행하시면 모든 병원 데이터와 계정 정보가 삭제되며, 이 작업은 되돌릴 수 없습니다.
          </p>
          <p className="text-gray-700 dark:text-gray-300 mb-4">
            계속 진행하시려면 병원 이름 <span className="font-bold">"{hospitalName}"</span>을 아래에 정확히 입력해주세요.
          </p>
          
          <input
            type="text"
            value={confirmText}
            onChange={(e) => setConfirmText(e.target.value)}
            className="w-full px-4 py-2 border border-gray-300 rounded-md mb-2 focus:outline-none focus:ring-2 focus:ring-red-500 dark:bg-gray-700 dark:border-gray-600 dark:text-white"
            placeholder={`병원 이름을 입력하세요 (${hospitalName})`}
            disabled={isProcessing}
          />
        </div>
        
        <div className="flex justify-end space-x-3">
          <button
            onClick={onClose}
            className="px-4 py-2 bg-gray-200 hover:bg-gray-300 rounded-md text-gray-800 dark:bg-gray-700 dark:hover:bg-gray-600 dark:text-gray-200"
            disabled={isProcessing}
          >
            취소
          </button>
          <button
            onClick={handleConfirm}
            disabled={confirmText !== hospitalName || isProcessing}
            className="px-4 py-2 bg-red-600 hover:bg-red-700 rounded-md text-white disabled:opacity-50 disabled:cursor-not-allowed flex items-center"
          >
            {isProcessing ? (
              <>
                <svg className="animate-spin -ml-1 mr-2 h-4 w-4 text-white" xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24">
                  <circle className="opacity-25" cx="12" cy="12" r="10" stroke="currentColor" strokeWidth="4"></circle>
                  <path className="opacity-75" fill="currentColor" d="M4 12a8 8 0 018-8V0C5.373 0 0 5.373 0 12h4zm2 5.291A7.962 7.962 0 014 12H0c0 3.042 1.135 5.824 3 7.938l3-2.647z"></path>
                </svg>
                처리 중...
              </>
            ) : (
              '회원 탈퇴 확인'
            )}
          </button>
        </div>
      </div>
    </div>
  );
};

export default WithdrawalModal; 

import { useState } from 'react';
import DraggableChatPopup from './DraggableChatPopup';
import ChatPopup from './ChatPopup';
import { getChatRoomWithPartner } from '@/services/chatService';
import { ResponseStatus } from '@/types';

interface ChatEntryButtonProps {
  receiverId: string;
  hospitalName: string;
}

export default function ChatEntryButton({ receiverId, hospitalName }: ChatEntryButtonProps) {
  const [open, setOpen] = useState(false);
  const [chatRoomId, setChatRoomId] = useState<string | null>(null);
  const [loading, setLoading] = useState(false);

  // 채팅방 열기 버튼 클릭 시
  const handleOpenChat = async () => {
    setLoading(true);
    
    try {
      // 채팅방 정보 가져오기 (없으면 자동 생성)
      const response = await getChatRoomWithPartner(receiverId);
      
      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setChatRoomId(response.data.chatRoomId.toString());
        setOpen(true);
      }
    } catch (error) {
      console.error("채팅방을 열 수 없습니다:", error);
    } finally {
      setLoading(false);
    }
  };

  return (
    <>
      <button
        onClick={handleOpenChat}
        disabled={loading}
        className={`text-white text-xs transition px-3 py-1 rounded-xl 
          ${loading 
            ? 'bg-gray-400 cursor-not-allowed' 
            : 'bg-primary-500 hover:bg-primary-700'}`}
      >
        {loading ? '로딩 중...' : '채팅'}
      </button>

      {open && chatRoomId && (
        <DraggableChatPopup onClose={() => setOpen(false)}>
          <ChatPopup
            chatRoomId={chatRoomId}
            receiverId={receiverId}
            partnerName={hospitalName}
            onBack={() => setOpen(false)}
          />
        </DraggableChatPopup>
      )}
    </>
  );
}

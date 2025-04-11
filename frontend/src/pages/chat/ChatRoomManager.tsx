import { useEffect } from 'react';
import { useChatManager } from '@/hooks/useChatManager';
import ChatRoomListPopup from './ChatRoomListPopup';
import DraggableChatPopup from './DraggableChatPopup';
import ChatPopup from './ChatPopup';
import { FiMessageCircle } from 'react-icons/fi';

interface ChatManagerProps {
  autoOpen?: boolean;
  headerRef?: React.RefObject<HTMLDivElement>;
}

export default function ChatManager({ autoOpen = false, headerRef }: ChatManagerProps) {
  const {
    chatState,
    chatRooms,
    loading,
    openRoomList,
    openChat,
    goBackToList,
    closeAll,
  } = useChatManager();

  useEffect(() => {
    if (autoOpen) {
      openRoomList();
    }
  }, [autoOpen]);

  return (
    <>
      {/* 채팅 목록 버튼 */}
      {chatState.type === 'closed' && (
        <button
          onClick={openRoomList}
          className="fixed right-6 bottom-6 bg-primary-500 hover:bg-primary-600 text-white rounded-full p-3 shadow-lg z-40"
        >
          <FiMessageCircle size={24} />
        </button>
      )}

      {/* 채팅방 목록 팝업 */}
      {chatState.type === 'list' && (
        <DraggableChatPopup onClose={closeAll}>
          <ChatRoomListPopup
            onClose={closeAll}
            onOpenChat={openChat}
            chatRooms={chatRooms}
            loading={loading}
            headerRef={headerRef}
          />
        </DraggableChatPopup>

      )}

      {/* 채팅방 내부 팝업 */}
      {chatState.type === 'chat' && (
        <DraggableChatPopup onClose={closeAll}>
          <ChatPopup
            chatRoomId={chatState.chatRoomId.toString()}
            receiverId={chatState.partnerId.toString()}
            partnerName={chatState.partnerName}
            onBack={goBackToList}
            headerRef={headerRef}
          />
        </DraggableChatPopup>
      )}
    </>
  );
}


import { useState } from 'react';
import ChatPopup from '@/pages/chat/ChatPopup';
import DraggableChatPopup from '@/pages/chat/DraggableChatPopup';

interface ChatEntryButtonProps {
  chatRoomId: string;
  receiverId: string;
  hospitalName: string;
}

export default function ChatEntryButton({ chatRoomId, receiverId, hospitalName }: ChatEntryButtonProps) {
  const [open, setOpen] = useState(false);

  return (
    <>
      <button
        onClick={() => setOpen(true)}
        className="bg-primary-500 text-white text-xs transition px-3 py-1 rounded-xl hover:bg-primary-700"
      >
        채팅
      </button>

      {open && (
        <DraggableChatPopup
          hospitalName={hospitalName}
          onClose={() => setOpen(false)}>
          <ChatPopup
            chatRoomId={chatRoomId}
            receiverId={receiverId}
          />
        </DraggableChatPopup>
      )}

    </>
  );
}

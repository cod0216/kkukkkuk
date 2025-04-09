
import { useState } from 'react';
import ChatPopup from '@/pages/chat/ChatPopup';

interface ChatEntryButtonProps {
  chatRoomId: string;
  receiverId: string;
}

export default function ChatEntryButton({ chatRoomId, receiverId }: ChatEntryButtonProps) {
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
        <ChatPopup
          chatRoomId={chatRoomId}
          receiverId={receiverId}
          onClose={() => setOpen(false)}
        />
      )}
    </>
  );
}

import { ChatRoomSummaryResponse } from '@/interfaces/chat'; // 경로는 실제 경로에 맞게 조정해줘

interface ChatRoomListPopupProps {
  onClose: () => void;
  onOpenChat: (chatRoomId: number, partnerId: number) => void;
  chatRooms: ChatRoomSummaryResponse[];
}

export default function ChatRoomListPopup({ onClose, onOpenChat, chatRooms }: ChatRoomListPopupProps) {
  return (
    <div
      style={{ right: 20, bottom: 20, position: 'fixed', zIndex: 50 }}
      className="w-[320px] h-[500px] bg-white border rounded-2xl shadow-2xl flex flex-col overflow-hidden"
    >
      <div className="bg-primary-500 text-white px-4 py-3 flex justify-between items-center">
        <span className="text-base font-semibold">채팅 목록</span>
        <button onClick={onClose} className="hover:opacity-80 text-white text-lg">✕</button>
      </div>

      <div className="flex-1 overflow-y-auto divide-y">
        {chatRooms.map(room => (
          <div
            key={room.chatRoomId}
            onClick={() => onOpenChat(room.chatRoomId, room.partnerId)}
            className="p-4 cursor-pointer hover:bg-gray-100 transition"
          >
            <div className="flex justify-between items-center">
              <span className="font-semibold text-sm truncate">{room.partnerName}</span>
              <span className="text-xs text-gray-400">{formatTime(room.lastMessageAt)}</span>
            </div>
            <p className="text-xs text-gray-600 mt-1 truncate">{room.lastMessage}</p>
            {room.unreadMessageCount > 0 && (
              <div className="mt-1 text-xs bg-red-500 text-white inline-block px-2 py-0.5 rounded-full">
                {room.unreadMessageCount}
              </div>
            )}
          </div>
        ))}
      </div>
    </div>
  );
}

function formatTime(timestamp: string): string {
  const date = new Date(timestamp);
  const now = new Date();
  const isToday = date.toDateString() === now.toDateString();

  if (isToday) {
    return date.toLocaleTimeString('ko-KR', { hour: '2-digit', minute: '2-digit' });
  } else {
    return date.toLocaleDateString('ko-KR', { month: '2-digit', day: '2-digit' });
  }
}

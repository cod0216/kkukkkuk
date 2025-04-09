import { useEffect, useRef, useState } from 'react';
import { ChattingResponse, ChatMessageRequest } from '../../interfaces/chat';
import useStompChat from '@/hooks/useStompChat';
import { getAccessToken, parseJwt } from "@/utils/tokenUtil";
// TODO : 이전 진료 기록 불러오기

interface ChatPopupProps {
  chatRoomId: string;
  receiverId: string;
  onClose: () => void;
}

export default function ChatPopup({ chatRoomId, receiverId, onClose }: ChatPopupProps) {
  const [messages, setMessages] = useState<ChattingResponse[]>([]);
  const [input, setInput] = useState('');
  const scrollRef = useRef<HTMLDivElement>(null);
  
  const accessToken = getAccessToken();
  const payload = parseJwt(accessToken);
  const userId=  payload.id;

  const { sendMessage } = useStompChat(chatRoomId, handleReceive);

  function handleReceive(msg: ChattingResponse) {
    setMessages(prev => [...prev, msg]);
  }

  function handleSend() {
    if (!input.trim()) return;
    const message: ChatMessageRequest = {
      chatRoomId,
      receiverId,
      content: input
    };
    sendMessage(message);
    setInput('');
  }

  useEffect(() => {
    scrollRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  return (
    <div className="fixed bottom-4 h-96 right-4 w-[300px] bg-white border rounded-2xl shadow-xl flex flex-col overflow-hidden">
      <div className="bg-primary-500 text-white px-4 py-2 flex justify-between items-center">
        <span className="text-sm">채팅</span>
        <button onClick={onClose}>✕</button>
      </div>
      <div className="flex-1 p-4 space-y-2 overflow-y-auto max-h-96">
        {messages.map(msg => (
          <div
            key={msg.id}
            className={`px-4 py-2 w-max rounded-xl text-sm max-w-[80%] ${
              msg.senderId == userId ? 'bg-primary-500 text-white text-right ml-auto' : 'text-left bg-gray-200 text-black'
            }`}
          >
            {msg.content}
          </div>
        ))}
        <div ref={scrollRef} />
      </div>
      <div className="flex items-center border-t p-2">
        <input
          value={input}
          onChange={e => setInput(e.target.value)}
          onKeyDown={e => e.key === 'Enter' && handleSend()}
          className="flex-1 border rounded-xl px-4 py-2 text-sm"
          placeholder="메시지를 입력하세요"
        />
        <button onClick={handleSend} className="ml-2 text-primary-600 font-semibold">
          전송
        </button>
      </div>
    </div>
  );
}

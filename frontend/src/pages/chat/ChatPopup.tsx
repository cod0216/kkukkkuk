import { useEffect, useRef, useState } from 'react';
import { ChattingResponse, ChatMessageRequest } from '../../interfaces/chat';
import useStompChat from '@/hooks/useStompChat';
import { getAccessToken, parseJwt } from "@/utils/tokenUtil";
import { getChatHistory } from '@/services/chatService';
import { ApiResponse, ResponseStatus } from "@/types";
import { FiSend } from "react-icons/fi";

interface ChatPopupProps {
  chatRoomId: string;
  receiverId: string;
}

export default function ChatPopup({chatRoomId, receiverId }: ChatPopupProps) {
  const [messages, setMessages] = useState<ChattingResponse[]>([]);
  const [input, setInput] = useState('');
  const scrollRef = useRef<HTMLDivElement>(null);

  const accessToken = getAccessToken();
  const payload = parseJwt(accessToken);
  const userId = payload.id;

  const { sendMessage } = useStompChat(userId, chatRoomId, handleReceive);

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
    const getHistory = async () => {
      const response: ApiResponse<ChattingResponse[]> = await getChatHistory(receiverId);
      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setMessages(response.data);
      }
    }
    getHistory();
  }, [])


  useEffect(() => {
    scrollRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  return (
    <div className="w-[320px] h-[500px] bg-white flex flex-col overflow-hidden">
      <div className="flex-1 px-3 py-4 space-y-3 overflow-y-auto bg-gray-50">
        {messages.map((msg) => (
          <div key={msg.id} className={`flex ${msg.senderId === userId ? 'justify-end' : 'justify-start'}`}>
            <div
              className={`rounded-2xl px-4 py-2 max-w-[75%] shadow-md text-sm relative
            ${msg.senderId === userId
                  ? 'bg-primary-500 text-white rounded-br-none'
                  : 'bg-white text-gray-800 border border-gray-300 rounded-bl-none'}`}
            >
              {/* 이름, 시간*/}
              {msg.senderId !== userId && (
                <div className="text-xs text-gray-500 mb-1">{msg.senderName}</div>
              )}
              <div>{msg.content}</div>
              <div className="text-[10px] text-gray-400 text-right mt-1">
                {new Date(msg.sentAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
              </div>
            </div>
          </div>
        ))}
        <div ref={scrollRef} />
      </div>

      {/* 입력칸 */}
      <div className="flex items-center border-t border-gray-200 px-3 py-2 bg-white">
        <input
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && handleSend()}
          className="h-10 flex-1 border border-gray-300 rounded-xl px-4 py-2 text-sm focus:outline-none focus:border-2 focus:border-primary-500"
          placeholder="메시지를 입력하세요"
        />
        <button
          onClick={handleSend}
          className="h-10 w-10 flex items-center justify-center ml-2 bg-primary-500 rounded-full font-semibold hover:bg-primary-600 transition text-white"
        >
          <FiSend></FiSend>
        </button>
      </div>
    </div>

  );
}

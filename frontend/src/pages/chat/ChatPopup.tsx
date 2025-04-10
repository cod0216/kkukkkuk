import { useEffect, useRef, useState } from 'react';
import { ChattingResponse, ChatMessageRequest } from '@/interfaces/chat';
import useStompChat from '@/hooks/useStompChat';
import { getAccessToken, parseJwt } from "@/utils/tokenUtil";
import { getChatHistory } from '@/services/chatService';
import { ResponseStatus } from "@/types";
import { FiSend, FiArrowLeft } from "react-icons/fi";

interface ChatPopupProps {
  chatRoomId: string;
  receiverId: string;
  partnerName: string;
  onBack: () => void;
  headerRef?: React.RefObject<HTMLDivElement>;
}

export default function ChatPopup({ chatRoomId, receiverId, partnerName, onBack, headerRef }: ChatPopupProps) {
  const [messages, setMessages] = useState<ChattingResponse[]>([]);
  const [input, setInput] = useState('');
  const [loading, setLoading] = useState(true);
  const scrollRef = useRef<HTMLDivElement>(null);
  const inputRef = useRef<HTMLInputElement>(null);

  const accessToken = getAccessToken();
  const payload = parseJwt(accessToken);
  const userId = payload.id;

  // 메시지 수신 처리
  function handleReceive(msg: ChattingResponse) {
    setMessages(prev => [...prev, msg]);
  }

  const { sendMessage } = useStompChat(chatRoomId, handleReceive);

  // 메시지 전송
  function handleSend() {
    if (!input.trim()) return;

    const message: ChatMessageRequest = {
      chatRoomId,
      receiverId,
      content: input.trim()
    };

    sendMessage(message);
    setInput('');

    // 입력창에 포커스
    setTimeout(() => {
      inputRef.current?.focus();
    }, 0);
  }

  // 채팅 내역 가져오기
  useEffect(() => {
    const getHistory = async () => {
      setLoading(true);
      const response = await getChatHistory(receiverId);
      setLoading(false);

      if (response.status === ResponseStatus.SUCCESS && response.data) {
        setMessages(response.data);
      }
    };

    getHistory();
  }, [receiverId]);

  // 메시지 목록 스크롤 자동 이동
  useEffect(() => {
    scrollRef.current?.scrollIntoView({ behavior: 'smooth' });
  }, [messages]);

  // 컴포넌트 마운트 시 입력창에 포커스
  useEffect(() => {
    setTimeout(() => {
      inputRef.current?.focus();
    }, 100);
  }, []);

  return (
    <div className="w-[320px] h-[500px] bg-white flex flex-col overflow-hidden">
      {/* 헤더 */}
      <div
        ref={headerRef}
        className="bg-primary-500 text-white px-4 py-3 flex items-center cursor-pointer"
      >
        <button
          onClick={onBack}
          className="mr-2 hover:opacity-80 cursor-pointer"
        >
          <FiArrowLeft size={18} />
        </button>
        <span className="text-base font-semibold flex-1 truncate">{partnerName}</span>
      </div>



      {/* 메시지 목록 */}
      <div className="flex-1 px-3 py-4 space-y-3 overflow-y-auto bg-gray-50">
        {loading ? (
          <div className="flex justify-center items-center h-full">
            <div className="animate-spin rounded-full h-8 w-8 border-b-2 border-primary-500"></div>
          </div>
        ) : messages.length > 0 ? (
          messages.map((msg) => (
            <div key={msg.id} className={`flex ${msg.senderId === userId ? 'justify-end' : 'justify-start'}`}>
              <div
                className={`rounded-2xl px-4 py-2 max-w-[75%] shadow-md text-sm relative
                ${msg.senderId === userId
                    ? 'bg-primary-500 text-white rounded-br-none'
                    : 'bg-white text-gray-800 border border-gray-300 rounded-bl-none'}`}
              >
                {msg.senderId !== userId && (
                  <div className="text-xs text-gray-500 mb-1">{msg.senderName}</div>
                )}
                <div>{msg.content}</div>
                <div className="text-[10px] text-gray-400 text-right mt-1">
                  {new Date(msg.sentAt).toLocaleTimeString([], { hour: '2-digit', minute: '2-digit' })}
                </div>
              </div>
            </div>
          ))
        ) : (
          <div className="flex flex-col items-center justify-center h-full text-gray-500">
            <p className="text-sm">새로운 대화를 시작해보세요!</p>
          </div>
        )}
        <div ref={scrollRef} />
      </div>

      {/* 입력칸 */}
      <div className="flex items-center border-t border-gray-200 px-3 py-2 bg-white">
        <input
          ref={inputRef}
          value={input}
          onChange={(e) => setInput(e.target.value)}
          onKeyDown={(e) => e.key === 'Enter' && !e.shiftKey && handleSend()}
          className="h-10 flex-1 border border-gray-300 rounded-xl px-4 py-2 text-sm focus:outline-none focus:border-2 focus:border-primary-500"
          placeholder="메시지를 입력하세요"
        />
        <button
          onClick={handleSend}
          disabled={!input.trim()}
          className={`h-10 w-10 flex items-center justify-center ml-2 rounded-full font-semibold transition text-white
            ${input.trim() ? 'bg-primary-500 hover:bg-primary-600' : 'bg-gray-300 cursor-not-allowed'}`}
        >
          <FiSend />
        </button>
      </div>
    </div>
  );
}

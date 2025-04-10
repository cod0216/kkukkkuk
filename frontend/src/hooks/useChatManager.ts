import { useState, useEffect } from 'react';
import { ChatRoomSummaryResponse } from '@/interfaces/chat';
import { getChatRooms } from '@/services/chatService';
import { ResponseStatus } from '@/types';

type ChatState =
  | { type: 'closed' }
  | { type: 'list' }
  | { type: 'chat'; chatRoomId: number; partnerId: number; partnerName: string };

export function useChatManager() {
  const [chatState, setChatState] = useState<ChatState>({ type: 'closed' });
  const [chatRooms, setChatRooms] = useState<ChatRoomSummaryResponse[]>([]);
  const [loading, setLoading] = useState(false);

  // 채팅방 목록 가져오기
  const fetchChatRooms = async () => {
    setLoading(true);
    const response = await getChatRooms();
    setLoading(false);
    
    if (response.status === ResponseStatus.SUCCESS && response.data) {
      setChatRooms(response.data);
    }
  };

  // 채팅방 목록 열기
  const openRoomList = async () => {
    setChatState({ type: 'list' });
    await fetchChatRooms();
  };

  // 특정 채팅방 열기
  const openChat = (chatRoomId: number, partnerId: number, partnerName: string) => {
    setChatState({ type: 'chat', chatRoomId, partnerId, partnerName });
  };

  // 채팅방 목록으로 돌아가기
  const goBackToList = async () => {
    setChatState({ type: 'list' });
    await fetchChatRooms(); // 목록으로 돌아갈 때 최신 정보 갱신
  };

  // 모든 채팅 UI 닫기
  const closeAll = () => {
    setChatState({ type: 'closed' });
  };

  // 컴포넌트 마운트 시 채팅방 목록 가져오기
  useEffect(() => {
    if (chatState.type === 'list') {
      fetchChatRooms();
    }
  }, []);

  return {
    chatState,
    chatRooms,
    loading,
    openRoomList,
    openChat,
    goBackToList,
    closeAll,
    refreshRooms: fetchChatRooms
  };
}

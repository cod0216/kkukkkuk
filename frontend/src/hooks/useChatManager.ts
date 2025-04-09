import { useState } from 'react';

type ChatState =
  | { type: 'closed' }
  | { type: 'list' }
  | { type: 'chat'; chatRoomId: number; partnerId: number };

export function useChatManager() {
  const [chatState, setChatState] = useState<ChatState>({ type: 'closed' });

  const openRoomList = () => setChatState({ type: 'list' });

  const openChat = (chatRoomId: number, partnerId: number) =>
    setChatState({ type: 'chat', chatRoomId, partnerId });

  const goBackToList = () => setChatState({ type: 'list' });

  const closeAll = () => setChatState({ type: 'closed' });

  return {
    chatState,
    openRoomList,
    openChat,
    goBackToList,
    closeAll,
  };
}

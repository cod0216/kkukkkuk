import { useEffect, useRef } from 'react';
import { Client, IMessage } from '@stomp/stompjs';
import { ChattingResponse, ChatMessageRequest } from '../interfaces/chat';
import { getRefreshToken } from '../utils/iDBUtil';

const useStompChat = (receiverId: string, onMessage: (msg: ChattingResponse) => void) => {
  const client = useRef<Client | null>(null);
  const BASE_URL = import.meta.env.SOCKET_WS_URL;

  useEffect(() => {
    const connect = async () => {
      const token = await getRefreshToken(); 
  
      client.current = new Client({
        brokerURL: BASE_URL,
        connectHeaders: {
          Authorization: `Bearer ${token}`,
        },
        debug: (str) => {
          console.log('[STOMP DEBUG]', str);
        },
        reconnectDelay: 5000,
        onConnect: () => {
          // console.log('[STOMP] ✅ Connected');
          client.current?.subscribe(`/topic/chat/${receiverId}`, (message: IMessage) => {
            try {
              const body: ChattingResponse = JSON.parse(message.body);
              // console.log('[📩 Chat Received]', body); // ✅ 로그 찍기
              onMessage(body); // ✅ 채팅 추가 콜백 실행
            } catch (error) {
              console.error('[STOMP] ❌ Failed to parse message:', error);
            }
          });
        },
        // onStompError: (frame) => {
          // console.error('[STOMP] ❌ STOMP error:', frame);
        // },
      });
  
      client.current.activate();
    };
  
    connect(); 
  
    return () => {
      client.current?.deactivate();
    };
  }, [receiverId]);
  
  const sendMessage = async (msg: ChatMessageRequest) => {
    const token = await getRefreshToken(); 
    if (client.current?.connected) {
      client.current.publish({
        destination: `/app/chat/${msg.receiverId}/send`,
        headers: {
          Authorization: `Bearer ${token}`,
        },
        body: JSON.stringify(msg),
      });
    }
  };

  return { sendMessage };
};

export default useStompChat;

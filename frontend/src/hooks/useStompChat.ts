import { useEffect, useRef } from 'react';
import { Client, IMessage } from '@stomp/stompjs';
import { ChattingResponse, ChatMessageRequest } from '../interfaces/chat';
import { getAccessToken } from '@/utils/tokenUtil'; 

const useStompChat = (myId : string, receiverId: string | undefined, onMessage: (msg: ChattingResponse) => void) => {
  const client = useRef<Client | null>(null);
  const VITE_SOCKET_WS_URL = import.meta.env.VITE_SOCKET_WS_URL;

  useEffect(() => {
    const connect = async () => {
      const token = getAccessToken(); 
  
      client.current = new Client({
        brokerURL: `${VITE_SOCKET_WS_URL}/kkukkkuk`,
        connectHeaders: {
          Authorization: `Bearer ${token}`
        },
        debug: (str) => {
          console.log('[STOMP DEBUG]', str);
        },
        reconnectDelay: 5000,
        onConnect: () => {
          client.current?.subscribe(`/topic/chats/${receiverId}`, (message: IMessage) => {
            try {
              const body: ChattingResponse = JSON.parse(message.body);
              onMessage(body);
            } catch (error) {

            }
          });

          client.current?.subscribe(`/topic/chats/${myId}`, (message: IMessage) => {
            try {
              const body: ChattingResponse = JSON.parse(message.body);
              onMessage(body);
            } catch (error) {

            }
          });
        },
      });
  
      client.current.activate();
    };
  
    connect(); 
  
    return () => {
      client.current?.deactivate();
    };
  }, [receiverId]);
  
  const sendMessage = async (msg: ChatMessageRequest) => {
    const token = getAccessToken(); 
    if (client.current?.connected) {
      client.current.publish({
        destination: `/app/chats/${msg.receiverId}/send`,
        headers: {
          Authorization: `Bearer ${token}`,
          "Content-Type": "application/json",
        },
        body: JSON.stringify(msg),
      });
    }
  };

  return { sendMessage };
};

export default useStompChat;

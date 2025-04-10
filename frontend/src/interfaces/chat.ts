
export interface ChattingResponse {
  id: number;
  content: string;
  chatRoomId: number;
  senderId: number;
  senderName: string;
  sentAt: string; 
  flagRead: boolean;
  readAt: string | null;
  flagSentByMe: boolean;
}

export interface ChatMessageRequest {
  content: string;
  chatRoomId: string | undefined;
  receiverId: string | undefined;
}

export interface ChatRoomSummaryResponse {
  chatRoomId: number;
  partnerName: string;
  partnerId: number;
  lastMessage: string;
  lastMessageAt: string;
  unreadMessageCount: number;
}

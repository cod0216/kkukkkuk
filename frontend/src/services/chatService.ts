import { ChatRoomSummaryResponse, ChattingResponse } from "@/interfaces";
import { request } from "@/services/apiRequest";
import { ApiResponse } from "@/types";

/**
 * @module chatService
 * @file chatService.ts
 * @author haelim
 * @date 2025-04-06
 * @description Chat 요청을 처리하는 서비스 모듈입니다.
 *
 * ===========================================================
 * DATE              AUTHOR             NOTE
 * -----------------------------------------------------------
 * 2025-04-06        haelim           최초 생성
 */



export const getChatRooms = async (): Promise<ApiResponse<ChatRoomSummaryResponse[]>> => {
   return await request.get<ChatRoomSummaryResponse[]>(`/api/chats/rooms`);
};


export const getChatHistory = async (hospitalId:string | undefined): Promise<ApiResponse<ChattingResponse[]>> => {
   return await request.get<ChattingResponse[]>(`/api/chats/history/${hospitalId}`);
};

export const getChatRoomWithPartner = async (partnerId: string): Promise<ApiResponse<ChatRoomSummaryResponse>> => {
   return await request.post<ChatRoomSummaryResponse>(`/api/chats/rooms/${partnerId}`);
 };
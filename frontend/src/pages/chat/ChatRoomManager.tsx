// import { useState } from 'react';
// import ChatRoomListPopup from '@/pages/chat/ChatRoomListPopup';
// import { ChatRoomSummaryResponse } from '@/interfaces/chat';

// const chatRoomData: ChatRoomSummaryResponse[] = [

// ];

// export default function ChatRoomManager() {
//   const [roomPopupOpen, setRoomPopupOpen] = useState(true);
//   const [activeRoom, setActiveRoom] = useState<{ roomId: number; partnerId: number } | null>(null);

//   return (
//     <>
//       {roomPopupOpen && (
//         <ChatRoomListPopup
//           onClose={() => setRoomPopupOpen(false)}
//           chatRooms={chatRoomData}
//           onOpenChat={(roomId, partnerId) => {
//             setActiveRoom({ roomId, partnerId });
//             setRoomPopupOpen(false);
//           }}
//         />
//       )}

//       {/* {activeRoom && (
//         <DraggableChatPopup hospitalName="목록" onClose={() => setActiveRoom(null)}>
//           <ChatPopup onBack={() => {}} chatRoomId={activeRoom.roomId.toString()} receiverId={activeRoom.partnerId.toString()} />
//         </DraggableChatPopup>
//       )} */}
//     </>
//   );
// }

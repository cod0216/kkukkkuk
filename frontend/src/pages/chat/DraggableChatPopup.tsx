import React, { useEffect, useRef, useState } from 'react';

interface DraggableChatPopupProps {
  onClose: () => void;
  children: React.ReactNode;
  hospitalName : string | undefined;
}

export default function DraggableChatPopup({ onClose, children, hospitalName }: DraggableChatPopupProps) {
  const popupRef = useRef<HTMLDivElement>(null);
  const isDragging = useRef(false);
  const offset = useRef({ x: 0, y: 0 });
  const [position, setPosition] = useState(() => ({
    x: typeof window !== 'undefined' ? window.innerWidth - 340 : 100, 
    y: typeof window !== 'undefined' ? window.innerHeight - 540 : 100,
  }));

  useEffect(() => {
    const handleMouseMove = (e: MouseEvent) => {
      if (!isDragging.current) return;
      setPosition({
        x: e.clientX - offset.current.x,
        y: e.clientY - offset.current.y,
      });
    };

    const handleMouseUp = () => {
      isDragging.current = false;
    };

    window.addEventListener('mousemove', handleMouseMove);
    window.addEventListener('mouseup', handleMouseUp);

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
      window.removeEventListener('mouseup', handleMouseUp);
    };
  }, []);

  const handleMouseDown = (e: React.MouseEvent) => {
    const rect = popupRef.current?.getBoundingClientRect();
    if (!rect) return;
    isDragging.current = true;
    offset.current = {
      x: e.clientX - rect.left,
      y: e.clientY - rect.top,
    };
  };

  return (
    <div
      ref={popupRef}
      style={{ left: position.x, top: position.y, position: 'fixed', zIndex: 50 }}
      className="w-[320px] h-[500px] bg-white border rounded-2xl shadow-2xl flex flex-col overflow-hidden cursor-pointer"
    >
       
      <div
        onMouseDown={handleMouseDown}
        className="bg-primary-500 text-white px-4 py-3 flex justify-between items-center select-none"
      >
        <span className="text-base font-semibold">{hospitalName}</span>
        <button onClick={() => onClose()} className="hover:opacity-80 text-white text-lg">✕</button>
      </div>
      {children}
    </div>
  );
}

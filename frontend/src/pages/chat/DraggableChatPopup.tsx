import { useRef, useState, useEffect, ReactNode } from 'react';
import { CSSProperties } from 'react';

interface DraggableChatPopupProps {
  children: ReactNode;
  onClose: () => void;
  initialPosition?: { x: number; y: number };
  zIndex?: number;
}

export default function DraggableChatPopup({
  children,
  initialPosition = { x: window.innerWidth - 340, y: window.innerHeight - 540 },
  zIndex = 50
}: DraggableChatPopupProps) {
  const [position, setPosition] = useState(initialPosition);
  const [isDragging, setIsDragging] = useState(false);
  const [dragOffset, setDragOffset] = useState({ x: 0, y: 0 });
  const popupRef = useRef<HTMLDivElement>(null);
  const headerRef = useRef<HTMLDivElement>(null);

  useEffect(() => {
    const headerElement = headerRef.current;
    if (!headerElement) return;

    const handleMouseDownHeader = (e: MouseEvent) => {
      if (!popupRef.current) return;

      const rect = popupRef.current.getBoundingClientRect();
      setDragOffset({
        x: e.clientX - rect.left,
        y: e.clientY - rect.top
      });
      setIsDragging(true);
      e.preventDefault();
    };

    headerElement.addEventListener('mousedown', handleMouseDownHeader);
    return () => {
      headerElement.removeEventListener('mousedown', handleMouseDownHeader);
    };
  }, []);

  // 팝업 드래그 중
  useEffect(() => {
    if (!isDragging) return;

    const handleMouseMove = (e: MouseEvent) => {
      if (!isDragging) return;

      // 화면 경계 내에서만 이동
      const maxX = window.innerWidth - (popupRef.current?.offsetWidth || 320);
      const maxY = window.innerHeight - (popupRef.current?.offsetHeight || 500);

      setPosition({
        x: Math.max(0, Math.min(maxX, e.clientX - dragOffset.x)),
        y: Math.max(0, Math.min(maxY, e.clientY - dragOffset.y))
      });
    };

    // 팝업 드래그 종료
    const handleMouseUp = () => {
      setIsDragging(false);
    };

    window.addEventListener('mousemove', handleMouseMove);
    window.addEventListener('mouseup', handleMouseUp);

    return () => {
      window.removeEventListener('mousemove', handleMouseMove);
      window.removeEventListener('mouseup', handleMouseUp);
    };
  }, [isDragging, dragOffset]);

  // 창 크기 변경 시 위치 조정
  useEffect(() => {
    const handleResize = () => {
      setPosition(prev => {
        const maxX = window.innerWidth - (popupRef.current?.offsetWidth || 320);
        const maxY = window.innerHeight - (popupRef.current?.offsetHeight || 500);

        return {
          x: Math.max(0, Math.min(maxX, prev.x)),
          y: Math.max(0, Math.min(maxY, prev.y))
        };
      });
    };

    window.addEventListener('resize', handleResize);
    return () => window.removeEventListener('resize', handleResize);
  }, []);

  const style: CSSProperties = {
    position: 'fixed',
    left: `${position.x}px`,
    top: `${position.y}px`,
    zIndex,
    borderRadius: '12px',
    boxShadow: '0 10px 25px -5px rgba(0, 0, 0, 0.3)',
    overflow: 'hidden',
    cursor: isDragging ? 'grabbing' : 'auto'
  };

  return (
    <div ref={popupRef} style={style} className="bg-white">
      {children}


    </div>
  );
}
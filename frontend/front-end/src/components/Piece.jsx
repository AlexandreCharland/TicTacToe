// Piece.js
import React from 'react';
import { useDrag } from 'react-dnd';

const Piece = ({isDragging, type, size }) => {
  const [{ opacity }, dragRef] = useDrag (
    () => ({
      type: type,
      item: { type },
      collect: (monitor) => ({
        opacity: monitor.isDragging() ? 0.5 : 1
      })
    }),
    []
  )

  return (
    <div ref={dragRef} style={{ opacity }}>
      {type}
    </div>
  )
}

export default Piece;
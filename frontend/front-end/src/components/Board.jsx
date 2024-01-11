// Board.js
import React from 'react';
import { useDrop } from 'react-dnd';
import Piece from './Piece';
import '../styles/App.css'

function Board({ xIsNext, squares, onPlay }) {
  // ... existing code

  function handleClick(i) {
    if (calculateWinner(squares) || squares[i]) {
      return;
    }
    const nextSquares = squares.slice();
    if (xIsNext) {
      nextSquares[i] = 'X';
    } else {
      nextSquares[i] = 'O';
    }
    onPlay(nextSquares);
  }

  const winner = calculateWinner(squares);
  let status;
  if (winner) {
    status = 'Winner: ' + winner;
  } else {
    status = 'Next player: ' + (xIsNext ? 'X' : 'O');
  }

  const [{ isOver: isOverX }, dropX] = useDrop({
    accept: 'PIECE',
    drop: (item) => {
      // Handle the drop event for X here
      console.log('Dropped X:', item.content);
      // Add your logic for updating the board or performing other actions
    },
    collect: (monitor) => ({
      isOver: !!monitor.isOver(),
    }),
  });

  const [{ isOver: isOverO }, dropO] = useDrop({
    accept: 'PIECE',
    drop: (item) => {
      // Handle the drop event for O here
      console.log('Dropped O:', item.content);
      // Add your logic for updating the board or performing other actions
    },
    collect: (monitor) => ({
      isOver: !!monitor.isOver(),
    }),
  });

  return (
    <>
      <div className="status">{status}</div>
      <div className='deck' ref={dropX}>
        <Piece type={"x"} size={2} />
        <Piece type={"x"} size={2} />
        <Piece type={"x"} size={1} />
        <Piece type={"x"} size={1} />
        <Piece type={"x"} size={0} />
        <Piece type={"x"} size={0} />
      </div>
      {/* ... existing code */}
      <div className='deck' ref={dropO}>
        <Piece type={"o"} size={2} />
        <Piece type={"o"} size={2} />
        <Piece type={"o"} size={1} />
        <Piece type={"o"} size={1} />
        <Piece type={"o"} size={0} />
        <Piece type={"o"} size={0} />
      </div>
    </>
  );
}

function calculateWinner(squares) {
    const lines = [
      [0, 1, 2],
      [3, 4, 5],
      [6, 7, 8],
      [0, 3, 6],
      [1, 4, 7],
      [2, 5, 8],
      [0, 4, 8],
      [2, 4, 6],
    ];
    for (let i = 0; i < lines.length; i++) {
      const [a, b, c] = lines[i];
      if (squares[a] && squares[a] === squares[b] && squares[a] === squares[c]) {
        return squares[a];
      }
    }
    return null;
  }

export default Board;

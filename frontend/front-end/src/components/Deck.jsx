import * as React from 'react';
import Piece from './Piece';

export default function Deck({ type }) {
    let pieces;

    if (type.toLowerCase() === "x") {
        pieces = [
            { type: "x", size: 0 },
            { type: "x", size: 0 },
            { type: "x", size: 1 },
            { type: "x", size: 1 },
            { type: "x", size: 2 },
            { type: "x", size: 2 },
        ];
    } else {
        pieces = [
            { type: "o", size: 0 },
            { type: "o", size: 0 },
            { type: "o", size: 1 },
            { type: "o", size: 1 },
            { type: "o", size: 2 },
            { type: "o", size: 2 },
        ];
    }

    // Sort the pieces by size
    pieces.sort((a, b) => a.size - b.size);

    // Group the pieces by size
    const groupedPieces = pieces.reduce((acc, piece) => {
        const size = piece.size;
        acc[size] = [...(acc[size] || []), piece];
        return acc;
    }, {});

    const converter = (size) => {
        switch (size) {
            case 0:
                return "small"
            case 1:
                return "medium"
            case 2:
                return "large"
            default:
                break;
        }
    }

    return (
        <div>
            {Object.keys(groupedPieces).map((size) => (
                <div key={size}>
                    {groupedPieces[size].map((piece, index) => (
                        <Piece
                            key={index}
                            type={piece.type}
                            size={piece.size}
                            // Add className based on size for styling
                            className={`square.${piece.type.toLowerCase()}.${converter(piece.size)}`}
                        />
                    ))}
                </div>
            ))}
        </div>
    );
}

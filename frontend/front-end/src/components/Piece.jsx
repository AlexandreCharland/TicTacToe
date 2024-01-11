import * as React from 'react'
import '../styles/Deck.css'

export default function Piece({ type, className }) {
    
    if (type.toLowerCase() === "x"){
        return (
            <div className= {className} />
        )
    } else {
        return (
            <div className={className} />
        )
    }
}
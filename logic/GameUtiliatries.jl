using StaticArrays
# Numerical notation equivalence in alphabetical notation 0 = S, 1 = s, 2 = M, 3 = m, 4 = L, 5 = l

# JAN  a b c d e f g h i#/
# # = 0 if it is player 0's move and # = 1 if it is player 1's move
#  a | b | c
# ---+---+---
#  d | e | f
# ---+---+---
#  g | h | i
# Whatever is in the spot a gets recorded behind a in numerical notation.
# Nothing mean there isn't anything in the box.
# After the / is the not yet played piece in order of numerical notation
# This is the JAN of the starting position : "abcdefghi0/001122334455"

# A move will be denoted as the following #ab
# # is the piece in play using the numerical notation
# a is where that piece come from. If the piece come from outside of the board use " ".
# If the piece is already place and we want to move it, then use the current position of the piece.
# b is the box where the piece ends up

#This function take a JAN and return the state of the board of the JAN in alphabetical notation.
function ShowPosition(JAN)
    translation = Dict("" => " ", '0' => "S", '1' => "s", '2' => "M", '3' => "m", '4' => "L", '5' => "l")
    letter = 97
    line = " "
    stuff = ""
    for i in 1:(findfirst('i', JAN)-1)
        if (Char(letter) != JAN[i])
            stuff = JAN[i]
        else
            line = string(line, translation[stuff])
            if (letter % 3 == 0) #only activate for c and f
                println(line)
                println("---+---+---")
                line = " "
            else
                line = string(line, " | ")
            end
            stuff = ""
            letter += 1
        end
    end
    line = string(line, translation[stuff], "\n")
    println(line)
end

#This function take a JAN and return the JAN of the new position.
#It assume that the move is always possible
function MakeMove(JAN::String, move::String)
    if (move[2] == ' ')
        removeIndex::Int16 = findlast(move[1], JAN)
    else
        removeIndex = findfirst(move[2], JAN)-1
    end
    newJAN::String = string(JAN[1:removeIndex-1], JAN[removeIndex+1:end])
    addedIndex::Int16 = findfirst(move[3], newJAN)
    newJAN = string(newJAN[1:addedIndex-1], move[1], newJAN[addedIndex:end])
    playerTurn::Int16 = findlast('/', newJAN)
    newJAN = string(newJAN[1:playerTurn-2], Char(97-Int(newJAN[playerTurn-1])), newJAN[playerTurn:end])
    return newJAN
end

#This function take 3 non empty square and return True if every element in those square are of the same
#parity
function VerifyWin(a, b, c)
    return (Int(a[end-1])%2+Int(b[end-1])%2+Int(c[end-1])%2)%3 == 0
end

#This function take a JAN and return a string the the leading element in each square
function WhatInTheBox(JAN)
    myString = MVector{9,Char}(' ',' ',' ',' ',' ',' ',' ',' ',' ')
    elem = " "
    j = 1
    letter = 97
    for i in 1:(findfirst('i', JAN))
        if (Char(letter) == JAN[i])
            myString[j] = elem
            elem = ' '
            letter += 1
            j += 1
        else
            elem = JAN[i]
        end
    end
    return myString
end

function SomeoneWon(JAN)
    board = WhatInTheBox(JAN)
    #Essait tous
end

#ShowPosition("05a34bc2d14e3f1g5h02i1/")
#newPos = MakeMove("05a34bc2d14e3f1g5h02i1/", "5hg")
#ShowPosition(newPos)
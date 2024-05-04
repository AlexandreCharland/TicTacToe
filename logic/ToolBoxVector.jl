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
# This is the JAN of the starting position :
#MVector{23,Char}('a','b','c','d','e','f','g','h','i','0','/','0','0','1','1','2','2','3','3','4','4','5','5')

# A move will be denoted as the following #ab
# # is the piece in play using the numerical notation
# a is where that piece come from. If the piece come from outside of the board use " ".
# If the piece is already place and we want to move it, then use the current position of the piece.
# b is the box where the piece ends up

#This project uses MVector instead of String to represent the moves and the JAN. Since every JAN is the
#same size, fixing the memory space will dramaticly improve the performace. To transform a MVector
#into a String use prod(MVector)

#This function take a JAN and return the state of the board of the JAN in alphabetical notation.
function ShowPosition(JAN) #No need to optimise
    translation = Dict("" => " ", '0' => "S", '1' => "s", '2' => "M", '3' => "m", '4' => "L", '5' => "l")
    letter = 97
    line = " "
    stuff = ""
    for i in 1:(findfirst(JAN.=='i')-1)
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
function MakeMove(JAN::MVector, move::MVector)
    changeTurn = Dict('0' => '1', '1' => '0')
    to::Int8 = findfirst(JAN.==move[3])
    playerTurn::Int8 = findlast(JAN.=='/')-1
    newJAN::MVector = copy(JAN)
    if (move[2] == ' ') #to turn from
        from::Int8 = findlast(JAN.==move[1])
        newJAN[to] = move[1]
        for i in (to+1):from
            newJAN[i] = JAN[i-1]
        end
        newJAN[playerTurn+1] = changeTurn[JAN[playerTurn]]
    else
        from = findfirst(JAN.==move[2])-1
        if (from < to) #from to turn
            for i in from:(to-1)
                newJAN[i] = JAN[i+1]
            end
            newJAN[to-1] = move[1]
            newJAN[playerTurn] = changeTurn[JAN[playerTurn]]
        else #to from turn
            newJAN[to] = move[1]
            for i  in (to+1):from
                newJAN[i] = JAN[i-1]
            end
            newJAN[from] = move[3]
            newJAN[playerTurn] = changeTurn[JAN[playerTurn]]
        end
    end
    return newJAN
end

#This function take 3 non empty square and return True if every element in those square are of the same
#parity
function VerifyWin(a::Char, b::Char, c::Char)
    conversion = Dict('0' => 0, '1' => 2, '2' => 0, '3' => 2, '4' => 0, '5' => 2, ' ' => 1)
    return (conversion[a]+conversion[b]+conversion[c])%6 == 0
end

#This function take a JAN and return a string the the leading element in each square
function WhatInTheBox(JAN::MVector)
    myString = MVector{9,Char}(' ',' ',' ',' ',' ',' ',' ',' ',' ')
    elem::Char = ' '
    j::Int8 = 1
    letter::Int8 = 97
    for i in 1:(findfirst('i', prod(JAN)))
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

#This fonction takes a JAN and return true if a player has won and false if no player has won
function SomeoneWon(JAN::MVector)
    board::MVector = WhatInTheBox(JAN)
    return (VerifyWin(board[1], board[2], board[3]) || 
            VerifyWin(board[1], board[4], board[7]) ||
            VerifyWin(board[1], board[5], board[9]) ||
            VerifyWin(board[2], board[5], board[8]) ||
            VerifyWin(board[3], board[5], board[7]) ||
            VerifyWin(board[3], board[6], board[9]) ||
            VerifyWin(board[4], board[5], board[6]) ||
            VerifyWin(board[7], board[8], board[9]))
end

#This function takes a JAN and a square where a modification happen. It checks if the change square 
#modifie the state of the game
function SomethingHasChange(JAN::MVector, square::Char)
    val::Int8 = Int(square)-96
    board::MVector = WhatInTheBox(JAN)
    if (val%2 == 0)
        return (VerifyWin(board[7-(val%4)*2], board[val], board[5-4*(-1)^(val÷5)]) ||
                VerifyWin(board[val], board[5], board[10-val]))
    elseif (val == 5)
        return (VerifyWin(board[1], board[5], board[9]) ||
                VerifyWin(board[2], board[5], board[8]) ||
                VerifyWin(board[3], board[5], board[7]) ||
                VerifyWin(board[4], board[5], board[6]))
    else
        var::Int8 = (-1)^(val÷5)
        return (VerifyWin(board[val], board[5-3*var], board[val+4*(val%3)-2]) ||
                VerifyWin(board[val], board[(val%6)+3], board[val+6*var]) ||
                VerifyWin(board[val], board[5], board[10-val]))
    end
end

a=MVector{23,Char}('a','b','c','d','e','f','g','h','i','0','/','0','0','1','1','2','2','3','3','4','4','5','5')
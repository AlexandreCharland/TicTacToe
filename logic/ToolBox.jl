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
# MVector{23,Char}('a','b','c','d','e','f','g','h','i','0','/','0','0','1','1','2','2','3','3','4','4','5','5')

# A move will be denoted as the following #ab
# # is the piece in play using the numerical notation
# a is where that piece come from. If the piece come from outside of the board use " ".
# If the piece is already place and we want to move it, then use the current position of the piece.
# b is the box where the piece ends up

# A piece is consider pin if moving it reveal a tictactoe. Note moving the piece and then blocking the
# tictactoe still count as a win for the oponent

# This project uses MVector instead of String to represent the moves and the JAN. Since every JAN is the
# same size, fixing the memory space will dramaticly improve the performace. To transform a MVector
# into a String use prod(MVector)

# This function take a JAN and return the state of the board of the JAN in alphabetical notation.
function ShowPosition(JAN) # No need to optimise
    translation = Dict("" => " ", '0' => "S", '1' => "s", '2' => "M", '3' => "m", '4' => "L", '5' => "l")
    letter = 97
    line = " "
    stuff = ""
    for i in 1:(findfirst(JAN.=='i')-1)
        if (Char(letter) != JAN[i])
            stuff = JAN[i]
        else
            line = string(line, translation[stuff])
            if (letter % 3 == 0) # only activate for c and f
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

# This function take a JAN and return the JAN of the new position.
# It assume that the move is always possible
function MakeMove(JAN::MVector, move::MVector)
    changeTurn = Dict('0' => '1', '1' => '0')
    to::Int8 = findfirst(JAN.==move[3])
    playerTurn::Int8 = findlast(JAN.=='/')-1
    newJAN::MVector = copy(JAN)
    if (move[2] == ' ') # to turn from
        from::Int8 = findlast(JAN.==move[1])
        newJAN[to] = move[1]
        for i in (to+1):from
            newJAN[i] = JAN[i-1]
        end
        newJAN[playerTurn+1] = changeTurn[JAN[playerTurn]]
    else
        from = findfirst(JAN.==move[2])-1
        if (from < to) # from to turn
            for i in from:(to-1)
                newJAN[i] = JAN[i+1]
            end
            newJAN[to-1] = move[1]
            newJAN[playerTurn] = changeTurn[JAN[playerTurn]]
        else # to from turn
            newJAN[to] = move[1]
            for i  in (to+1):from
                newJAN[i] = JAN[i-1]
            end
            newJAN[playerTurn] = changeTurn[JAN[playerTurn]]
        end
    end
    return newJAN
end

# This function takes a JAN, board and a move. It will output the new state of the board.
function ChangeBoard(JAN::MVector, board::MVector, move::MVector)
    newBoard = copy(board)
    if (move[2] != ' ')
        index::Int8 = findfirst(JAN.==move[2])-1
        if (index == 1)
            newBoard[1] = ' '
        else
            index2::Int8 = Int(move[2])-96
            if (JAN[index-1] < JAN[index])
                newBoard[index2] = JAN[index-1]
            else
                newBoard[index2] = ' '
            end
        end
    end
    newBoard[Int(move[3])-96] = move[1]
    return newBoard
end

# This function take 3 non empty square and return True if every element in those square are of the same
# parity
function VerifyWin(a::Char, b::Char, c::Char)
    conversion = Dict('0' => 0, '1' => 2, '2' => 0, '3' => 2, '4' => 0, '5' => 2, ' ' => 1)
    return (conversion[a]+conversion[b]+conversion[c])%6 == 0
end

# This function take a JAN and return a string the the leading element in each square
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

# This fonction takes a board and return true if a player has won and false if no player has won
function SomeoneWon(board::MVector)
    return (VerifyWin(board[1], board[2], board[3]) || 
            VerifyWin(board[1], board[4], board[7]) ||
            VerifyWin(board[1], board[5], board[9]) ||
            VerifyWin(board[2], board[5], board[8]) ||
            VerifyWin(board[3], board[5], board[7]) ||
            VerifyWin(board[3], board[6], board[9]) ||
            VerifyWin(board[4], board[5], board[6]) ||
            VerifyWin(board[7], board[8], board[9]))
end

# This function takes a board and a square where a modification happen. It checks if the change square 
# modifie the state of the game
function SomethingHasChange(board::MVector, square::Char)
    val::Int8 = Int(square)-96
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

# This function take a JAN, an index of were the board start and finish, who's turn is it and the
# location of the piece. It will return a modifie location to also contain the location of the piece on
# the deck.
function WhoIsOnTheBench(JAN::MVector, slashIndex::Int8, turn::Int8, location::MVector)
    for i in (slashIndex+1):23
        piece::Int8 = Int(JAN[i])
        if (piece % 2 == turn)
            piece = piece - turn - 47
            if (location[piece] == 'x')
                location[piece] = ' '
            elseif (location[piece] != ' ')
                location[piece + 1] = ' '
            end
        end
    end
    return location
end

# This function takes a JAN, board, index of the slash, and who's turn it is. It will return the location
# of every piece that can be move
function WhereEveryPiece(JAN::MVector, board::MVector, slashIndex::Int8, turn::Int8)
    location::MVector = MVector{6,Char}('x','x','x','x','x','x')
    for i in 1:9
        piece::Int8 = Int(board[i])
        if (piece != 32 && piece % 2 == turn)
            piece = piece - turn - 47 # Reusing variable, a better name would be index
            if (location[piece] == 'x')
                location[piece] = Char(96+i)
            else
                location[piece + 1] = Char(96+i)
            end
        end
    end
    return WhoIsOnTheBench(JAN, slashIndex, turn, location)
end

# This function takes a JAN, board, index of the slash, and who's turn it is. It will return the location
# of every piece that can be move and isn't pin.
function WherePlayablePiece(JAN::MVector, board::MVector, slashIndex, turn)
    letter::Int8 = 97
    location::MVector = MVector{6,Char}('x','x','x','x','x','x')
    if (JAN[1] == 'a')
        letter = letter + 1
        if (JAN[2] == 'b')
            letter = letter + 1
        end
    else
        if (JAN[2] == 'a')
            letter = letter + 1
            piece = Int(JAN[1])
            if (piece % 2 == turn)
                location[piece - turn - 47] = 'a'
            end
        end
    end
    for i in 3:(slashIndex - 2)
        if (JAN[i] == Char(letter))
            piece = Int(JAN[i-1])
            if (piece % 2 == turn && JAN[i-1] < Char(letter-1))
                info = Char(letter)
                if (JAN[i-2] < JAN[i-1])
                    board[letter-96] = JAN[i-2]
                    info = SomethingHasChange(board, info) ? 'x' : info
                    board[letter-96] = JAN[i-1]
                end
                piece = piece - turn - 47
                if (location[piece] == 'x')
                    location[piece] = info
                else
                    location[piece + 1] = info
                end
            end
            letter = letter + 1
        end
    end
    return WhoIsOnTheBench(JAN, slashIndex, turn, location)
end

# This function takes a JAN and a board and return a list of every possible given by what is in the
# location
function GenerateMove(board::MVector, location, turn)
    moveList = []
    for i in 1:9
        val = Int(board[i])>>1
        if (val == 16) # Empty square
            j::Int8 = 1
        else
            j = 2*val-45
        end
        while (j <= 6)
            if (location[j] != 'x')
                move = MVector{3,Char}(Char(((j-1)>>1<<1)+turn+48),location[j],Char(i+96))
                push!(moveList, move)
                j = location[j] == ' ' ? j + (j%2) + 1 : j+1
            else
                j = j+1
            end
        end
    end
    return moveList
end

# This function takes a JAN and board and generate every move possible
function GenerateEveryMove(JAN::MVector, board::MVector)
    slashIndex::Int8 = findlast(JAN.=='/')
    turn::Int8 = Int(JAN[slashIndex-1])%2
    location::MVector = WhereEveryPiece(JAN, board, slashIndex, turn)
    return GenerateMove(board, location, turn)
end

# This function is very similar to GenerateMove, but it will not return move that moves a pin piece.
function GenerateBetterMove(JAN::MVector, board::MVector)
    slashIndex::Int8 = findlast(JAN.=='/')
    turn::Int8 = Int(JAN[slashIndex-1])%2
    location::MVector = WherePlayablePiece(JAN, board, slashIndex, turn)
    return GenerateMove(board, location, turn)
end
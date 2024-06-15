using StaticArrays
# This is another we to represent the game using matrix and interger instead of vectors and Char.
# This will hopefully allows a easier time to implement a transposition table.

# The natural approach would be to make a matrix and in each square put the piece.
# I initially rejected this option, because the memory space inside the square isn't fix.
# A square could contain multiple symbol, so fix array couldn't be use.
# But a simple interger encoding should fix this problem and bitwise operation should make the manipulation of
# the content of a square easy.

#The starting position is a board
#MMatrix{3,4,Int8}(0,0,0,0,0,0,0,0,0,42,42,0)

# This function take a interger value and return the encoded string.
function Decode(val::Int8)
    code::String = ""
    for i in 0:6
        if (val & 1 == 1)
            code = string(code, i)
        end
        val = val>>1
    end
    return code
end

# This function take a none negativ number and return true if O is on top and false if X is on top
function WhoIsOnTop(val::Int8)
    return (val & 42)>(val & 21)
end

# This function take 3 square and return True if every element in those square are of the same parity
function VerifyWin(a::Int8, b::Int8, c::Int8)
    return ((a | b | c) == 0) && ((WhoIsOnTop(a)+WhoIsOnTop(b)+WhoIsOnTop(c))%3 == 0)
end

# This fonction takes a board and return true if a player has won and false if no player has won
function SomeoneWon(board::MMatrix)
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
function SomethingHasChange(board::MMatrix, square::Int8)
    if (square & 1 == 0)
        return (VerifyWin(board[7-(val%4)*2], board[val], board[5-4*(-1)^(val÷5)]) ||
                VerifyWin(board[val], board[5], board[10-val]))
    elseif (square == 5)
        return (VerifyWin(board[1], board[5], board[9]) ||
                VerifyWin(board[2], board[5], board[8]) ||
                VerifyWin(board[3], board[5], board[7]) ||
                VerifyWin(board[4], board[5], board[6]))
    else
        var::Int8 = (-1)^(square÷5)
        return (VerifyWin(board[val], board[5-3*var], board[val+4*(val%3)-2]) ||
                VerifyWin(board[val], board[(val%6)+3], board[val+6*var]) ||
                VerifyWin(board[val], board[5], board[10-val]))
    end
end

# This function take a board and return the board of the new position.
# It assume that the move is always possible
function MakeMove(board::MMatrix, move::MVector)
    newboard::MMatrix = copy(board)
    turn::Int8 = newboard[12]
    piece::Int8 = 1<<(move[1]<<1)
    newboard[move[3]] += piece<<turn
    if (move[2] == 0)
        newboard[10+turn] -= piece
    else
        newboard[move[2]] -= piece
    end
    newboard[12] = xor(turn, 1)
    return newboard
end
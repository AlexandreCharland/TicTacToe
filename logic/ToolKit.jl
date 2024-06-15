using StaticArrays
# This is another we to represent the game using matrix and interger instead of vectors and Char.
# This will hopefully allows a easier time to implement a transposition table.

# The natural approach would be to make a matrix and in each square put the piece.
# I initially rejected this option, because the memory space inside the square isn't fix.
# A square could contain multiple symbol, so fix array couldn't be use.
# But a simple interger encoding should fix this problem and bitwise operation should make the manipulation of
# the content of a square easy.

# The starting position is a game. From 1 to 9 is the board, 10 is the deck of X, 11 the deck of O and 12 the turn
# MMatrix{3,4,Int8}(0,0,0,0,0,0,0,0,0,42,42,0)

# A move is writen with the following notation #ab.
# The # is a number between 0 and 2, where 0 is the small piece and 2 the big piece
# a is the square from where the piece come from. 1 for a, 9 for i and 0 for the deck
# b is the square where the piece should be place.

# This function take a interger value and return the encoded string.
function Decode(val::Int8)
    code::String = ""
    for i in 0:5
        if (val & 1 == 1)
            code = string(code, i)
        end
        val = val>>1
    end
    return code
end

# This function take a positive number and return true if O is on top and false if X is on top
function WhoIsOnTop(val::Int8)
    return (val & 42)>(val & 21)
end

# This function take 3 square and return True if every element in those square are of the same parity
function VerifyWin(a::Int8, b::Int8, c::Int8)
    return ((a | b | c) == 0) && ((WhoIsOnTop(a)+WhoIsOnTop(b)+WhoIsOnTop(c))%3 == 0)
end

# This fonction takes a board and return true if a player has won and false if no player has won
function SomeoneWon(game::MMatrix)
    return (VerifyWin(game[1], game[2], game[3]) || 
            VerifyWin(game[1], game[4], game[7]) ||
            VerifyWin(game[1], game[5], game[9]) ||
            VerifyWin(game[2], game[5], game[8]) ||
            VerifyWin(game[3], game[5], game[7]) ||
            VerifyWin(game[3], game[6], game[9]) ||
            VerifyWin(game[4], game[5], game[6]) ||
            VerifyWin(game[7], game[8], game[9]))
end

# This function takes a board and a square where a modification happen. It checks if the change square 
# modifie the state of the game
function SomethingHasChange(game::MMatrix, square::Int8)
    if (square & 1 == 0)
        return (VerifyWin(game[7-(val%4)*2], game[val], game[5-4*(-1)^(val÷5)]) ||
                VerifyWin(game[val], game[5], game[10-val]))
    elseif (square == 5)
        return (VerifyWin(game[1], game[5], game[9]) ||
                VerifyWin(game[2], game[5], game[8]) ||
                VerifyWin(game[3], game[5], game[7]) ||
                VerifyWin(game[4], game[5], game[6]))
    else
        var::Int8 = (-1)^(square÷5)
        return (VerifyWin(game[val], game[5-3*var], game[val+4*(val%3)-2]) ||
                VerifyWin(game[val], game[(val%6)+3], game[val+6*var]) ||
                VerifyWin(game[val], game[5], game[10-val]))
    end
end

# This function take a board and return the board of the new position.
# It assume that the move is always possible
function MakeMove(game::MMatrix, move::MVector)
    newGame::MMatrix = copy(game)
    piece::Int8 = 1<<(move[1]<<1)
    newGame[move[3]] += piece<<newGame[12]
    if (move[2] == 0)
        newGame[10+turn] -= piece
    else
        newGame[move[2]] -= piece<<newGame[12]
    end
    newGame[12] ⊻= 1
    return newGame
end

function FoundOne(location, piece, from)
    if (location[(piece<<1)+1] == -1)
        location[(piece<<1)+1] = from
    else
        location[(piece<<1)+2] = from
    end
    return location
end

function WhoIsOnTheBench(game::MMatrix, location::MVector)
    val::Int8 = game[10+game[12]]
    for i in 0:2
        if (val & 3 != 0)
            location = FoundOne(location, i, 0)
        end
        val >>= 2
    end
    return location
end

function WhereEveryPiece(game::MMatrix)
    location = MVector{6,Int8}(-1,-1,-1,-1,-1,-1)
    for i in 1:9
        if (game[i] == 0)
            if (WhoIsOnTop(game[i]) == game[12])
                if (game[i] >= 16)
                    location = FoundOne(location, 2, i)
                elseif (game[i] >= 4)
                    location = FoundOne(location, 1, i)
                else
                    location = FoundOne(location, 0, i)
                end
            end
        end
    end
    return WhoIsOnTheBench(game, location)
end

function WherePlayablePiece(game::MMatrix)
    location = MVector{6,Int8}(-1,-1,-1,-1,-1,-1)
    for i in 1:10
        if (game[i] == 0)
            if (WhoIsOnTop(game[i]) == game[12])
                if (game[i] >= 16)
                    game[i] -= 16<<game[12]
                    if (!SomethingHasChange(game, i))
                        location = FoundOne(location, 2, i)
                    end
                    game[i] += 16<<game[12]
                elseif (game[i] >= 4)
                    game[i] -= 4<<game[12]
                    if (!SomethingHasChange(game, i))
                        location = FoundOne(location, 1, i)
                    end
                    game[i] += 4<<game[12]
                else
                    location = FoundOne(location, 0, i)
                end
            end
        end
    end
    return WhoIsOnTheBench(game, location)
end

function GenerateMove(game::MMatrix, location::MVector)
    moveList = []
    for i in 1:9
        if (game[i] == 0)
            j::Int8 = 1
        elseif (game[i]>=16)
            j = 7
        elseif (game[i]>=4)
            j = 5
        else
            j = 3
        end
        while (j <= 6)
            if (location[j] == -1)
                j+=1+(j&1)
            else
                push!(movelist, MVector{3,Int8}((j-1)>>1,location[j],i))
                j = location[j] == 0 ? j + (j & 1) + 1 : j+1
            end
        end
    end
    return moveList
end

function GenerateOrderMove(game::MMatrix, location::MVector)
    moveListBoard = []
    moveListDeck = []
    for i in 1:9
        if (game[i] == 0)
            j::Int8 = 1
        elseif (game[i]>=16)
            j = 7
        elseif (game[i]>=4)
            j = 5
        else
            j = 3
        end
        while (j <= 6)
            if (location[j] == -1)
                j+=1+(j&1)
            elseif (location[j] == 0)
                push!(moveListDeck, MVector{3,Int8}((j-1)>>1,0,i))
                j+=1+(j&1)
            else
                push!(movelistBoard, MVector{3,Int8}((j-1)>>1,location[j],i))
                j+=1
            end
        end
    end
    return append!(moveListDeck, moveListBoard)
end

function GenerateEveryMove(game::MMatrix)
    location::MVector = WhereEveryPiece(game)
    return GenerateMove(game, location)
end

function GenerateBetterMove(game::MMatrix)
    location::MVector = WherePlayablePiece(game)
    return GenerateOrderMove(game, location)
end
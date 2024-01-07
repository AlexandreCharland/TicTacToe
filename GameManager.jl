include("JANValidation.jl")

# Numerical notation equivalence in alphabetical notation 0 = S, 1 = s, 2 = M, 3 = m, 4 = L, 5 = l
translation = Dict("" => " ", '0' => "S", '1' => "s", '2' => "M", '3' => "m", '4' => "L", '5' => "l")

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
# b is the box where the piece ends up.

# This function take a JAN and return true the JAN is valide and false if not.
function VerifyJAN(JAN)
        parts = split(JAN, '/')

        # Confirn that we have two parts
        length(parts) == 2 || throw(ArgumentError("JAN should contain one '/'"))

        leftPart, rightPart = parts[0], parts[1]

    return VerifyLength(leftPart, rightPart) && CountOccurrences(leftPart, rightPart) && VerifySuperiority(leftPart)
end

#This function take a JAN and return the state of the board of the JAN in alphabetical notation.
function ShowPosition(JAN)
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
    line = string(line, translation[stuff])
    println(line)
end

#This function take a JAN and return false if no player has won and true if a player won.
function SomeoneWon(JAN)
    
end

#This fonction take a JAN and return a bool confirming that a move is legal or not.
function VerifyMove(JAN, move)
    
end

#This fonction take a JAN and return the JAN of the new position.
#It assume that the move is always possible
function MakeMove(JAN, move)
    piece = move[1]
    if (move[2] == ' ')
        removeIndex = findlast(piece, JAN)
    else
        removeIndex = findfirst(move[2], JAN)-1
    end
    newJAN = string(JAN[1:removeIndex-1], JAN[removeIndex+1:end])
    addedIndex = findfirst(move[3], newJAN)
    newJAN = string(newJAN[1:addedIndex-1], piece, newJAN[addedIndex:end])
    return newJAN
end
#ShowPosition("abcdefghi0/001122334455")

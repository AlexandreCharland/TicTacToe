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
# b is the box where the piece ends up

# Verify the length of the JAN and the player number
function VerifyLength(leftPart::String, rightPart::String)
    if ((length(leftPart) + length(rightPart) + 1) != 23)
        return false
    else
	    if ((length(leftPart) >= 10) && (length(rightPart) <= 12))
            if ((leftPart[end] == '0' || leftPart[end] == '1') && isletter(leftPart[end-1]) )
                return true
            else
                return false
            end
	    else
	        return false
	    end
    end
end

# This method verify that there is exactly two occurences of the same piece.
function CountOccurrences(leftPart1::String, rightPart::String)
    # Remove the player number
    leftPart = leftPart1[1:end-1]

    # Count occurrences on the left side
    leftOccurrences = Dict(c => count(x -> x == c, leftPart) for c in '0':'5')

    # Count occurrences on the right side
    rightOccurrences = Dict(c => count(x -> x == c, rightPart) for c in '0':'5')

    #println(leftOccurrences, rightOccurrences)

    # Verification
    for c in '0':'5'
        totalOccurences = leftOccurrences[c] + rightOccurrences[c]
        if (totalOccurences != 2)
            return false
        end
    end
    return true
end

# Verify if the the pieces on the board respect the hierarchie
function VerifySuperiority(leftPart::String)
    string = leftPart[1:end-1]
    numbers = ExtractNumbers(string)
    for group in numbers
        if (length(group) >= 2)
            for i in 1:length(group)-1
                if !Superiority(group[i], group[i+1])
                    return false
                end
            end
        end
    end
    return true
end

# Return true if the hierarchie of the pieces is respected
function Superiority(piece1::Char, piece2::Char)
    if div(parse(Int, piece1), 2) < div(parse(Int, piece2), 2)
        return true
    else
        return false
    end
end

# Take a string and return an array of the numbers contained in the string
function ExtractNumbers(string::String)
    regexPattern = r"\d+"
    numbers = eachmatch(regexPattern, string)
    result = [ match.match for match in numbers]
    return result
end

# This function take a JAN and return true the JAN is valide and false if not.
function VerifyJAN(JAN)
    parts = split(JAN, '/')
        # Confirn that we have two parts
    length(parts) == 2 || throw(ArgumentError("JAN should contain one '/'"))

    leftPart, rightPart = parts[1], parts[2]

    return VerifyLength(leftPart, rightPart) && CountOccurrences(leftPart, rightPart) && VerifySuperiority(leftPart)
end

#This function take a JAN and return the state of the board of the JAN in alphabetical notation.
function ShowPosition(JAN)
    if (VerifyJAN(JAN))
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
    else
        println("Invald JAN")
    end
end

#This fonction take a JAN and return a bool confirming that a move is legal or not.
function VerifyMove(JAN, move)
    if VerifyJAN(JAN)
        splittedJAN = split(JAN, "/")
        board, deck = splittedJAN[1][1:end-1], splittedJAN[2]
        piece, from, to = move[1], move[2], move[3]
        toIndex = findfirst(to, board)
        targetOnBoard = toIndex > 1 && toIndex <= length(board) ? board[toIndex-1] : 'z'
        
        # Piece from the deck ?
        if from == ' '
            # Confirm that the piece is on the deck
            if occursin(piece, deck)
                #If there a pice that is already on this part of the board
                if isdigit(targetOnBoard)
                    return Superiority(targetOnBoard, piece)
                else
                    return true # Nothing on this section of the board
                end
            else
                return false # The piece is not in the deck
            end
        else
            positions = GetPiecesPositions(board, piece)
            # Confirm that the piece is on the board
            if !isempty(positions)
                for elem in positions
                    if (elem == string(piece, from))
                        if isdigit(targetOnBoard)
                            return Superiority(targetOnBoard, piece)
                        end
                    end
                end
                return false
            else
                return false # Piece doesn't exist
            end
        end
    else
        return false
    end
end

#This fonction take a JAN and return the JAN of the new position.
#It assume that the move is always possible 1 e
function MakeMove(JAN, move)
    if VerifyMove(JAN, move)
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
    else
        return JAN
    end
end

# Get return the differents positions of a piece in the board
function GetPiecesPositions(board::String, piece::Char)
    regexPattern = piece * r"(\d*?[a-zA-Z])"
    positions = eachmatch(regexPattern, board)
    result = [length(match.match) > 2 ? string(match.match[1], match.match[end]) : match.match for match in positions]
    return result
end

#This function take a JAN and return false if no player has won and true if a player won.
function SomeoneWon(JAN)
    #TODO
end

# ShowPosition("abcdefghi0/001122334455")
# Numerical notation equivalence in alphabetical notation 0 = S, 1 = s, 2 = M, 3 = m, 4 = L, 5 = l

#JAN #a b c d e f g h i /
# # = 0 if it is player 0's move and # = 1 if it is player 1's move
#  a | b | c
# ---+---+---
#  d | e | f
# ---+---+---
#  g | h | i
# Whatever is in the spot a gets recorded in numerical notation. Nothing mean there isn't anything in the spot.
# After the / is the not yet played piece in order of numerical notation
# This is the JAN of the starting position : "0abcdefghi/001122334455"

#This function take a JAN and return the state of the board of the JAN in alphabetical notation.
function ShowPosition(JAN)
    translation = Dict("" => " ", '0' => "S", '1' => "s", '2' => "M", '3' => "m", '4' => "L", '5' => "l")
    letter = 98
    line = " "
    stuff = ""
    for i in 3:findfirst('/', JAN)
        if(Char(letter) != JAN[i])
            stuff = JAN[i]
        else
            line = string(line, translation[stuff])
            if(letter % 3 == 1) #only activate for d and g
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
    println(line)
    #Char(97) = 'a'
    #Char(48) = '0'
end

#This function take a JAN and return 0 if player 0 has won and 1 if player 1 has won.
#It return 2 if the game isn't done
function WinnerDecided(JAN)
    
end

#This fonction take a JAN and return a bool confirming that a move is legal or not.
function VerifyMove(JAN, move)
    
end

#This fonction take a JAN and return the original JAN if the move is illegal.
#If the move is legal it will return the JAN of the new position.
function MakeMove(JAN, move)
    
end
#ShowPosition("0abcdefghi/001122334455")
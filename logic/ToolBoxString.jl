#This file is use mostly to test expected result

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

function WhatInTheBox(JAN)
    myString = ""
    elem = ' '
    letter = 97
    for i in 1:(findfirst('i', JAN))
        if (Char(letter) == JAN[i])
            myString *= elem
            elem = ' '
            letter += 1
        else
            elem = JAN[i]
        end
    end
    return myString
end

function VerifyWin(a, b, c)
    return (Int(a[end-1])%2+Int(b[end-1])%2+Int(c[end-1])%2)%3 == 0
end

function WhatInTheBox(JAN)
    box = ""
    elem = ' '
    letter = 97
    for i in 1:(findfirst('i', JAN))
        if (Char(letter) == JAN[i])
            box *= elem
            elem = ' '
            letter += 1
        else
            elem = JAN[i]
        end
    end
    return box
end
println("05a34bc2d14e3f1g5h0i1/2")
print(MakeMove("05a34bc2d14e3f1g5h0i1/2", "2 i"))
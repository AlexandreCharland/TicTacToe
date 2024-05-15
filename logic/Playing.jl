using StaticArrays
include("ToolBox.jl")
include("Eval.jl")

function playing(JAN, depth)
    gameInProgress = true
    Jan = copy(JAN)
    listPlayedMove = []
    while (gameInProgress)
        ShowPosition(Jan)
        listMove = GenerateEveryMove(Jan)
        userMove = transformString(readline())
        while (!(userMove in listMove))
            println("Invalid move")
            userMove = transformString(readline())
        end
        listPlayedMove = vcat(listPlayedMove, [userMove])
        Jan = MakeMove(Jan, userMove)
        if (SomeoneWon(WhatInTheBox(Jan)))
            print("Congrats you have won")
            break
        end
        useless, compMove = FindBestMove(Jan, WhatInTheBox(Jan), depth)
        listPlayedMove = vcat(listPlayedMove, [compMove[1]])
        print("\033c")
        println(string("The computer played ",prod(compMove[1])))
        Jan = MakeMove(Jan, compMove[1])
        if (SomeoneWon(WhatInTheBox(Jan)))
            println("Get good")
            gameInProgress = false
        end
    end
    for i in listPlayedMove
        println(prod(i))
    end
end

function play(XorO)
    play(XorO, 5)
end

function play(XorO, depth)
    if (XorO%2 == 1)
        playing(MVector{23,Char}('a','b','c','d','0','e','f','g','h','i','1','/','0','1','1','2','2','3','3','4','4','5','5'),depth)
    else
        playing(MVector{23,Char}('a','b','c','d','e','f','g','h','i','0','/','0','0','1','1','2','2','3','3','4','4','5','5'),depth)
    end
end
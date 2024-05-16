using StaticArrays
include("ToolBox.jl")
include("Eval.jl")

function playing(JAN, depth, pieceSet)
    gameInProgress = true
    board = WhatInTheBox(JAN)
    listVal = []
    listPlayedMove = []
    while (gameInProgress)
        ShowPosition(JAN, pieceSet)
        listMove = GenerateEveryMove(JAN, board)
        userMove = transformString(readline())
        while (!(userMove in listMove))
            println("Invalid move")
            userMove = transformString(readline())
        end
        listVal = vcat(listVal, [' '])
        listPlayedMove = vcat(listPlayedMove, [userMove])
        if (ShouldNOTPlayedThat(JAN, board, userMove))
            println("Get good")
            break
        end
        board = ChangeBoard(JAN, board, userMove)
        JAN = MakeMove(JAN, userMove)
        if (SomeoneWon(board))
            println("Congrats you have won")
            break
        end
        val, compMove = FindBestMove(JAN, board, depth)
        listVal = vcat(listVal, [val])
        listPlayedMove = vcat(listPlayedMove, [compMove[1]])
        print("\033c")
        println(string("The computer played ",prod(compMove[1])))
        board = ChangeBoard(JAN, board, compMove[1])
        JAN = MakeMove(JAN, compMove[1])
        if (SomeoneWon(board))
            println("Get good")
            gameInProgress = false
        end
    end
    for i in eachindex(listVal)
        println(string(listVal[i],"   ",prod(listPlayedMove[i])))
    end
end

function play(XorO)
    play(XorO, 5, 2)
end

function play(XorO, depth)
    if (XorO%2 == 1)
        playing(MVector{23,Char}('a','b','c','d','0','e','f','g','h','i','1','/','0','1','1','2','2','3','3','4','4','5','5'),depth, 2)
    else
        playing(MVector{23,Char}('a','b','c','d','e','f','g','h','i','0','/','0','0','1','1','2','2','3','3','4','4','5','5'),depth, 2)
    end
end

function play(XorO, depth, choice)
    pieceSet = ((choice+2)%3)+1
    if (XorO%2 == 1)
        playing(MVector{23,Char}('a','b','c','d','0','e','f','g','h','i','1','/','0','1','1','2','2','3','3','4','4','5','5'), depth, pieceSet)
    else
        playing(MVector{23,Char}('a','b','c','d','e','f','g','h','i','0','/','0','0','1','1','2','2','3','3','4','4','5','5'), depth, pieceSet)
    end
end
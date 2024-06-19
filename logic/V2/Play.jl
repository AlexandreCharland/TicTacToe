using StaticArrays
include("ToolKit.jl")
include("Engine.jl")

function showMove(move::MVector)
    return string(move[1],move[2],move[3])
end

function playing(game::MMatrix, depth::Int8)
    gameInProgress = true
    listVal = []
    listPlayedMove = []
    while (gameInProgress)
        ShowPosition(game)
        listMove = GenerateEveryMove(game)
        userMove = transformInt(readline())
        while (!(userMove in listMove))
            println("Invalid move")
            userMove = transformInt(readline())
        end
        listVal = vcat(listVal, [' '])
        listPlayedMove = vcat(listPlayedMove, [userMove])
        listBadMove = GenerateBetterMove(game)
        if (!(userMove in listBadMove))
            println("Get good")
            break
        end
        game = MakeMove(game, userMove)
        if (SomeoneWon(game))
            println("Congrats you have won")
            break
        end
        val, compMove = FindBestMove(game, depth)
        computerMove = compMove[1]
        listVal = vcat(listVal, [val])
        listPlayedMove = vcat(listPlayedMove, [computerMove])
        print("\033c")
        println(string("The computer played ",showMove(computerMove)))
        game = MakeMove(game, computerMove)
        if (SomeoneWon(game))
            println("Get good")
            gameInProgress = false
        end
    end
    for i in eachindex(listVal)
        println(string(listVal[i],"   ",showMove(listPlayedMove[i])))
    end
end

function play()
    a=MMatrix{3,4,Int8}(0,0,0,0,0,0,0,0,0,42,42,0)
    playing(a, Int8(5))
end
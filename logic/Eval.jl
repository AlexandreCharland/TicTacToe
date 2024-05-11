using StaticArrays
include("ToolBox.jl")

function X(JAN::MVector, board::MVector, prevMove::MVector, depth::Int64)
    if (SomethingHasChange(board, prevMove[3]))
        return -1, [prevMove]
    elseif (depth == 0)
        return 0, [prevMove]
    else
        moveList = GenerateBetterMove(JAN, board)
        if (isempty(moveList))
            return -1, [prevMove]
        else
            positionValue = -2
            bestSequence = []
            for move in moveList
                val, sequence = O(MakeMove(JAN, move), ChangeBoard(JAN, board, move), move, depth-1)
                if (val == 1)
                    return val, vcat([prevMove], sequence)
                elseif (val > positionValue)
                    bestSequence = vcat([prevMove], sequence)
                    positionValue = val
                end
            end
            return positionValue, bestSequence
        end
    end
end

function O(JAN::MVector, board::MVector, prevMove::MVector, depth::Int64)
    if (SomethingHasChange(board, prevMove[3]))
        return 1, [prevMove]
    elseif (depth == 0)
        return 0, [prevMove]
    else
        moveList = GenerateBetterMove(JAN, board)
        if (isempty(moveList))
            return 1, [prevMove]
        else
            positionValue = 2
            bestSequence = []
            for move in moveList
                val, sequence = X(MakeMove(JAN, move), ChangeBoard(JAN, board, move), move, depth-1)
                if (val == -1)
                    return val, vcat([prevMove], sequence)
                elseif (val < positionValue)
                    bestSequence = vcat([prevMove], sequence)
                    positionValue = val
                end
            end
            return positionValue, bestSequence
        end
    end
end

function eval(JAN::MVector, board::MVector, depth::Int64)
    turn = findlast(JAN.=='/')-1
    playerTurn = Int(JAN[turn])%2
    if (playerTurn == 1)
        return O(JAN, board, MVector{3,Char}(' ',' ',' '), depth)
    else
        return X(JAN, board, MVector{3,Char}(' ',' ',' '), depth)
    end
end

#Testing...
#a=MVector{23,Char}('0','3','a','b','c','1','4','d','1','2','4','e','5','f','0','3','g','h','i','1','/','2','5')
#a=MVector{23,Char}('0','3','a','5','b','c','1','4','d','1','2','4','e','5','f','0','3','g','h','i','0','/','2')
#a=MVector{23,Char}('3','4','a','b','3','4','c','5','d','1','2','e','1','2','f','g','h','0','5','i','1','/','0')
#a=MVector{23,Char}('0','4','a','2','5','b','3','c','1','3','4','d','2','5','e','1','f','g','h','i','0','/','0')
#a=MVector{23,Char}('a','1','b','3','c','d','2','5','e','2','5','f','g','1','3','4','h','0','4','i','0','/','0')
#a=MVector{23,Char}('0','5','a','3','4','b','c','2','d','1','4','e','3','f','1','g','5','h','0','2','i','1','/')
#a=MVector{23,Char}('1','3','5','a','1','5','b','c','0','2','4','d','e','f','0','2','4','g','h','i','0','/','3')
#a=MVector{23,Char}('3','4','a','5','b','0','3','4','c','1','d','0','5','e','f','g','2','h','i','0','/','1','2')
#a=MVector{23,Char}('3','4','a','5','b','0','c','d','0','5','e','f','g','h','i','0','/','1','1','2','2','3','4')
#a=MVector{23,Char}('0','3','a','b','c','1','4','d','1','2','e','f','0','3','g','h','i','1','/','2','4','5','5')
#print(eval(a,WhatInTheBox(a), 7))
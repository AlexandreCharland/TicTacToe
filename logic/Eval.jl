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
            positionValue = 1
            bestSequence = []
            for move in moveList
                val, sequence = O(MakeMove(JAN, move), ChangeBoard(JAN, board, move), move, depth-1)
                if (val >= 1)
                    return (val+1), vcat([prevMove], sequence)
                elseif (val == 0)
                    bestSequence = vcat([prevMove], sequence)
                    positionValue = val
                elseif (val < positionValue && positionValue != 0)
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
            positionValue = -1
            bestSequence = []
            for move in moveList
                val, sequence = X(MakeMove(JAN, move), ChangeBoard(JAN, board, move), move, depth-1)
                if (val <= -1)
                    return (val-1), vcat([prevMove], sequence)
                elseif (val == 0)
                    bestSequence = vcat([prevMove], sequence)
                    positionValue = val
                elseif (val > positionValue && positionValue != 0)
                    bestSequence = vcat([prevMove], sequence)
                    positionValue = val
                end
            end
            return positionValue, bestSequence
        end
    end
end

# Determine the evaluation of the position
function eval(JAN::MVector, board::MVector, depth::Int64)
    turn = findlast(JAN.=='/')-1
    playerTurn = Int(JAN[turn])%2
    if (playerTurn == 1)
        val, list = O(JAN, board, MVector{3,Char}(' ',' ',' '), depth)
    else
        val, list = X(JAN, board, MVector{3,Char}(' ',' ',' '), depth)
    end
    if (val != 0)
        val = div(abs(val),val)
    end
    return val
end


# Determine the best move in the position
function FindBestMove(JAN::MVector, board::MVector, depth::Int64)
    turn = findlast(JAN.=='/')-1
    playerTurn = Int(JAN[turn])%2
    bestVal = nothing
    bestList = []
    if (playerTurn == 1)
        val, list = O(JAN, board, MVector{3,Char}(' ',' ',' '), depth)
        bestList = list
        bestVal = val
        while (abs(val) > 2)
            bestList = list
            bestVal = val
            val, list = O(JAN, board, MVector{3,Char}(' ',' ',' '), abs(val)-1)
        end
    else
        val, list = X(JAN, board, MVector{3,Char}(' ',' ',' '), depth)
        bestList = list
        bestVal = val
        while (abs(val) > 2)
            bestList = list
            bestVal = val
            val, list = X(JAN, board, MVector{3,Char}(' ',' ',' '), abs(val)-1)
        end
    end
    return bestVal, bestList[2:end]
end
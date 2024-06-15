using StaticArrays
include("ToolKit.jl")

function X(game::MMatrix, prevMove::MVector, depth::Int8)
    if (SomethingHasChange(game, prevMove[3]))
        return -1, [prevMove]
    elseif (depth == 0)
        return 0, [prevMove]
    else
        moveList = GenerateBetterMove(game)
        if (isempty(moveList))
            return -1, [prevMove]
        else
            positionValue = 1
            bestSequence = []
            for move in moveList
                val, sequence = O(MakeMove(game, move), move, Int8(depth-1))
                if (val >= 1)
                    return (val+1), vcat([prevMove], sequence)
                elseif (val == 0 && positionValue != 0)
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

function O(game::MMatrix, prevMove::MVector, depth::Int8)
    if (SomethingHasChange(game, prevMove[3]))
        return 1, [prevMove]
    elseif (depth == 0)
        return 0, [prevMove]
    else
        moveList = GenerateBetterMove(game)
        if (isempty(moveList))
            return 1, [prevMove]
        else
            positionValue = -1
            bestSequence = []
            for move in moveList
                val, sequence = X(MakeMove(game, move), move, Int8(depth-1))
                if (val <= -1)
                    return (val-1), vcat([prevMove], sequence)
                elseif (val == 0 && positionValue != 0)
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
function eval(game::MMatrix, depth::Int8)
    if (game[12] == 0)
        val, list = X(game, MVector{3,Int8}(0,0,1), depth)
    else
        val, list = O(game, MVector{3,Int8}(0,0,1), depth)
    end
    return val, list[2:end]
end
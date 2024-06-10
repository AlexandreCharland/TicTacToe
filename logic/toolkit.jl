using StaticArrays
include("ToolBox.jl")
# This is another we to represent the game using matrix and interger instead of vectors and Char.
# This will hopefully allows a easier time to implement a transposition table.

# The natural approach would be to make a matrix and in each square put the piece.
# I initially rejected this option, because the memory space inside the square isn't fix.
# A square could contain multiple symbol, so fix array couldn't be use.
# But a simple interger encoding should fix this problem and bitwise operation should make the manipulation of
# the content of a square easy.

#The starting position is a triple, the board, the deck and the playerTurn
#MMatrix{3,3,Int8}(0,0,0,0,0,0,0,0,0),2730,0

# This function take a interger value and return the encoded string.
function Decode(val::Int8)
    code::String = ""
    for i in 0:6
        if (val & 1 == 1)
            code = string(code, i)
        end
        val = val>>1
    end
    return code
end
using StaticArrays
include("ToolBox.jl")

function eval(JAN::MVector, turn::Int8, depth::Int8)
    depth = depth - turn
    
end

function FindBestMove()
    return 1
end

#a=MVector{23,Char}('0','3','a','b','c','1','4','d','1','2','4','e','5','f','0','3','g','h','i','1','/','2','5')
a=MVector{23,Char}('0','3','a','b','c','1','4','d','1','2','4','e','5','f','0','3','g','h','i','1','/','2','5')
b=WhatInTheBox(a)
for i in GenerateBetterMove(a,b)
    println(i)
end
#a=MVector{23,Char}('3','4','a','b','3','4','c','5','d','1','2','e','1','2','f','g','h','0','5','i','1','/','0',)
#a=MVector{23,Char}('0','4','a','2','5','b','3','c','1','3','4','d','2','5','e','1','f','g','h','i','0','/','0')
#a=MVector{23,Char}('a','1','b','3','c','d','2','5','e','2','5','f','g','1','3','4','h','0','4','i','0','/','0')
#a=MVector{23,Char}('0','5','a','3','4','b','c','2','d','1','4','e','3','f','1','g','5','h','0','2','i','1','/')

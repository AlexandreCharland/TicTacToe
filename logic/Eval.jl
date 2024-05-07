using StaticArrays

#a=MVector{23,Char}('0','4','a','2','5','b','3','c','1','3','4','d','2','5','e','1','f','g','h','i','0','/','0')
a=MVector{23,Char}('a','1','b','3','c','d','2','5','e','2','5','f','g','1','3','4','h','0','4','i','0','/','0')
b = WhatInTheBox(a)
for i in GenerateBetterMove(a,b)
    println(i)
end
println()
for i in GenerateEveryMove(a,b)
    println(i)
end
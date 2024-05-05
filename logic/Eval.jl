using StaticArrays

a=MVector{23,Char}('0','4','a','2','5','b','3','c','1','3','4','d','2','5','e','1','f','g','h','i','0','/','0')
b = WhatInTheBox(a)
ShowPosition(a)
for i in GenerateMove(a, b)
    ShowPosition(MakeMove(a,i))
end
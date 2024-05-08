using Test
include("../logic/ToolBox.jl")

@testset "Test MakeMove" begin
    @test prod(MakeMove(MVector{23,Char}('0','5','a','3','4','b','c','2','d','1','4','e','3','f','1','g','5','h','0','2','i','1','/'), MVector{3,Char}('5','h','g'))) == "05a34bc2d14e3f15gh02i0/"
    @test prod(MakeMove(MVector{23,Char}('a','b','c','d','e','f','g','h','i','0','/','0','0','1','1','2','2','3','3','4','4','5','5'), MVector{3,Char}('0',' ','e'))) == "abcd0efghi1/01122334455"
    @test prod(MakeMove(MVector{23,Char}('a','b','c','d','0','e','f','g','h','i','1','/','0','1','1','2','2','3','3','4','4','5','5'), MVector{3,Char}('3',' ','a'))) == "3abcd0efghi0/0112234455"
    @test prod(MakeMove(MVector{23,Char}('3','a','b','c','d','0','e','f','g','h','i','0','/','0','1','1','2','2','3','4','4','5','5'), MVector{3,Char}('0',' ','c'))) == "3ab0cd0efghi1/112234455"
    @test prod(MakeMove(MVector{23,Char}('3','a','b','0','c','d','0','e','f','g','h','i','1','/','1','1','2','2','3','4','4','5','5'), MVector{3,Char}('5',' ','e'))) == "3ab0cd05efghi0/11223445"
    @test prod(MakeMove(MVector{23,Char}('3','a','b','0','c','d','0','5','e','f','g','h','i','0','/','1','1','2','2','3','4','4','5'), MVector{3,Char}('4',' ','a'))) == "34ab0cd05efghi1/1122345"
    @test prod(MakeMove(MVector{23,Char}('3','4','a','b','0','c','d','0','5','e','f','g','h','i','1','/','1','1','2','2','3','4','5'), MVector{3,Char}('5',' ','b'))) == "34a5b0cd05efghi0/112234"
end
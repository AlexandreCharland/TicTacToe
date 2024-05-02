using Test
include("../logic/GameUtiliatries.jl")

@testset "Test MakeMove" begin
    @test MakeMove("05a34bc2d14e3f1g5h02i1/", "5hg") == "05a34bc2d14e3f15gh02i0/"
    @test MakeMove("abcdefghi0/001122334455", "0 e") == "abcd0efghi1/01122334455"
    @test MakeMove("abcd0efghi1/01122334455", "3 a") == "3abcd0efghi0/0112234455"
    @test MakeMove("3abcd0efghi0/0112234455", "0 c") == "3ab0cd0efghi1/112234455"
    @test MakeMove("3ab0cd0efghi1/112234455", "5 e") == "3ab0cd05efghi0/11223445"
    @test MakeMove("3ab0cd05efghi0/11223445", "4 a") == "34ab0cd05efghi1/1122345"
    @test MakeMove("34ab0cd05efghi1/1122345", "5 b") == "34a5b0cd05efghi0/112234"
end
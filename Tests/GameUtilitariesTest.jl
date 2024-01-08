using Test
include("../GameUtiliatries.jl")

@testset "Test VerifyLength" begin
    @test VerifyLength("abcdefghi0", "001122334455") == true
    @test VerifyLength("a02bcde135fghi0", "0123445") == true
    @test VerifyLength("a05b05c1d14e24f2g3h3i0", "") == true
    @test VerifyLength("a0bcdefghi0", "001122334455") == false
end

@testset "Test CountOccurrences" begin
    @test CountOccurrences("a02bcde135fghi0", "0123445") == true
    @test CountOccurrences("a22bcde135fghi0", "1223445") == false
    @test CountOccurrences("3a05b05c1d1e24fg3h24i0", "") == true
end

@testset "Test VerifySuperiority" begin
    @test VerifySuperiority("01abcdrfghi0") == false
    @test VerifySuperiority("a02bcdr135fghi0") == true
    @test VerifySuperiority("a02bcdr015fghi0") == false
    @test VerifySuperiority("a05b05c1d1e24fg3h24i0") == true
end

@testset "Test VerifyJAN" begin
    @test VerifyJAN("a05b05c1d1e24f24g3h3i0/") == true
    @test VerifyJAN("a02bcdr135fghi0/0123445") == true
    @test VerifyJAN("a0bcdefghi0/001122334455") == false
    @test VerifyJAN("a0bcdefghi0/001122334455") == false
    @test VerifyJAN("a22bcde135fghi0/1223445") == false
    @test VerifyJAN("a01bcdrfghi0/0122334455") == false
end

@testset "Test GetPiecesPositions" begin
    @test GetPiecesPositions("a05b05c1d1e24f24g3h3i0", '5') == ["5b", "5c"]
    @test GetPiecesPositions("a05b05c1d1e24f24g3h3i0", '2') == ["2f", "2g"]
    @test GetPiecesPositions("a05b05c1d1e24f24g3h3i0", '0') == ["0b", "0c"]
    @test GetPiecesPositions("a024b05c1d1e24f4g3h3i0", '2') == ["2b", "2f"]
end

@testset "Test VerifyMove" begin
    @test VerifyMove("a02bcdr135fghi0/0123445", "0 d") == true
    @test VerifyMove("a05b05c1d1e24f24g3h3i0/", "0 d") == false
    @test VerifyMove("a05b0c1d1e24f24g3h3i0/5", "5bd") == true
    @test VerifyMove("a05b0c1d1e24f24g3h3i0/5", "5bf") == false
    @test VerifyMove("a05b0c1d1e24f24g3h3i0/5", "5 a") == true
    @test VerifyMove("a05b0c1d1e24f24g3h3i0/5", "5af") == false
end

@testset "Test SomeoneWon" begin
    # Horizontal win 
    @test SomeoneWon("1a03b025cdefghi0/123445") == true
    @test SomeoneWon("abc2d14e2fghi1/00133455") == true
    @test SomeoneWon("abcdef25g03h1i1/0123445") == true
    
    # Vertical win
    @test SomeoneWon("0abc2def04ghi0/11233455") == true
    @test SomeoneWon("a1bcd03efg05h4i0/122345") == true
    @test SomeoneWon("ab0cde0fgh14i1/12233455") == true

    @test SomeoneWon("0abcd2efgh04i0/11233455") == true
    @test SomeoneWon("ab1cd3ef5ghi0/001223445") == true
end
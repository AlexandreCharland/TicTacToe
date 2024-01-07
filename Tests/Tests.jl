using Test
include("../logic/JANValidation.jl")
include("../logic/GameManager.jl")

@testset "Test VerifyLength" begin
    @test VerifyLength("abcdefghi0", "001122334455") == true
    @test VerifyLength("a02bcde135fghi0", "0123445") == true
    @test VerifyLength("a05b05c1d1e24f2g3h3i40", "") == true
    @test VerifyLength("a0bcdefghi0", "001122334455") == false
end

@testset "Test CountOccurrences" begin
    @test CountOccurrences("a02bcdr135fghi0", "0123445") == true
    @test CountOccurrences("a22bcde135fghi0", "1223445") == false
    @test CountOccurrences("a05b05c1d1e24f2g3h3i40", "") == true
end

@testset "Test VerifySuperiority" begin
    @test VerifySuperiority("a01bcdrfghi0") == false
    @test VerifySuperiority("a02bcdr135fghi0") == true
    @test VerifySuperiority("a02bcdr015fghi0") == false
    @test VerifySuperiority("a05b05c1d1e24f2g3h3i40") == true
end

@testset "Test VerifyJAN" begin
    @test VerifyJAN("a05b05c1d1e24f2g3h3i40/") == true
    @test VerifyJAN("a02bcdr135fghi0/0123445") == true
    @test VerifyJAN("a0bcdefghi0/001122334455") == false
    @test VerifyJAN("a0bcdefghi0/001122334455") == false
    @test VerifyJAN("a22bcde135fghi0/1223445") == false
    @test VerifyJAN("a01bcdrfghi0/0122334455") == false
end
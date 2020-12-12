push!(LOAD_PATH, "/home/jake/dev/data/src/SolveDash/experiment/")
using MyConditions
using MyFields
using MySolutions
using MySolver
using Parameters
using Test
import Unitful:
    mm, cm, m, km, inch, ft, yd, mi,
    ns, μs, ms, s, minute, hr, wk, yr,
    ustrip, @u_str

# create initial conditions
ic = BaseConditions(
        PositionField(0.0, m, true),
        PositionField(nothing, nothing, false),
        VelocityField(0.0, m/s, m, s, true),
        VelocityField(nothing, km/minute, km, minute, false),
        VelocityField(nothing, nothing, nothing, nothing, false),
        TimeField(5.0, s, true),
        AccelerationField(nothing, m/s^2, m, s, true))
# create a solution set and populate with initial conditions
sol = BaseSolutionSet()
populate!(sol,ic)
# validate
@testset "my solution set" begin
    @testset "unsolved" begin
        @test sol.x₀ == 0.0
        @test sol.x == nothing
        @test sol.v₀ == 0.0
        @test sol.v == nothing
        @test sol.v̄ == nothing
        @test sol.t == 5.0
        @test sol.a == nothing
        @test !issolved(sol)
    end
    sol.x₀ = 100m
    sol.x = 100m
    sol.v₀ = 100m/s
    sol.v = 100m/s
    sol.v̄ = 100m/s
    sol.t = 100s
    sol.a = 100m/s^2
    @testset "solved" begin
        @test sol.x₀ == 100m
        @test sol.x == 100m
        @test sol.v₀ == 100m/s
        @test sol.v == 100m/s
        @test sol.v̄ == 100m/s
        @test sol.t == 100s
        @test sol.a == 100m/s^2
        @test issolved(sol)
    end
end

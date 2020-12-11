# push!(LOAD_PATH, "/home/jake/dev/data/src/SolveDash/experiment/")
using MyConditions
using MyFields
using MySolver
using Parameters
using Test
import Unitful:
    mm, cm, m, km, inch, ft, yd, mi,
    ns, μs, ms, s, minute, hr, wk, yr,
    ustrip, @u_str

# create base initial conditions
b = BaseConditions(
        PositionField(0.0, m, false),
        PositionField(nothing, nothing, false),
        VelocityField(0.0, m/s, m, s, false),
        VelocityField(16.92, km/minute, km, minute, false),
        VelocityField(nothing, nothing, nothing, nothing, false),
        TimeField(5.0, s, false),
        AccelerationField(nothing, m/s^2, m, s, true))
# unpack for easier acccess to fields
@unpack x₀, x, v₀, v, v̄, t, a = b
# create some stand alone fields
pf1 = PositionField(1.0, m, false)
pf2 = PositionField(10.0, m, false)
vf1 = VelocityField(2.0, m/s, m, s, false)
vf2 = VelocityField(400.0, m/s, m, s, false)
vf3 = VelocityField(55.0, m/s, m, s, false)
tf1 = TimeField(5.0, s, false)
af1 = AccelerationField(12.0, m/s^2, m, s, true)
# begin tests
@testset "solver utilities" begin
    @testset "hasunit" begin
        @test hasunit([x, v̄]) == false
        @test hasunit([x₀, v₀, v, t, a]) == true
    end
    @testset "hasvalue" begin
        @test hasvalue([x, v̄]) == false
        @test hasvalue([x₀, v₀, v, t]) == true
    end
    # @testset "revert units" begin
    #     unify!([t, v, x₀])
    #     @test revert_units(t) == 5s
    #     @test revert_units(v) ≈ 282*km/minute
    #     @test revert_units(x₀) == 0m
    # end
end # utilities testset
@testset "solver functions" begin
    @testset "find acceleration" begin
        unify!([v, v₀, t])
        @test find_acceleration(v, v₀, t) ≈ 56.4
        @test find_acceleration(pf2, pf1, vf1, tf1) ≈ -0.08
        @test find_acceleration(vf3, vf1, pf2, pf1) ≈ 167.83333333333334
    end
    @testset "find time" begin
        @test
    end
end # functions testset

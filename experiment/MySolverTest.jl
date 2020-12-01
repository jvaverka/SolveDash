push!(LOAD_PATH, "/home/jake/dev/data/src/SolveDash/experiment/")
using Test
using Parameters
using MyConditions
using MyFields
using MySolver
import Unitful:
    mm, cm, m, km, inch, ft, yd, mi,
    ns, μs, ms, s, minute, hr, wk, yr,
    ustrip, @u_str
    

@testset "utility functions" begin
    b = BaseConditions(
        PositionField(0, m, false),
        PositionField(nothing, nothing, false),
        VelocityField(0m/s, m/s, m, s, false),
        VelocityField(423//25*km/minute, km/minute, km, minute, false),
        VelocityField(nothing, nothing, nothing, nothing, false),
        TimeField(5s, s, false),
        AccelerationField(nothing, m/s^2, m, s, true)
    )
    @unpack x₀, x, v₀, v, v̄, t, a = b
    @testset "hasunit" begin
        @test hasunit([x, v̄]) == false
        @test hasunit([x₀, v₀, v, t, a]) == true
    end
    @testset "hasvalue" begin
        @test hasvalue([x, v̄]) == false
        @test hasvalue([x₀, v₀, v, t]) == true
    end
    @testset "convert fields" begin
        convert_field_value!(t, a)
        @test t.val == 5s
        convert_field_value!(v, a)
        @test v.val == 282m/s
    end
    @testset "find acceleration" begin
        @test find_acceleration(v, v₀, t) == (282//5)*m/s^2
        @test float(find_acceleration(v, v₀, t)) == 56.4m/s^2
    end
end
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
        PositionField(0m, m, false),
        PositionField(nothing, nothing, false),
        VelocityField(0m/s, m/s, m, s, false),
        VelocityField(423//25*km/minute, km/minute, km, minute, false),
        VelocityField(nothing, nothing, nothing, nothing, false),
        TimeField(5s, s, false),
        AccelerationField(nothing, m/s^2, m, s, true)
    )

    pf1 = PositionField(1m, m, false)
    pf2 = PositionField(10km, km, false)
    vf1 = VelocityField(2km/hr, km/hr, km, hr, false)
    vf2 = VelocityField(400*km/minute, km/minute, km, minute, false)
    vf3 = VelocityField(55yd/μs, yd/μs, yd, μs, false)
    tf1 = TimeField(5ns, ns, false)
    af1 = AccelerationField(12ft/s^2, ft/s^2, ft, s, true)

    @unpack x₀, x, v₀, v, v̄, t, a = b
    @testset "hasunit" begin
        @test hasunit([x, v̄]) == false
        @test hasunit([x₀, v₀, v, t, a]) == true
    end
    @testset "hasvalue" begin
        @test hasvalue([x, v̄]) == false
        @test hasvalue([x₀, v₀, v, t]) == true
    end
    @testset "convert single field value" begin
        @test convert_field_value!(t, a) == 5s
        @test convert_field_value!(v, a) == 282m/s
        @test convert_field_value!(x₀, a) == 0km
        @test convert_field_value!(vf1, tf1) == 2km/ns
        @test convert_field_value!(af1, tf1) == (3//250000000000000000)*ft/ns^-2
    end
    @testset "revert units" begin
        @test revert_units!(t) == 5s
        @test revert_units!(v) == 423//25*km/minute
        @test revert_units!(x₀) == 0m
    end
    @testset "convert multiple field values" begin
        convert_field_values!([t, v, x₀], a)
        @test t.val == 5s
        @test v.val == 282m/s
        @test x₀.val == 0km
    end
    @testset "find acceleration" begin
        @test find_acceleration(v, v₀, t) == (282//5)*m/s^2
        @test float(find_acceleration(v, v₀, t)) == 56.4m/s^2
    end
end

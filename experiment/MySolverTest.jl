push!(LOAD_PATH, "/home/jake/dev/data/src/SolveDash/experiment/")
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
        @testset " vₓ = vₓ₀ + aₓt " begin
            unify!([v, v₀, t])
            @test find_acceleration(v, v₀, t) ≈ 56.4
            @test find_acceleration(
                VelocityField(35.0,m/s,m,s,false),
                VelocityField(5.0,m/s,m,s,false),
                TimeField(24,s,false)) ≈ 1.25
            @test find_acceleration(
                VelocityField(350.0,m/s,m,s,false),
                VelocityField(50.0,m/s,m,s,false),
                TimeField(24,s,false)) ≈ 12.5
        end
        @testset " x = x₀ + vₓ₀t + (1//2)aₓt² " begin
            @test find_acceleration(
                PositionField(2.0,m,false),
                PositionField(0.0,m,false),
                VelocityField(0.0,m/s,m,s,false),
                TimeField(1.0,s,false)) ≈ 4.0
            @test find_acceleration(
                PositionField(600.0,m,false),
                PositionField(0.0,m,false),
                VelocityField(1.0,m/s,m,s,false),
                TimeField(10.0,s,false)) ≈ 11.8
            @test find_acceleration(
                PositionField(600.0,m,false),
                PositionField(10.0,m,false),
                VelocityField(11.0,m/s,m,s,false),
                TimeField(10.0,s,false)) ≈ 9.6
        end
        @testset " vₓ² = vₓ₀² + 2aₓ𝚫x " begin
            @test find_acceleration(
                VelocityField(5.0,m/s,m,s,false),
                VelocityField(0.0,m/s,m,s,false),
                PositionField(5.0,m,false),
                PositionField(0.0,m,false)) ≈ 2.5
            @test find_acceleration(
                VelocityField(5.0,m/s,m,s,false),
                VelocityField(1.0,m/s,m,s,false),
                PositionField(5.0,m,false),
                PositionField(1.0,m,false)) ≈ 3.0
            @test find_acceleration(
                VelocityField(8.0,m/s,m,s,false),
                VelocityField(2.0,m/s,m,s,false),
                PositionField(10.0,m,false),
                PositionField(0.0,m,false)) ≈ 3.0
        end
    end
    @testset "find time" begin
        @testset " vₓ = vₓ₀ + aₓt " begin
            @test find_time(
                VelocityField(4.0,m/s,m,s,false),
                VelocityField(0.0,m/s,m,s,false),
                AccelerationField(32,m/s^2,m,s,false)) ≈ 0.125
            @test find_time(
                VelocityField(20.0,m/s,m,s,false),
                VelocityField(2.0,m/s,m,s,false),
                AccelerationField(32,m/s^2,m,s,false)) ≈ 0.5625
            @test find_time(
                VelocityField(2_000.0,m/s,m,s,false),
                VelocityField(0.0,m/s,m,s,false),
                AccelerationField(32,m/s^2,m,s,false)) ≈ 62.5
        end
        @testset " v̄ = 𝚫x/𝚫t " begin
            @test find_time(
                PositionField(45.0,m,false),
                PositionField(0.0,m,false),
                VelocityField(45.0,m/s,m,s,false)) ≈ 1.0
            @test find_time(
                PositionField(1_000.0,m,false),
                PositionField(37.0,m,false),
                VelocityField(45.0,m/s,m,s,false)) ≈ 21.4
            @test find_time(
                PositionField(100.0,m,false),
                PositionField(37.0,m,false),
                VelocityField(14.0,m/s,m,s,false)) ≈ 4.5
        end
        @testset " a = 𝚫v/𝚫t " begin
            @test find_time(
                VelocityField(75.0,m/s,m,s,false),
                VelocityField(0.0,m/s,m,s,false),
                AccelerationField(10,m/s^2,m,s,false)) ≈ 7.5
            @test find_time(
                VelocityField(0.0,m/s,m,s,false),
                VelocityField(100.0,m/s,m,s,false),
                AccelerationField(-10,m/s^2,m,s,false)) ≈ 10.0
            @test find_time(
                VelocityField(25.0,m/s,m,s,false),
                VelocityField(1_000.0,m/s,m,s,false),
                AccelerationField(-10,m/s^2,m,s,false)) ≈ 97.5
        end
    end
    @testset "find average velocity" begin
        @testset " v̄ = 𝚫x/t " begin
            @test find_average_velocity(
                PositionField(110.0,m,false),
                PositionField(0.0,m,false),
                TimeField(10.0,s,false)) ≈ 11.0
        end
        @testset " v̄ = 𝚫v/t " begin
            @test find_average_velocity(
                VelocityField(180.0,m/s,m,s,false),
                VelocityField(60.0,m/s,m,s,false),
                TimeField(6.0,s,false)) ≈ 20.0
        end
    end
    @testset "find final velocity" begin
        @testset " v = v₀ + at " begin
            @test find_velocity(
                VelocityField(4.0,m/s,m,s,false),
                AccelerationField(42.0,m/s^2,m,s,false),
                TimeField(4,s,false)) ≈ 172
        end
        @testset " v² = v₀² + 2a𝚫x " begin
            find_velocity(
                VelocityField(0.0,m/s,m,s,false),
                AccelerationField(1,m/s^2,m,s,false),
                PositionField(9.0,m,false),
                PositionField(0.0,m,false)) ≈ 1
        end
        @testset " x = ((v₀+v)/2)t " begin
            @test find_velocity(
            PositionField(12.0,m,false),
            PositionField(0.0,m,false),
            VelocityField(0.0,m/s,m,s,false),
            TimeField(3.0,s,false)) ≈ 8
        end
    end
    @testset "find initial velocity" begin
        @testset " v̄ = (v₀+v)/t " begin
            @test find_initial_velocity(
                VelocityField(8.0,m/s,m,s,false),
                VelocityField(0.0,m/s,m,s,false),
                TimeField(3.0,s,false)) ≈ 24
        end
        @testset " v = v₀ + at " begin
            @test find_initial_velocity(
                VelocityField(30.0,m/s,m,s,false),
                AccelerationField(3.0,m/s^2,m,s,false),
                TimeField(4.0,s,false)) ≈ 18
        end
        @testset " v² = v₀² + 2a𝚫x " begin
            @test find_initial_velocity(
                VelocityField(6.0,m/s,m,s,false),
                AccelerationField(4.0,m/s^2,m,s,false),
                PositionField(4.0,m,false),
                PositionField(0.0,m,false)) ≈ 2
        end
        @testset " 𝚫x = v₀t + 0.5at² " begin
            @test find_initial_velocity(
                PositionField(10.0,m,false),
                PositionField(0.0,m,false),
                TimeField(2,s,false),
                AccelerationField(10,m/s^2,m,s,false)) ≈ -5
        end
        @testset " 𝚫x = ((v₀+v)/2)*t " begin
            @test find_initial_velocity(
                PositionField(300.0,m,false),
                PositionField(0.0,m,false),
                VelocityField(20.0,m/s,m,s,false),
                TimeField(3.0,s,false)) ≈ 2
        end
    end
    @testset "find final position" begin
        @testset " v̄ = 𝚫x/t " begin
            @test find_final_position(
                VelocityField(),
                PositionField(),
                TimeField()) ≈ 0
        end
    end
end # functions testset

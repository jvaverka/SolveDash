push!(LOAD_PATH, "/home/jake/dev/data/src/SolveDash/experiment/")
using Test
using MyConditions
using MyFields
import Unitful:
    mm, cm, m, km, inch, ft, yd, mi,
    ns, μs, ms, s, minute, hr, wk, yr,
    ustrip, @u_str


@testset "base conditions" begin
    b = BaseConditions(
        PositionField(0.0, m, false),
        PositionField(nothing, nothing, false),
        VelocityField(0.0, m/s, m, s, false),
        VelocityField(282.0, m/s, m, s, false),
        VelocityField(nothing, nothing, nothing, nothing, false),
        TimeField(5.0, s, false),
        AccelerationField(nothing, m/s^2, m, s, true)
    )
    @testset "typeof base" begin
        # @test typeof(b) ∈ subtypes(AbstractConditions)
        @test typeof(b) == BaseConditions
        @test typeof(b.x₀) == typeof(PositionField(1.0, m, false))
        @test typeof(b.x) == typeof(PositionField(nothing, nothing, false))
        @test typeof(b.v₀) == typeof(VelocityField(1.0, m/s, m, s, false))
        @test typeof(b.v) == typeof(VelocityField(1.0, m/s, m, s, false))
        @test typeof(b.v̄) == typeof(VelocityField(nothing, nothing, nothing, nothing, false))
        @test typeof(b.t) == typeof(TimeField(1.0, s, false))
        @test typeof(b.a) == typeof(AccelerationField(nothing, m/s^2, m, s, true))
    end
end

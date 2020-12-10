push!(LOAD_PATH, "/home/jake/dev/data/src/SolveDash/experiment/")
using Test
using MyFields
import Unitful:
    mm, cm, m, km, inch, ft, yd, mi,
    ns, μs, ms, s, minute, hr, wk, yr,
    ustrip, @u_str

@testset "field creation" begin
    # PositionField
    p = PositionField(float(1), mi, false)
    pu = PositionField(1.0, u"mi", false)
    pn = PositionField(nothing, nothing, false)
    # TimeField
    t = TimeField(float(1), hr, false)
    tu = TimeField(1.0, u"hr", false)
    tn = TimeField(nothing, nothing, false)
    # VelocityField
    v = VelocityField(float(42), mi/hr, mi, hr, true)
    vu = VelocityField(42.0, u"mi"/u"hr", u"mi", u"hr", true)
    vn = VelocityField(nothing, nothing, nothing, nothing, true)
    # AccelerationField
    a = AccelerationField(float(5), ft/s^2, ft, s, true)
    au = AccelerationField(5.0, u"ft"/u"s^2", u"ft", u"s", true)
    an = AccelerationField(nothing, nothing, nothing, nothing, true)

    @testset "position freeunit assignment" begin
        @test p.val == 1
        @test p.unit == mi
        @test !p.find
        @test unify!(p) == 1609.344
    end
    @testset "time freeunit assignment" begin
        @test t.val == 1
        @test t.unit == hr
        @test !t.find
        @test unify!(t) == 3600
    end
    @testset "velocity freeunit assignment" begin
        @test v.val == 42
        @test v.unit == mi/hr
        @test v.lu == mi
        @test v.tu == hr
        @test v.find
        @test unify!(v) == 18.77568
    end
    @testset "acceleration freeunit assignment" begin
        @test a.val == 5
        @test a.unit == ft/s^2
        @test a.lu == ft
        @test a.tu == s
        @test a.find
        @test unify!(a) == 1.524
    end
    @testset "position ustring assignment" begin
        @test pu.val == 1
        @test pu.unit == mi
        @test !pu.find
        @test unify!(pu) == 1609.344
    end
    @testset "time ustring assignment" begin
        @test tu.val == 1
        @test tu.unit == hr
        @test !tu.find
        @test unify!(tu) == 3600
    end
    @testset "velocity ustring assignment" begin
        @test vu.val == 42
        @test vu.unit == mi/hr
        @test vu.lu == mi
        @test vu.tu == hr
        @test vu.find
        @test unify!(vu) == 18.77568
    end
    @testset "acceleration ustring assignment" begin
        @test au.val == 5
        @test au.unit == ft/s^2
        @test au.lu == ft
        @test au.tu == s
        @test au.find
        @test unify!(au) == 1.524
    end
    @testset "position nothing assignment" begin
        @test isnothing(pn.val) &&
              isnothing(pn.unit) && !pn.find
    end
    @testset "time nothing assignment" begin
        @test isnothing(tn.val) &&
              isnothing(tn.unit) && !tn.find
    end
    @testset "velocity nothing assignment" begin
        @test isnothing(vn.val) &&
              isnothing(vn.unit) &&
              isnothing(vn.lu) &&
              isnothing(vn.tu) && vn.find
    end
    @testset "acceleration nothing assignment" begin
        @test isnothing(an.val) &&
              isnothing(an.unit) &&
              isnothing(an.lu) &&
              isnothing(an.tu) && an.find
    end
end

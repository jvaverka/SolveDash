push!(LOAD_PATH, "/home/jake/dev/data/src/SolveDash/experiment/")
using Test
using MyFields
import Unitful:
    mm, cm, m, km, inch, ft, yd, mi,
    ns, μs, ms, s, minute, hr, wk, yr,
    ustrip, @u_str

@testset "field creation" begin
    # PositionField
    p = PositionField(1mi, mi, false)
    pu = PositionField(1u"mi", u"mi", false)
    pn = PositionField(nothing, nothing, false)
    # TimeField
    t = TimeField(1hr, hr, false)
    tu = TimeField(1u"hr", u"hr", false)
    tn = TimeField(nothing, nothing, false)
    # VelocityField
    v = VelocityField(42mi/hr, mi/hr, mi, hr, true)
    vu = VelocityField(42u"mi"/u"hr", u"mi"/u"hr", u"mi", u"hr", true)
    vn = VelocityField(nothing, nothing, nothing, nothing, true)
    # AccelerationField
    a = AccelerationField(5ft/s^2, ft/s^2, ft, s, true)
    au = AccelerationField(5u"ft"/u"s^2", u"ft"/u"s^2", u"ft", u"s", true)
    an = AccelerationField(nothing, nothing, nothing, nothing, true)

    @testset "position freeunit assignment" begin
        @test p.val |> ustrip == 1
        @test p.unit == mi
        @test p.find == false
    end
    @testset "time freeunit assignment" begin
        @test t.val |> ustrip == 1
        @test t.unit == hr
        @test t.find == false
    end
    @testset "velocity freeunit assignment" begin
        @test v.val |> ustrip == 42
        @test v.unit == mi/hr
        @test v.lu == mi
        @test v.tu == hr
        @test v.find == true
    end
    @testset "acceleration freeunit assignment" begin
        @test a.val |> ustrip == 5
        @test a.unit == ft/s^2
        @test a.lu == ft
        @test a.tu == s
        @test a.find == true
    end
    @testset "position ustring assignment" begin
        @test pu.val |> ustrip == 1
        @test pu.unit == mi
        @test pu.find == false
    end
    @testset "time ustring assignment" begin
        @test tu.val |> ustrip == 1
        @test tu.unit == hr
        @test tu.find == false
    end
    @testset "velocity ustring assignment" begin
        @test vu.val |> ustrip == 42
        @test vu.unit == mi/hr
        @test vu.lu == mi
        @test vu.tu == hr
        @test vu.find == true
    end
    @testset "acceleration ustring assignment" begin
        @test au.val |> ustrip == 5
        @test au.unit == ft/s^2
        @test au.lu == ft
        @test au.tu == s
        @test au.find == true
    end
    @testset "position nothing assignment" begin
        @test isnothing(pn.val)  && isnothing(pn.unit) && !pn.find == true
    end
    @testset "time nothing assignment" begin
        @test isnothing(tn.val)  && isnothing(tn.unit) && !tn.find == true
    end
    @testset "velocity nothing assignment" begin
        @test isnothing(vn.val) && isnothing(vn.unit) && isnothing(vn.lu) && isnothing(vn.tu) && vn.find
    end
    @testset "acceleration nothing assignment" begin
        @test isnothing(an.val) && isnothing(an.unit) && isnothing(an.lu) && isnothing(an.tu) && an.find
    end
end

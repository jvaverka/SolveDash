using Test

@testset "SolveDashApp" begin
    @testset "Fields" begin include("MyFieldsTest.jl"); end
    @testset "Conditions" begin include("MyConditionsTest.jl"); end
    @testset "Solver" begin include("MySolverTest.jl"); end
    @testset "Solutions" begin include("MySolutionTest.jl"); end
end

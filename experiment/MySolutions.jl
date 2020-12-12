module MySolutions

using MyConditions
export AbstractSolutionSet, BaseSolutionSet, populate!, issolved

mutable struct SomeSolution
    value
    SomeSolution(v=nothing) = new(v)
end

abstract type AbstractSolutionSet end

mutable struct BaseSolutionSet <: AbstractSolutionSet
    x₀
    x
    v₀
    v
    v̄
    t
    a
    function BaseSolutionSet(
        x₀=SomeSolution(),
        x=SomeSolution(),
        v₀=SomeSolution(),
        v=SomeSolution(),
        v̄=SomeSolution(),
        t=SomeSolution(),
        a=SomeSolution())
        new(x₀,x,v₀,v,v̄,t,a)
    end
end

function populate!(b::BaseSolutionSet, a::MyConditions.BaseConditions)
    b.x₀ = a.x₀.val
    b.x = a.x.val
    b.v₀ = a.v₀.val
    b.v = a.v.val
    b.v̄ = a.v̄.val
    b.t = a.t.val
    b.a = a.a.val
end

function issolved(s::BaseSolutionSet)
    !isnothing(s.x₀) && !isnothing(s.x) && !isnothing(s.v₀) &&
    !isnothing(s.v) && !isnothing(s.v̄) && !isnothing(s.t) &&
    !isnothing(s.a)
end

end  # module MySolutions

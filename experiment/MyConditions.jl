module MyConditions

using MyFields
using Parameters

export BaseConditions, OneDKinematicConditions, TwoDKinematicConditions,
    unify_conditions!

abstract type AbstractConditions end

mutable struct BaseConditions <: AbstractConditions
    x₀::MyFields.PositionField
    x::MyFields.PositionField
    v₀::MyFields.VelocityField
    v::MyFields.VelocityField
    v̄::MyFields.VelocityField
    t::MyFields.TimeField
    a::MyFields.AccelerationField
end

mutable struct OneDKinematicConditions <: AbstractConditions
    x₀::MyFields.PositionField
    x::MyFields.PositionField
    v₀::MyFields.VelocityField
    v::MyFields.VelocityField
    v̄::MyFields.VelocityField
    t::MyFields.TimeField
    a::MyFields.AccelerationField
end

mutable struct TwoDKinematicConditions <: AbstractConditions
    x₀::MyFields.PositionField
    x::MyFields.PositionField
    v₀::MyFields.VelocityField
    v::MyFields.VelocityField
    v̄::MyFields.VelocityField
    t::MyFields.TimeField
    a::MyFields.AccelerationField
end

" Unify all |AbstractFields| in a given set of |AbstractConditions| "
function unify_conditions!(ic::T) where T<:AbstractConditions
    unify_conditions!(ic)
end

" Unify all |AbstractFields| in a given set of |BaseConditions| "
function unify_conditions!(ic::BaseConditions)
    @unpack x₀, x, v₀, v, v̄, t, a = ic
    unify!([x₀, x, v₀, v, v̄, t, a])
end

" Unify all |AbstractFields| in a given set of |OneDKinematicConditions| "
function unify_conditions!(ic::OneDKinematicConditions)
    @unpack x₀, x, v₀, v, v̄, t, a = ic
    unify!([x₀, x, v₀, v, v̄, t, a])
end

" Unify all |AbstractFields| in a given set of |TwoDKinematicConditions| "
function unify_conditions!(ic::TwoDKinematicConditions)
    @unpack x₀, x, v₀, v, v̄, t, a = ic
    unify!([x₀, x, v₀, v, v̄, t, a])
end

end # module MyConditions

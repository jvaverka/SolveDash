module MyConditions

using MyFields

export BaseConditions, OneDKinematicConditions, TwoDKinematicConditions

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

end
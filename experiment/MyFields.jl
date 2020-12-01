module MyFields

using Unitful

export AbstractField, PositionField, TimeField, VelocityField, AccelerationField

abstract type AbstractField end

mutable struct PositionField{V,U<:Union{Unitful.FreeUnits,Nothing},F<:Bool} <: AbstractField
    val::V
    unit::U
    find::F
end

mutable struct TimeField{V,U<:Union{Unitful.FreeUnits,Nothing},F<:Bool} <: AbstractField
    val::V
    unit::U
    find::F
end

mutable struct VelocityField{
    V,
    U<:Union{Unitful.FreeUnits,Nothing},
    L<:Union{Unitful.LengthFreeUnits,Nothing},
    T<:Union{Unitful.TimeFreeUnits,Nothing},
    F<:Bool,
} <: AbstractField

    val::V
    unit::U
    lu::L
    tu::T
    find::F
end

mutable struct AccelerationField{
    V,
    U<:Union{Unitful.FreeUnits,Nothing},
    L<:Union{Unitful.LengthFreeUnits,Nothing},
    T<:Union{Unitful.TimeFreeUnits,Nothing},
    F<:Bool,
} <: AbstractField

    val::V
    unit::U
    lu::L
    tu::T  # where timeunit has dimension of 1
    find::F
end

end  # module MyFields

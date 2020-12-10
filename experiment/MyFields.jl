module MyFields

using Unitful
import Unitful: m, s

export AbstractField,
    PositionField, TimeField, VelocityField, AccelerationField, unify!

abstract type AbstractField end

mutable struct PositionField{
    V<:Union{Float64,Nothing},
    U<:Union{Unitful.FreeUnits,Nothing},
    F<:Bool
    } <: AbstractField

    val::V
    unit::U
    find::F
end

mutable struct TimeField{
    V<:Union{Float64,Nothing},
    U<:Union{Unitful.FreeUnits,Nothing},
    F<:Bool
    } <: AbstractField

    val::V
    unit::U
    find::F
end

mutable struct VelocityField{
    V<:Union{Float64,Nothing},
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
    V<:Union{Float64,Nothing},
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

" Unify all |AbstractFields| in a given list "
unify!(v::Vector{<:AbstractField}) = [unify!(x) for x ∈ v if !isnothing(x.val)]

" Convert |TimeField| from given units to |seconds| "
unify!(f::TimeField) = setfield!(f,:val,f.val*f.unit|> s|> ustrip)

" Convert |PositionField| from given units to |meters| "
unify!(f::PositionField) = setfield!(f,:val,f.val*f.unit|> m|> ustrip)

" Convert |VelocityField| from given units to |meters per seconds| "
unify!(f::VelocityField) = setfield!(f,:val,f.val*f.unit|> m/s|> ustrip)

" Convert |AccelerationField| from given units to |meters per seconds²| "
unify!(f::AccelerationField) = setfield!(f,:val,f.val*f.unit|> m/s^2|> ustrip)

end  # module MyFields

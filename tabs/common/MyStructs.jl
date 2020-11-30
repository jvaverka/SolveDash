module MyStructs

using Unitful

export PositionStruct, TimeStruct, VelocityStruct, AccelerationStruct

mutable struct PositionStruct{V,U<:Unitful.FreeUnits,F<:Bool}
    v::V
    u::U
    find::F
end

mutable struct TimeStruct{V,U<:Unitful.FreeUnits,F<:Bool}
    v::V
    u::U
    find::F
end

mutable struct VelocityStruct{
    V,
    U<:Unitful.FreeUnits,
    L<:Unitful.LengthFreeUnits,
    T<:Unitful.TimeFreeUnits,
    F<:Bool,
}
    v::V
    u::U
    lu::L
    tu::T
    find::F
end

mutable struct AccelerationStruct{
    V,
    U<:Unitful.FreeUnits,
    L<:Unitful.LengthFreeUnits,
    T<:Unitful.TimeFreeUnits,
    F<:Bool,
}
    v::V
    u::U
    lu::L
    tu::T
    find::F
end

end  # module MyStructs

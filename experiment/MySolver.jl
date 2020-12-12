module MySolver

include("MyConditions.jl")
include("MyFields.jl")
using Parameters
using Unitful

export mysolve, # solver
    find_acceleration, find_time, find_average_velocity, find_velocity,  # eq
    find_initial_velocity, find_final_position, find_initial_position,  # eq
    revert_units, hasunit, hasvalue  # utilities


function mysolve(ic::MyConditions.BaseConditions)

    sol = BaseSolutionSet()
    populate!(sol,ic)
    niter = 0

    @unpack x₀, x, v₀, v, v̄, t, a = ic
    unify!([x₀, x, v₀, v, v̄, t, a])

    while !issolved(sol) || niter < 3
        if a.find && isnothing(a.val)
            if !hasunit(a)
                sol.a = nothing
            elseif hasvalue([v,v₀,t])
                sol.a = find_acceleration(v,v₀,t)* u"m"/u"s^2" |> a.unit
            elseif hasvalue([x₀,x,v₀,t])
                sol.a = find_acceleration(x,x₀,v₀,t)* u"m"/u"s^2" |> a.unit
            elseif hasvalue([v,v₀,x,x₀])
                sol.a = find_acceleration(v,v₀,x,x₀)* u"m"/u"s^2" |> a.unit
            else
                sol.a = nothing
            end
            if !isnothing(sol.a)
                a.find = false
            end
        end
        if t.find && isnothing(t.val)
            if !hasunit(t)
                sol.t = nothing
            elseif hasvalue([v,v₀,a])
                sol.t = find_time(v,v₀,a)* u"s" |> t.unit
            elseif hasvalue([x,x₀,v̄])
                sol.t = find_time(x,x₀,v̄)* u"s" |> t.unit
            elseif hasvalue([v,v₀,a])
                sol.t = find_time(v,v₀,a)* u"s" |> t.unit
            else
                sol.t = nothing
            end
            if !isnothing(sol.t)
                t.find = false
            end
        end
        if v̄.find && isnothing(v̄.val)
            if !hasunit(v̄)
                sol.v̄ = nothing
            elseif hasvalue([x,x₀,t])
                sol.v̄ = find_average_velocity(x,x₀,t)*u"m"/u"s" |> v̄.unit
            elseif hasvalue([v,v₀,t])
                sol.v̄ = find_average_velocity(v,v₀,t)*u"m"/u"s" |> v̄.unit
            else
                sol.v̄ = nothing
            end
            if !isnothing(sol.v̄)
                v̄.find = false
            end
        end
        if v.find && isnothing(v.val)
            if !hasunit(v)
                sol.v = nothing
            elseif hasvalue([v₀,a,t])
                sol.v = find_velocity(v₀,a,t)* u"m"/u"s" |> v.unit
            elseif hasvalue([v₀,a,x,x₀])
                sol.v = find_velocity(v₀,a,x,x₀)* u"m"/u"s" |> v.unit
            elseif hasvalue([x,x₀,v₀,t])
                sol.v = find_velocity(x,x₀,v₀,t)* u"m"/u"s" |> v.unit
            else
                sol.v = "not enough info to solve"
            end
            if !isnothing(sol.v)
                v.find = false
            end
        end
        if v₀.find && isnothing(v₀.val)
            if !hasunit(v₀)
                sol.v₀ = nothing
            elseif hasvalue([v̄,v,t])
                sol.v₀ = find_initial_velocity(v̄,v,t)* u"m"/u"s" |> v₀.unit
            elseif hasvalue([v,a,t])
                sol.v₀ = find_initial_velocity(v,a,t)* u"m"/u"s" |> v₀.unit
            elseif hasvalue([v,a,x,x₀])
                sol.v₀ = find_initial_velocity(v,a,x,x₀)* u"m"/u"s" |> v₀.unit
            elseif hasvalue([x,x₀,t,a])
                sol.v₀ = find_initial_velocity(x,x₀,t,a)* u"m"/u"s" |> v₀.unit
            elseif hasvalue([x,x₀,v,t])
                sol.v₀ = find_initial_velocity(x,x₀,v,t)* u"m"/u"s" |> v₀.unit
            else
                sol.v₀ = nothing
            end
            if !isnothing(sol.v₀)
                v₀.find = false
            end
        end
        if x.find && isnothing(x.val)
            if !hasunit(x)
                sol.x = nothing
            elseif hasvalue([v̄,x₀,t])
                sol.x = find_final_position(v̄,x₀,t)* u"m" |> x.unit
            elseif hasvalue([v,v₀,a,x₀])
                sol.x = find_final_position(v,v₀,a,x₀)* u"m" |> x.unit
            elseif hasvalue([x₀,v₀,t,a])
                sol.x = find_final_position(x₀,v₀,t,a)* u"m" |> x.unit
            elseif hasvalue([x₀,v₀,v,t])
                sol.x = find_final_position(x₀,v₀,v,t)* u"m" |> x.unit
            else
                sol.x = nothing
            end
            if !isnothing(sol.x)
                x.find = false
            end
        end
        if x₀.find && isnothing(x₀.val)
            if !hasunit(x₀)
                sol.x₀ = nothing
            elseif hasvalue([v̄,x,t])
                sol.x₀ = find_initial_position(v̄,x,t)* u"m" |> x₀.unit
            elseif hasvalue([v,v₀,a,x])
                sol.x₀ = find_initial_position(v,v₀,a,x)* u"m" |> x₀.unit
            elseif hasvalue([x,v₀,t,a])
                sol.x₀ = find_initial_position(x,v₀,t,a)* u"m" |> x₀.unit
            elseif hasvalue([x,v₀,v,t])
                sol.x₀ = find_initial_position(x,v₀,v,t)* u"m" |> x₀.unit
            else
                sol.x₀ = "not enough info to solve"
            end
            if !isnothing(sol.x₀)
                x₀.find = false
            end
        end
        niter += 1
    end
    sol
end # function mysolve
# Solver Equations ###################################
" vₓ = vₓ₀ + aₓt "
function find_acceleration(
    v::MyFields.VelocityField,
    v₀::MyFields.VelocityField,
    t::MyFields.TimeField)
    (v.val - v₀.val) / t.val
end
" x = x₀ + vₓ₀t + (1//2)aₓt² "
function find_acceleration(
    x::MyFields.PositionField,
    x₀::MyFields.PositionField,
    v₀::MyFields.VelocityField,
    t::MyFields.TimeField)
    (2*(x.val - x₀.val - v₀.val*t.val))/t.val^2
end
" vₓ² = vₓ₀² + 2aₓ𝚫x "
function find_acceleration(
    v::MyFields.VelocityField,
    v₀::MyFields.VelocityField,
    x::MyFields.PositionField,
    x₀::MyFields.PositionField)
    (v.val^2 - v₀.val^2) / (2 * (x.val - x₀.val))
end
" vₓ = vₓ₀ + aₓt "
function find_time(
    v::MyFields.VelocityField,
    v₀::MyFields.VelocityField,
    a::MyFields.AccelerationField)
    (v.val - v₀.val) / a.val
end
" v̄ = 𝚫x/𝚫t "
function find_time(
    x::MyFields.PositionField,
    x₀::MyFields.PositionField,
    v̄::MyFields.VelocityField)
    (x.val - x₀.val) / v̄.val
end
" a = 𝚫v/𝚫t "
function find_time(
    v::MyFields.VelocityField,
    v₀::MyFields.VelocityField,
    a::MyFields.AccelerationField)
    (v.val - v₀.val) / a.val
end
" v̄ = 𝚫x/t "
function find_average_velocity(
    x::MyFields.PositionField,
    x₀::MyFields.PositionField,
    t::MyFields.TimeField)
    (x.val - x₀.val) / t.val
end
" v̄ = 𝚫v/t "
function find_average_velocity(
    v::MyFields.VelocityField,
    v₀::MyFields.VelocityField,
    t::MyFields.TimeField)
    (v.val - v₀.val) / t.val
end
" v = v₀ + at "
function find_velocity(
    v₀::MyFields.VelocityField,
    a::MyFields.AccelerationField,
    t::MyFields.TimeField)
    v₀.val + a.val*t.val
end
" v² = v₀² + 2a𝚫x "
function find_velocity(
    v₀::MyFields.VelocityField,
    a::MyFields.AccelerationField,
    x::MyFields.PositionField,
    x₀::MyFields.PositionField)
    √(v₀.val^2 + a.val*(x.val - x₀.val))
end
" 𝚫x = ((v₀+v)/2)t "
function find_velocity(
    x::MyFields.PositionField,
    x₀::MyFields.PositionField,
    v₀::MyFields.VelocityField,
    t::MyFields.TimeField)
    2*((x.val-x₀.val)/t.val) - v₀.val
end
" v̄ = (v₀+v)/t "
function find_initial_velocity(
    v̄::MyFields.VelocityField,
    v::MyFields.VelocityField,
    t::MyFields.TimeField)
    v̄.val*t.val - v.val
end
" v = v₀ + at "
function find_initial_velocity(
    v::MyFields.VelocityField,
    a::MyFields.AccelerationField,
    t::MyFields.TimeField)
    v.val - a.val*t.val
end
" v² = v₀² + 2a𝚫x "
function find_initial_velocity(
    v::MyFields.VelocityField,
    a::MyFields.AccelerationField,
    x::MyFields.PositionField,
    x₀::MyFields.PositionField)
    √(v.val^2 - 2*a.val*(x.val-x₀.val))
end
" 𝚫x = v₀t + 0.5at² "
function find_initial_velocity(
    x::MyFields.PositionField,
    x₀::MyFields.PositionField,
    t::MyFields.TimeField,
    a::MyFields.AccelerationField)
    ((x.val - x₀.val) - 0.5*a.val*t.val^2) / t.val
end
" 𝚫x = ((v₀+v)/2)*t "
function find_initial_velocity(
    x::MyFields.PositionField,
    x₀::MyFields.PositionField,
    v::MyFields.VelocityField,
    t::MyFields.TimeField)
    (2*(x.val-x₀.val)/t.val) - v.val
end
" v̄ = 𝚫x/t "
function find_final_position(
    v̄::MyFields.VelocityField,
    x₀::MyFields.PositionField,
    t::MyFields.TimeField)
    v̄.val*t.val + x₀.val
end
" v² = v₀² + 2a𝚫x "
function find_final_position(
    v::MyFields.VelocityField,
    v₀::MyFields.VelocityField,
    a::MyFields.AccelerationField,
    x₀::MyFields.PositionField)
    ((v.val^2 - v₀.val^2)/(2*a.val)) + x₀.val
end
" 𝚫x = v₀t + 0.5at² "
function find_final_position(
    x₀::MyFields.PositionField,
    v₀::MyFields.VelocityField,
    t::MyFields.TimeField,
    a::MyFields.AccelerationField)
    v₀.val*t.val + 0.5*a.val*t.val^2 + x₀.val
end
" 𝚫x = ((v₀+v)/2)t "
function find_final_position(
    x₀::MyFields.PositionField,
    v₀::MyFields.VelocityField,
    v::MyFields.VelocityField,
    t::MyFields.TimeField)
    ((v₀.val+v.val)/2)*t.val + x₀.val
end
" v̄ = 𝚫x/t "
function find_initial_position(
    v̄::MyFields.VelocityField,
    x::MyFields.PositionField,
    t::MyFields.TimeField)
    x.val - v̄.val*t.val
end
" v² = v₀² + 2a𝚫x "
function find_initial_position(
    v::MyFields.VelocityField,
    v₀::MyFields.VelocityField,
    a::MyFields.AccelerationField,
    x::MyFields.PositionField)
    x.val - ((v.val^2 - v₀.val^2)/(2*a.val))
end
" 𝚫x = v₀t + 0.5at² "
function find_initial_position(
    x::MyFields.PositionField,
    v₀::MyFields.VelocityField,
    t::MyFields.TimeField,
    a::MyFields.AccelerationField)
    x.val - (v₀.val*t.val + 0.5*a.val*t.val^2)
end
" 𝚫x = ((v₀+v)/2)t "
function find_initial_position(
    x::MyFields.PositionField,
    v₀::MyFields.VelocityField,
    v::MyFields.VelocityField,
    t::MyFields.TimeField)
    x.val - ((v₀.val+v.val)/2)*t.val
end
# Solver Utilities ###################################
" Revert field value back to original units "
function revert_units(field::T) where T<:MyFields.AbstractField
    field.val * field.unit
end
" Ensure all fields in a given list have units "
function hasunit(fields::Vector{<:MyFields.AbstractField})
    for f ∈ fields
        if isnothing(f.unit)
            return false
        end
    end
    return true
end
" Ensure all fields in a given list have values "
function hasvalue(fields::Vector{<:MyFields.AbstractField})
    for f ∈ fields
        if isnothing(f.val)
            return false
        end
    end
    return true
end

end # MySolver

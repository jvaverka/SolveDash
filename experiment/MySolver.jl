module MySolver

using MyConditions
using MyFields
using Parameters


export mysolve, find_acceleration, revert_units, hasunit, hasvalue

function mysolve(ic::MyConditions.BaseConditions)

    solns = Dict()
    @unpack x₀, x, v₀, v, v̄, t, a = ic
    unify!([x₀, x, v₀, v, v̄, t, a])

    if a.find
        acc_soln = ""
        if !hasunit(a)
            acc_soln = "missing unit"
        elseif hasvalue([v,v₀,t])
            acc_soln = find_acceleration(v,v₀,t)*a.unit
        elseif hasvalue([x₀,x,v₀,t])
            acc_soln = find_acceleration(x,x₀,v₀,t)*a.unit
        elseif hasvalue([v,v₀,x,x₀])
            acc_soln = find_acceleration(v,v₀,x,x₀)*a.unit
        else
            acc_soln = "not enough info to solve"
        end
        solns["acceleration"] = acc_soln
    end
    if t.find
        time_soln = ""
        if !hasunit(t)
            time_soln = "missing unit"
        elseif hasvalue([v,v₀,a])
            time_soln = find_time(v,v₀,a)*t.unit
        elseif hasvalue([x,x₀,v̄])
            time_soln = find_time(x,x₀,v̄)*t.unit
        elseif hasvalue([v,v₀,a])
            time_soln = find_time(v,v₀,a)*t.unit
        else
            time_soln = "not enough info to solve"
        end
        solns["time"] = time_soln
    end
    if v̄.find
        avel_soln = ""
        if !hasunit(v̄)
            avel_soln = "missing unit"
        elseif hasvalue([x,x₀,t])
            avel_soln = find_average_velocity(x,x₀,t)*v̄.unit
        elseif hasvalue([v,v₀,t])
            avel_soln = find_average_velocity(v,v₀,t)*v̄.unit
        else
            avel_soln = "not enough info to solve"
        end
        solns["average_velocity"] = avel_soln
    end
    if v.find
        fvel_soln = ""
        if !hasunit(v)
            fvel_soln = "missing unit"
        elseif hasvalue([v₀,a,t])
            fvel_soln = find_velocity(v₀,a,t)*v.unit
        elseif hasvalue([v₀,a,x,x₀])
            fvel_soln = find_velocity(v₀,a,x,x₀)*v.unit
        elseif hasvalue([x,v₀,t])
            fvel_soln = find_velocity(x,v₀,t)*v.unit
        else
            fvel_soln = "not enough info to solve"
        end
        solns["final_velocity"] = fvel_soln
    end
    if v₀.find
        ivel_soln = ""
        if !hasunit(v₀)
            ivel_soln = "missing unit"
        elseif hasvalue([v̄,v,t])
            ivel_soln = find_initial_velocity(v̄,v,t)
        elseif hasvalue([v,a,t])
            ivel_soln = find_initial_velocity(v,a,t)
        elseif hasvalue([v,a,x,x₀])
            ivel_soln = find_initial_velocity(v,a,x,x₀)
        elseif hasvalue([x,x₀,t,a])
            ivel_soln = find_initial_velocity(x,x₀,t,a)
        elseif hasvalue([x,x₀,v,t])
            ivel_soln = find_initial_velocity(x,x₀,v,t)
        else
            ivel_soln = "not enough info to solve"
        end
        solns["initial_velocity"] = ivel_soln
    end
    if x.find
        fpos_soln = ""
        if !hasunit(x)
            fpos_soln = "missing unit"
        elseif hasvalue([v̄,x₀,t])
            fpos_soln = find_final_position(v̄,x₀,t)
        elseif hasvalue([v,v₀,a,x₀])
            fpos_soln = find_final_position(v,v₀,a,x₀)
        elseif hasvalue([x₀,v₀,t,a])
            fpos_soln = find_final_position(x₀,v₀,t,a)
        elseif hasvalue([x₀,v₀,v,t])
            fpos_soln = find_final_position(x₀,v₀,v,t)
        end
        solns["final_position"] = fpos_soln
    end
    if x₀.find
        # solve for initial position
    end
end

" vₓ = vₓ₀ + aₓt "
function find_acceleration(
    v::VelocityField,
    v₀::VelocityField,
    t::TimeField)
    (v.val - v₀.val) / t.val
end

" x = x₀ + vₓ₀t + (1//2)aₓt² "
function find_acceleration(
    x::PositionField,
    x₀::PositionField,
    v₀::VelocityField,
    t::TimeField)
    (2*(x.val - x₀.val - v₀.val*t.val))/t.val^2
end

" vₓ² = vₓ₀² + 2aₓ(x - x₀) "
function find_acceleration(
    v::VelocityField,
    v₀::VelocityField,
    x::PositionField,
    x₀::PositionField)
    (v.val^2 - v₀.val^2) / (2 * (x.val - x₀.val))
end

" vₓ = vₓ₀ + aₓt "
function find_time(v::VelocityField,v₀::VelocityField,a::AccelerationField)
    (v.val - v₀.val) / a.val
end

" v̄ = δx/δt "
function find_time(x::PositionField,x₀::PositionField,v̄::VelocityField)
    (x.val - x₀.val) / v̄.val
end

" a = δv/δt "
function find_time(v::VelocityField,v₀::VelocityField,a::AccelerationField)
    (v.val - v₀.val) / a.val
end

" v̄ = δx/t "
function find_average_velocity(x::PositionField,x₀::PositionField,t::TimeField)
    (x.val - x₀.val) / t.val
end

" v̄ = δv/t "
function find_average_velocity(v::VelocityField,v₀::VelocityField,t::TimeField)
    (v.val - v₀.val) / t.val
end

" v = v₀ + at "
function find_velocity(v₀::VelocityField,a::AccelerationField,t::TimeField)
    v₀.val + a.val*t.val
end

" v² = v₀² + aδx "
function find_velocity(
    v₀::VelocityField,
    a::AccelerationField,
    x::PositionField,
    x₀::PositionField)
    √(v₀.val^2 + a.val*(x.val - x₀.val))
end

" x = ((v₀+v)/2)t "
function find_velocity(x::PositionField,v₀::VelocityField,t::TimeField)
    2*(x.val/t.val) - v₀
end

" v̄ = (v₀+v)/t "
function find_initial_velocity(v̄::VelocityField,v::VelocityField,t::TimeField)
    v̄.val*t.val - v.val
end

" v = v₀ + at "
function find_initial_velocity(v::VelocityField,a::AccelerationField,t::TimeField)
    v.val - a.val*t.val
end

" v² = v₀² + 2aδx "
function find_initial_velocity(
    v::VelocityField,
    a::AccelerationField,
    x::PositionField,
    x₀::PositionField)
    √(v.val^2 - 2*a.val*(x.val-x₀.val))
end

" δx = v₀t + 0.5at² "
function find_initial_velocity(
    x::PositionField,
    x₀::PositionField,
    t::TimeField,
    a::AccelerationField)
    ((x.val - x₀.val) - 0.5*a.val*t.val^2) / t.val
end

" δx = ((v₀+v)/2)*t "
function find_initial_velocity(
    x::PositionField,
    x₀::PositionField,
    v::VelocityField
    t::TimeField)
    (2*(x.val-x₀.val)/t.val) - v.val
end

" v̄ = δx/t "
function find_final_position(v̄::VelocityField,x₀::PositionField,t::TimeField)
    v̄.val*t.val + x₀.val
end

" v² = v₀² + 2aδx "
function find_final_position(
    v::VelocityField,
    v₀::VeloctiyField,
    a::AccelerationField,
    x₀::PositionField)
    ((v.val^2 - v₀.val^2)/(2*a.val)) + x₀.val
end

" δx = v₀t + 0.5at² "
function find_final_position(
    x₀::PositionField,
    v₀::VelocityField,
    t::TimeField,
    a::AccelerationField)
    v₀.val*t.val + 0.5*a.val*t.val^2 + x₀.val
end

" δx = ((v₀+v)/2)t "
function find_final_position(
    x₀::PositionField,
    v₀::VelocityField,
    v::VelocityField,
    t::TimeField)
    ((v₀.val+v.val)/2)*t + x₀.val
end

" Revert field value back to original units "
function revert_units(field::T) where T<:AbstractField
    field.val * field.unit
end

" Ensure all fields in a given list have units "
function hasunit(fields::Vector{<:AbstractField})
    for f ∈ fields
        if isnothing(f.unit)
            return false
        end
    end
    return true
end

" Ensure all fields in a given list have values "
function hasvalue(fields::Vector{<:AbstractField})
    for f ∈ fields
        if isnothing(f.val)
            return false
        end
    end
    return true
end

end # MySolver

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
        elseif hasvalue([v, v₀, t])
            acc_soln = find_acceleration(v,v₀,t)*a.unit
        elseif hasvalue([x₀, x, v₀, t])
            acc_soln = find_acceleration(x,x₀,v₀,t)*a.unit
        elseif hasvalue([v, v₀, x, x₀])
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
        elseif hasvalue([v, v₀, a])
            time_soln = find_time(v, v₀, a)*t.unit
        else
            time_soln = "not enough info to solve"
        end
        solns["time"] = time_soln
    end
    if v̄.find
        # solve for average velocity
    end
    if v.find
        # solve for final velocity
    end
    if v₀.find
        # solve for initial velocity
    end
    if x.find
        # solve for final position
    end
    if x₀.find
        # solve for initial position
    end
end

" vₓ = vₓ₀ + aₓt "
function find_acceleration(
    v::VelocityField,
    v₀::VelocityField,
    t::TimeField,
    )

    (v.val - v₀.val) / t.val
end

" x = x₀ + vₓ₀t + (1//2)aₓt² "
function find_acceleration(
    x::PositionField,
    x₀::PositionField,
    v₀::VelocityField,
    t::TimeField,
    )

    (2*(x.val - x₀.val - v₀.val*t.val))/t.val^2
end

" vₓ² = vₓ₀² + 2aₓ(x - x₀) "
function find_acceleration(
    v::VelocityField,
    v₀::VelocityField,
    x::PositionField,
    x₀::PositionField,
)
    (v.val^2 - v₀.val^2) / (2 * (x.val - x₀.val))
end

" vₓ = vₓ₀ + aₓt "
function find_time(v::VelocityField, v₀::VelocityField, a::AccelerationField)
    (v.val - v₀.val) / a.val
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

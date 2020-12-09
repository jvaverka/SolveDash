module MySolver
   
using MyConditions
using MyFields
using Parameters


export solver_base, find_acceleration, convert_field_value!, convert_field_values!, revert_units!, hasunit, hasvalue

function solver_base(ic::MyConditions.BaseConditions)
    
    @unpack x₀, x, v₀, v, v̄, t, a = ic

    solns = Dict()

    if a.find
        if hasvalue([v, v₀, t]) && hasunit([v, v₀, t])
            convert_field_values!([v, v₀, t], a)
            solns["acceleration"] = find_acceleration(v, v₀, t)
        end
        if hasvalue([x₀, x, v₀, t]) && hasunit([x₀, x, v₀, t])
            convert_field_values!([x₀, x, v₀, t], a)
            solns["acceleration"] = find_acceleration(x, x₀, v₀, t)
        end
        if hasvalue([v, v₀, x, x₀]) && hasunit([v, v₀, x, x₀])
            convert_field_values!([v, v₀, x, x₀], a)
            solns["acceleration"] = find_acceleration(v, v₀, x, x₀)
        end
    end
    if t.find
        if hasvalue([v, v₀, a]) && hasunit([v, v₀, a])
            convert_field_values!([v, v₀, a], t)
        end
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

" Convert field values for all fields in a given vector "
function convert_field_values!(fields::Vector{<:AbstractField}, target::T) where T<:AbstractField
    for field ∈ fields
        convert_field_value!(field, target)
    end
end

" Convert PositionField units to match AccelerationField "
function convert_field_value!(p::PositionField, a::AccelerationField)
    setfield!(p, :val, p.val |> a.lu)
end

" Convert TimeField units to match AccelerationField "
function convert_field_value!(t::TimeField, a::AccelerationField)
    setfield!(t, :val, t.val |> a.tu)
end

" Convert VelocityField units to match AccelerationField "
function convert_field_value!(v::VelocityField, a::AccelerationField)
    setfield!(v, :val, v.val |> a.lu/a.tu)
end

" Convert VelocityField units to match TimeField "
function convert_field_value!(v::VelocityField, t::TimeField)
    setfield!(v, :val, v.val |> v.lu/t.unit)
end

" Convert AccelerationField units to match TimeField "
function convert_field_value!(a::AccelerationField, t::TimeField)
    setfield!(a, :val, a.val |> a.lu/t.unit^2)
end

" Revert field value back to original units "
function revert_units!(field::T) where T<:AbstractField
    setfield!(field, :val, field.val |> field.unit)
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
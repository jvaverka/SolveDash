module MySolver
   
using MyConditions
using MyFields
using Parameters


export solver_base, find_acceleration, convert_field_value!, hasunit, hasvalue

function solver_base(ic::MyConditions.BaseConditions)
    
    @unpack x₀, x, v₀, v, v̄, t, a = ic

    solns = Dict()

    if a.find
        
        """ try solving v = v₀ + at for a """
        if hasvalue([v, v₀, t]) && hasunit([v, v₀, t])
            convert_field_value!(v, a)
            convert_field_value!(v₀, a)
            convert_field_value!(t, a)

            solns["acceleration"] = find_acceleration(v, v₀, t)
        end

        """ try solving  """

    end
    if t.find
        # solve for time
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

function find_acceleration(
    v::MyFields.VelocityField,
    v₀::MyFields.VelocityField,
    t::MyFields.TimeField,
    )

    (v.val - v₀.val) / t.val
end

""" Convert PositionField units to match AccelerationField """
function convert_field_value!(p::MyFields.PositionField, a::MyFields.AccelerationField)
    p.val = p.val |> a.tu
end

""" Convert TimeField units to match AccelerationField """
function convert_field_value!(t::MyFields.TimeField, a::MyFields.AccelerationField)
    t.val = t.val |> a.tu
end

""" Convert VelocityField units to match AccelerationField """
function convert_field_value!(v::MyFields.VelocityField, a::MyFields.AccelerationField)
    v.val = v.val |> a.lu/a.tu
end

""" Ensure all fields in a given list have units """
function hasunit(fields::Vector{<:MyFields.AbstractField})
    for f ∈ fields
        if isnothing(f.unit)
            return false
        end
    end
    return true
end

""" Ensure all fields in a given list have values """
function hasvalue(fields::Vector{<:MyFields.AbstractField})
    for f ∈ fields
        if isnothing(f.val)
            return false
        end
    end
    return true
end

end # MySolver
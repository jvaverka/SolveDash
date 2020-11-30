module CommonUnits


using Unitful
import Unitful:
    mm, cm, m, inch, ft, yd, mi, ns, μs, ms, s, minute, hr, d, wk, yr

export length_units,
    time_units, time_squared_units, get_value_with_unit, get_value_with_units

length_units = Dict{Symbol,Unitful.FreeUnits}(
    :mm => mm,
    :cm => cm,
    :m => m,
    :inch => inch,
    :ft => ft,
    :yd => yd,
    :mi => mi,
)
time_units = Dict{Symbol,Unitful.FreeUnits}(
    :ns => ns,
    :μs => μs,
    :ms => ms,
    :s => s,
    :minute => minute,
    :hr => hr,
    :d => d,
    :wk => wk,
    :yr => yr,
)
time_squared_units = Dict{Symbol,Unitful.FreeUnits}(
    :ns => ns,
    :μs => μs,
    :ms => ms,
    :s => s,
    :minute => minute,
    :hr => hr,
    :d => d,
    :wk => wk,
    :yr => yr,
)

function get_value_with_unit(v, u::Union{Nothing,Unitful.FreeUnits})
    if isnothing(v)
        return nothing
    end
    return v * u
end

function get_value_with_units(
    v,
    lu::Union{Nothing,Unitful.LengthFreeUnits},
    tu::Union{Nothing,Unitful.TimeFreeUnits},
)
    if isnothing(v)
        return nothing
    end
    return v * lu / tu
end

end  # module CommonUnits

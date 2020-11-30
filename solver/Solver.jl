module Solver

include("PhysicsOne.jl")
include("../tabs/common/CommonUnits.jl")

using Unitful

export solve

function solve(g)
    soln = Dict{String,String}()

    """acceleration"""
    if g[:a][:find]

        if isnothing(g[:a][:udist]) || isnothing(g[:a][:utime])
            acceleration_soln *= "Must enter units before solving."
        end

        if !isnothing(g[:a][:value])
            acceleration_soln = string(g[:a][:value])
        elseif !isnothing(g[:v₀][:value]) &&
               !isnothing(g[:v][:value]) &&
               !isnothing(g[:t][:value])

            # convert all units
            v₀ = g[:v₀][:value]
            v₀ |> CommonUnits.length_units[Symbol(g[:a][:udist])]/CommonUnits.time_units[Symbol(g[:a][:utime])]
            g[:v₀][:value] = v₀

            v = g[:v][:value]
            v |> CommonUnits.length_units[Symbol(g[:a][:udist])]/CommonUnits.time_units[Symbol(g[:a][:utime])]
            g[:v][:value] = v

            t = g[:t][:value]
            t |> CommonUnits.time_units[Symbol(g[:a][:utime])]
            g[:t][:value] = t

            a = PhysicsOne.get_acc(
                g[:v][:value],
                g[:v₀][:value],
                g[:t][:value],
            )
            a |> CommonUnits.length_units[Symbol(g[:a][:udist])]/CommonUnits.time_units[Symbol(g[:a][:utime])]^2
            acceleration_soln = string(a)
        end
        # acceleration_soln *= " $(g[:a][:udist])/$(g[:a][:utime])"
        soln["acceleration"] = acceleration_soln
    end

    """average velocity"""
    if g[:v̄][:find]
        if !isnothing(g[:v̄][:value])
            soln["average_velocity"] = string(g[:v̄][:value])
        elseif !isnothing(g[:x₀][:value]) &&
                !isnothing(g[:x][:value]) &&
                !isnothing(g[:t][:value])
            soln["average_velocity"] = string(
                PhysicsOne.get_v̄(
                    g[:x][:value],
                    g[:x₀][:value],
                    g[:t][:value],
                ),
            )
        end
    end

    """initial position"""
    if g[:x][:find]
        if !isnothing(g[:x][:value])
            soln["distance_traveled"] = string(g[:x][:value])
        elseif !isnothing(g[:v̄][:value]) && !isnothing(g[:t][:value])
            soln["distance_traveled"] = string(
                PhysicsOne.get_dist(
                    g[:v̄][:value],
                    g[:t][:value],
                ),
            )
        end
    end

    """time"""
    if g[:t][:find]
        if !isnothing(g[:t][:value])
            soln["time"] = string(g[:t][:value])
        elseif !isnothing(g[:v̄][:value]) &&
                !isnothing(g[:x₀][:value]) &&
                !isnothing(g[:x][:value])
            soln["time"] = string(
                PhysicsOne.get_time(
                    g[:x][:value],
                    g[:x₀][:value],
                    g[:v̄][:value],
                ),
            )
        elseif !isnothing(g[:a][:value]) &&
                !isnothing(g[:v][:value]) &&
                !isnothing(g[:v₀][:value])
            soln["time"] = string(
                PhysicsOne.get_time(
                    g[:v][:value],
                    g[:v₀][:value],
                    g[:a][:value],
                ),
            )
        end
    end

    """velocity"""
    if g[:v][:find]
        if !isnothing(g[:v][:value])
            soln["final_velocity"] = string(g[:v][:value])
        elseif !isnothing(g[:v₀][:value]) &&
                !isnothing(g[:a][:value]) &&
                !isnothing(g[:t][:value])
            soln["final_velocity"] = string(
                PhysicsOne.get_vel(
                    g[:v₀][:value],
                    g[:a][:value],
                    g[:t][:value],
                ),
            )
        end
    end

    return soln
end

end  # module Solver

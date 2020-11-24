module Solver

using PhysicsOne

export solve

function solve(g)
    soln = Dict{String,Float64}()

    if isnothing(g[:a]) &&
       !isnothing(g[:v₀]) &&
       !isnothing(g[:v]) &&
       !isnothing(g[:t])
        soln["acceleration"] =
            float(round(get_acc(g[:v], g[:v₀], g[:t]), digits = 4))
    end
    if isnothing(g[:v̄]) &&
       !isnothing(g[:x₀]) &&
       !isnothing(g[:x]) &&
       !isnothing(g[:t])
        soln["average_velocity"] =
            float(round(get_v̄(g[:x], g[:x₀], g[:t]), digits = 4))
    end
    if !isnothing(g[:v̄]) && !isnothing(g[:t])
        soln["distance_traveled"] =
            float(round(get_dist(g[:v̄], g[:t]), digits = 4))
    end
    if isnothing(g[:t]) &&
       !isnothing(g[:v̄]) &&
       !isnothing(g[:x₀]) &&
       !isnothing(g[:x])
        soln["time"] = float(round(get_time(g[:x], g[:x₀], g[:v̄]), digits = 4))
    end
    if isnothing(g[:v]) &&
       !isnothing(g[:v₀]) &&
       !isnothing(g[:a]) &&
       !isnothing(g[:t])
        soln["final_velocity"] =
            float(round(get_vel(g[:v₀], g[:a], g[:t]), digits = 4))
    end
    if isnothing(g[:t]) &&
       !isnothing(g[:a]) &&
       !isnothing(g[:v]) &&
       !isnothing(g[:v₀])
        soln["time"] = float(round(get_time(g[:v], g[:v₀], g[:a]), digits = 4))
    end

    return soln
end

end  # module Solver

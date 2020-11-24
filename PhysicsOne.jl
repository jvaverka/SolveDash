module PhysicsOne


export get_v̄, get_dist, get_time, get_acc, get_vel

# average velocity as a function of position and time
get_v̄(x, x₀, t) = (x - x₀) / t

# distance as a function of average velocity and time
get_dist(v̄, t) = v̄ * t / 2

# time as a function of average velocity and displacement
# OR
# time as a function of acceleration and change in velocity
# see-> (v,v₀,a) = (v-v₀)/a
get_time(x, x₀, v̄) = (x - x₀) / v̄

# acceleration as a function of change in velocity and time
get_acc(v, v₀, t) = (v - v₀) / t

# velocity as a function of acceleration and time
get_vel(v₀, a, t) = v₀ + a * t

end  # module PhysicsOne

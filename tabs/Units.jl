module Units

export length_units, time_units, time_squared_units

length_units = ["mm", "cm", "m", "in", "ft", "yd", "mi"]
time_units = ["ns", "μs", "ms", "s", "min", "h", "d", "wk", "yr"]
time_squared_units = [x * "²" for x in time_units]

end  # module Units

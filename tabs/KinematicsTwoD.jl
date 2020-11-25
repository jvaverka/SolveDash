module KinematicsTwoD

using Dash, DashCoreComponents, DashHtmlComponents
include("Units.jl")

export kinematics_twod_layout

function kinematics_twod_layout()
    html_table(
        children = [
            html_caption("Initial Conditions"),
            html_tr(
                children = [
                    html_th("Field"),
                    html_th("Value"),
                    html_th("Unit (distance)"),
                    html_th("Unit (time)"),
                ],
            ),
            html_tr(
                children = [
                    html_th("x₀ : "),
                    html_td(dcc_input(
                        id = "input-k2d-start-pos",
                        value = nothing,
                        type = "number",
                        placeholder = "Initial Position",
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-start-pos-unit",
                        options = [
                            (label = i, value = i) for i in Units.length_units
                        ],
                        value = "meter (m)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "Gainsboro",
                        ),
                    ),),
                ],
            ),
            html_tr(
                children = [
                    html_th("x : "),
                    html_td(dcc_input(
                        id = "input-k2d-final-pos",
                        value = nothing,
                        type = "number",
                        placeholder = "Final Position",
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-final-pos-unit",
                        options = [
                            (label = i, value = i) for i in Units.length_units
                        ],
                        value = "meter (m)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "LavenderBlush",
                        ),
                    ),),
                ],
            ),
            html_tr(
                children = [
                    html_th("v₀ : "),
                    html_td(dcc_input(
                        id = "input-k2d-velocity-init",
                        value = nothing,
                        type = "number",
                        placeholder = "Initial Velocity",
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-velocity-init-unit-d",
                        options = [
                            (label = i, value = i) for i in Units.length_units
                        ],
                        value = "meter (m)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "Gainsboro",
                        ),
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-velocity-init-unit-t",
                        options = [
                            (label = i, value = i) for i in Units.time_units
                        ],
                        value = "seconds (s)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "Gainsboro",
                        ),
                    ),),
                ],
            ),
            html_tr(
                children = [
                    html_th("v̄ : "),
                    html_td(dcc_input(
                        id = "input-k2d-average-vel",
                        value = nothing,
                        type = "number",
                        placeholder = "Average Velocity",
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-average-vel-unit-d",
                        options = [
                            (label = i, value = i) for i in Units.length_units
                        ],
                        value = "meter (m)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "LavenderBlush",
                        ),
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-average-vel-unit-t",
                        options = [
                            (label = i, value = i) for i in Units.time_units
                        ],
                        value = "seconds (s)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "LavenderBlush",
                        ),
                    ),),
                ],
            ),
            html_tr(
                children = [
                    html_th("v : "),
                    html_td(dcc_input(
                        id = "input-k2d-velocity-final",
                        value = nothing,
                        type = "number",
                        placeholder = "Final Velocity",
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-velocity-final-unit-d",
                        options = [
                            (label = i, value = i) for i in Units.length_units
                        ],
                        value = "meter (m)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "Gainsboro",
                        ),
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-velocity-final-unit-t",
                        options = [
                            (label = i, value = i) for i in Units.time_units
                        ],
                        value = "seconds (s)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "Gainsboro",
                        ),
                    ),),
                ],
            ),
            html_tr(
                children = [
                    html_th("t : "),
                    html_td(dcc_input(
                        id = "input-k2d-time",
                        value = nothing,
                        type = "number",
                        placeholder = "Time",
                    ),),
                    html_td(),
                    html_td(dcc_dropdown(
                        id = "input-k2d-time-unit-t",
                        options = [
                            (label = i, value = i) for i in Units.time_units
                        ],
                        value = "seconds (s)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "LavenderBlush",
                        ),
                    ),),
                ],
            ),
            html_tr(
                children = [
                    html_th("a : "),
                    html_td(dcc_input(
                        id = "input-k2d-acceleration",
                        value = nothing,
                        type = "number",
                        placeholder = "Acceleration",
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-acceleration-unit-d",
                        options = [
                            (label = i, value = i) for i in Units.length_units
                        ],
                        value = "meter (m)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "Gainsboro",
                        ),
                    ),),
                    html_td(dcc_dropdown(
                        id = "input-k2d-acceleration-unit-t",
                        options = [
                            (label = i, value = i)
                            for i in Units.time_squared_units
                        ],
                        value = "seconds (s)",
                        style = (
                            width = "100%",
                            display = "inline-table",
                            backgroundColor = "Gainsboro",
                        ),
                    ),),
                ],
            ),
        ],
    )
end

end # module KinematicsTwoD

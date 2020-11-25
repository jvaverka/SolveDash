module Basics

using Dash, DashCoreComponents, DashHtmlComponents
include("Units.jl")

export basic_layout

function basic_layout()
    html_table(
        children = [
            html_caption("Initial Conditions"),
            html_thead(
                children = [
                    html_tr(
                        children = [
                            html_th("Field"),
                            html_th("Value"),
                            html_th("Unit (distance)"),
                            html_th("Unit (time)"),
                        ],
                    ),
                ],
            ),
            html_tbody(
                children = [
                    html_tr(
                        children = [
                            html_th("x₀ : "),
                            html_td(dcc_input(
                                id = "input-start-pos",
                                value = nothing,
                                type = "number",
                                placeholder = "Initial Position",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-start-pos-unit",
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
                                id = "input-final-pos",
                                value = nothing,
                                type = "number",
                                placeholder = "Final Position",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-final-pos-unit",
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
                                id = "input-velocity-init",
                                value = nothing,
                                type = "number",
                                placeholder = "Initial Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-velocity-init-unit-d",
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
                                id = "input-velocity-init-unit-t",
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
                                id = "input-average-vel",
                                value = nothing,
                                type = "number",
                                placeholder = "Average Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-average-vel-unit-d",
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
                                id = "input-average-vel-unit-t",
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
                                id = "input-velocity-final",
                                value = nothing,
                                type = "number",
                                placeholder = "Final Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-velocity-final-unit-d",
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
                                id = "input-velocity-final-unit-t",
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
                                id = "input-time",
                                value = nothing,
                                type = "number",
                                placeholder = "Time",
                            ),),
                            html_td(),
                            html_td(dcc_dropdown(
                                id = "input-time-unit-t",
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
                                id = "input-acceleration",
                                value = nothing,
                                type = "number",
                                placeholder = "Acceleration",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-acceleration-unit-d",
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
                                id = "input-acceleration-unit-t",
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
            ),
        ],
    )
end

end # module Basics

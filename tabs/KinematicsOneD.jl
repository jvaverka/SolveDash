module KinematicsOneD

using Dash, DashCoreComponents, DashHtmlComponents
include("common/CommonUnits.jl")


export kinematics_oned_layout, kinematics_oned_layout_find

"""
    kinematics_oned_layout()

Produces a html table containing FIELD, VALUE, UNIT data cells.
"""
function kinematics_oned_layout()
    html_table(
        children = [
            html_caption("Initial Conditions"),
            html_thead(
                children = [
                    html_tr(
                        children = [
                            html_th("Field"),
                            html_th("Value"),
                            html_th("Unit (length)"),
                            html_th("Unit (time)"),
                            html_th("Find"),
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
                                id = "input-k1d-pos-init",
                                value = 0,
                                type = "number",
                                placeholder = "Initial Position",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-pos-init-udist",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.length_units
                                ],
                                value = "m",
                                style = (
                                    width = "100%",
                                    display = "inline-table",                                ),
                            ),),
                            html_td(),
                            html_td(dcc_checklist(
                                id = "input-k1d-pos-init-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("x : "),
                            html_td(dcc_input(
                                id = "input-k1d-pos-final",
                                value = nothing,
                                type = "number",
                                placeholder = "Final Position",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-pos-final-udist",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.length_units
                                ],
                                value = "m",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(),
                            html_td(dcc_checklist(
                                id = "input-k1d-pos-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("v₀ : "),
                            html_td(dcc_input(
                                id = "input-k1d-velocity-init",
                                value = nothing,
                                type = "number",
                                placeholder = "Initial Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-velocity-init-udist",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.length_units
                                ],
                                value = "m",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-velocity-init-utime",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.time_units
                                ],
                                value = "s",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_checklist(
                                id = "input-k1d-velocity-init-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("v : "),
                            html_td(dcc_input(
                                id = "input-k1d-velocity-final",
                                value = nothing,
                                type = "number",
                                placeholder = "Final Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-velocity-final-udist",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.length_units
                                ],
                                value = "m",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-velocity-final-utime",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.time_units
                                ],
                                value = "s",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_checklist(
                                id = "input-k1d-velocity-final-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("v̄ : "),
                            html_td(dcc_input(
                                id = "input-k1d-velocity-avg",
                                value = nothing,
                                type = "number",
                                placeholder = "Average Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-velocity-avg-udist",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.length_units
                                ],
                                value = "m",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-velocity-avg-utime",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.time_units
                                ],
                                value = "s",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_checklist(
                                id = "input-k1d-average-velocity-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("t : "),
                            html_td(dcc_input(
                                id = "input-k1d-time",
                                value = nothing,
                                type = "number",
                                placeholder = "Time",
                            ),),
                            html_td(),
                            html_td(dcc_dropdown(
                                id = "input-k1d-time-utime",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.time_units
                                ],
                                value = "s",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_checklist(
                                id = "input-k1d-time-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("a : "),
                            html_td(dcc_input(
                                id = "input-k1d-acceleration",
                                value = nothing,
                                type = "number",
                                placeholder = "Acceleration",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-acceleration-udist",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.length_units
                                ],
                                value = "m",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-k1d-acceleration-utime",
                                options = [
                                    (label = string(k), value = string(v))
                                    for (k,v) in CommonUnits.time_squared_units
                                ],
                                value = "s²",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_checklist(
                                id = "input-k1d-acceleration-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                ],
            ),
        ],
    )
end # function kinematics_oned_layout

end # module KinematicsOneD

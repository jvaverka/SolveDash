module Basics

using Dash, DashCoreComponents, DashHtmlComponents
include("common/CommonUnits.jl")


export basic_layout, basic_layout_find

"""
    basic_layout()

Produces a html table containing FIELD, VALUE, UNIT data cells.
"""
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
                            html_th("length"),
                            html_th("time"),
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
                                id = "input-basic-pos-init",
                                value = 0.0,
                                type = "number",
                                placeholder = "Initial Position",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-basic-pos-init-udist",
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
                                id = "input-basic-pos-init-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("x : "),
                            html_td(dcc_input(
                                id = "input-basic-pos-final",
                                value = nothing,
                                type = "number",
                                placeholder = "Final Position",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-basic-pos-final-udist",
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
                                id = "input-basic-pos-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("v₀ : "),
                            html_td(dcc_input(
                                id = "input-basic-velocity-init",
                                value = nothing,
                                type = "number",
                                placeholder = "Initial Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-basic-velocity-init-udist",
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
                                id = "input-basic-velocity-init-utime",
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
                                id = "input-basic-velocity-init-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("v : "),
                            html_td(dcc_input(
                                id = "input-basic-velocity-final",
                                value = nothing,
                                type = "number",
                                placeholder = "Final Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-basic-velocity-final-udist",
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
                                id = "input-basic-velocity-final-utime",
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
                                id = "input-basic-velocity-final-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("v̄ : "),
                            html_td(dcc_input(
                                id = "input-basic-velocity-avg",
                                value = nothing,
                                type = "number",
                                placeholder = "Average Velocity",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-basic-velocity-avg-udist",
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
                                id = "input-basic-velocity-avg-utime",
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
                                id = "input-basic-velocity-avg-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("t : "),
                            html_td(dcc_input(
                                id = "input-basic-time",
                                value = nothing,
                                type = "number",
                                placeholder = "Time",
                            ),),
                            html_td(),
                            html_td(dcc_dropdown(
                                id = "input-basic-time-utime",
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
                                id = "input-basic-time-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                    html_tr(
                        children = [
                            html_th("a : "),
                            html_td(dcc_input(
                                id = "input-basic-acceleration",
                                value = nothing,
                                type = "number",
                                placeholder = "Acceleration",
                            ),),
                            html_td(dcc_dropdown(
                                id = "input-basic-acceleration-udist",
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
                                id = "input-basic-acceleration-utime",
                                options = [
                                    (label = string(k,"²"), value = string(v))
                                    for (k,v) in CommonUnits.time_squared_units
                                ],
                                value = "s",
                                style = (
                                    width = "100%",
                                    display = "inline-table",
                                ),
                            ),),
                            html_td(dcc_checklist(
                                id = "input-basic-acceleration-find",
                                options = [(label = "", value = "find")],
                            ),),
                        ],
                    ),
                ],
            ),
        ],
    )
end # function basic_layout

end # module Basics

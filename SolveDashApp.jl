using Solver
using Dash, DashHtmlComponents, DashCoreComponents


app = dash()
md = "
# Welcome to Solve Dash

This tool helps you solve many common problems from Physics I.

Simply enter the parameters of a particular problem,
hit **solve**, and see the results below.
"

app.layout = html_div() do
    dcc_markdown(md),
    html_div(
        children = [
            dcc_input(
                id = "input-x-start-pos",
                value = nothing,
                type = "number",
                placeholder = "Initial X Position",
            ),
            dcc_input(
                id = "input-x-final-pos",
                value = nothing,
                type = "number",
                placeholder = "Final X Position",
            ),
            dcc_input(
                id = "input-x-velocity-init",
                value = nothing,
                type = "number",
                placeholder = "Initial X Velocity",
            ),
            dcc_input(
                id = "input-x-average-vel",
                value = nothing,
                type = "number",
                placeholder = "Average X Velocity",
            ),
            dcc_input(
                id = "input-x-velocity-final",
                value = nothing,
                type = "number",
                placeholder = "Final X Velocity",
            ),
        ],
    ),
    # html_div(
    #     children = [
    #         dcc_input(
    #             id = "input-y-start-pos",
    #             value = nothing,
    #             type = "number",
    #             placeholder = "Initial Y Position"
    #         ),
    #         dcc_input(
    #             id = "input-y-velocity-init",
    #             value = nothing,
    #             type = "number",
    #             placeholder = "Initial Y Velocity"
    #         ),
    #         dcc_input(
    #             id = "input-y-velocity-final",
    #             value = nothing,
    #             type = "number",
    #             placeholder = "Final Y Velocity"
    #         ),
    #     ],
    # ),
    html_div(dcc_input(
        id = "input-time",
        value = nothing,
        type = "number",
        placeholder = "Time",
    )),
    html_div(dcc_input(
        id = "input-acceleration",
        value = nothing,
        type = "number",
        placeholder = "Acceleration",
    )),
    html_button(id = "solve-button-state", children = "solve", n_clicks = 0),
    dcc_markdown("## Results"),
    dcc_markdown(id = "output-solution")
end

callback!(
    app,
    Output("output-solution", "children"),
    Input("solve-button-state", "n_clicks"),
    State("input-x-start-pos", "value"),
    State("input-x-final-pos", "value"),
    State("input-x-velocity-init", "value"),
    State("input-x-average-vel", "value"),
    State("input-x-velocity-final", "value"),
    # State("input-y-start-pos", "value"),
    # State("input-y-velocity-init", "value"),
    # State("input-y-velocity-final", "value"),
    State("input-time", "value"),
    State("input-acceleration", "value"),
) do clicks,
xinit_pos,
xfinal_pos,
xinit_vel,
xavg_vel,
xfinal_vel,
# yinit_pos, yinit_vel, yfinal_vel,
time,
acceleration

    # dictionary to hold given |initial_conditions|
    initial_conditions = Dict(
        :x₀ => xinit_pos,
        :x => xfinal_pos,
        :v₀ => xinit_vel,
        :v̄ => xavg_vel,
        :v => xfinal_vel,
        # yinit_pos,
        # yinit_vel,
        # yfinal_vel,
        :t => time,
        :a => acceleration,
    )

    solutions = solve(initial_conditions)

    conditions = ""
    for (key, value) in initial_conditions
        conditions *= "
        $key:\t$value
        "
    end

    solns = ""
    for (key, value) in solutions
        solns *= "
        $key:\t$value
        "
    end
    if solns == ""
        solns *= "Not enough information to solve."
    end

    return "
    ### Initial Conditions Given -
    $conditions

    ### Solutions -
    $solns
    "
end

run_server(app, "0.0.0.0", debug = true)

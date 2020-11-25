using Dash, DashHtmlComponents, DashCoreComponents

include("Solver.jl")
include("tabs/Basics.jl")
include("tabs/KinematicsOneD.jl")
include("tabs/KinematicsTwoD.jl")


app = dash()
md = "
# Welcome to Solve Physics

Designed to help you solve common Physics I problems.

Enter the parameters of your problem and simply
hit **solve**!
"

app.layout = html_div() do
    dcc_markdown(md),
    dcc_tabs(
        children = [
            dcc_tab(
                label = "Basics",
                children = [
                    Basics.basic_layout(),
                    html_button(
                        id = "solve-button-state",
                        children = "solve",
                        n_clicks = 0,
                    ),
                    dcc_markdown(id = "output-solution"),
                ],
            ),
            # dcc_tab(
            #     label = "1D Kinematics",
            #     children =[
            #         KinematicsOneD.kinematics_oned_layout(),
            #         html_button(
            #             id = "solve-k1d-button-state",
            #             children = "solve",
            #             n_clicks = 0,
            #         ),
            #         dcc_markdown(id = "output-k1d-solution"),
            #     ],
            # ),
            # dcc_tab(
            #     label = "2D Kinematics",
            #     children = [
            #         KinematicsTwoD.kinematics_twod_layout(),
            #         html_button(
            #             id = "solve-k2d-button-state",
            #             children = "solve",
            #             n_clicks = 0,
            #         ),
            #         dcc_markdown(id = "output-k2d-solution"),
            #     ],
            # ),
        ],
    )
end

callback!(
    app,
    Output("output-solution", "children"),
    Input("solve-button-state", "n_clicks"),
    State("input-start-pos", "value"),
    State("input-final-pos", "value"),
    State("input-velocity-init", "value"),
    State("input-average-vel", "value"),
    State("input-velocity-final", "value"),
    State("input-time", "value"),
    State("input-acceleration", "value"),
) do clicks,
init_pos,
final_pos,
init_vel,
avg_vel,
final_vel,
# yinit_pos, yinit_vel, yfinal_vel,
time,
acceleration

    # dictionary to hold given |initial_conditions|
    initial_conditions = Dict(
        :x₀ => init_pos,
        :x => final_pos,
        :v₀ => init_vel,
        :v̄ => avg_vel,
        :v => final_vel,
        :t => time,
        :a => acceleration,
    )

    solutions = Solver.solve(initial_conditions)

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
    ## Solutions -
    $solns
    "
end

run_server(app, "0.0.0.0", debug = true)

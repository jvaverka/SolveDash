using Dash, DashHtmlComponents, DashCoreComponents


function solve(ic)
    answers = Dict()

    if isnothing(ic["acceleration"]) &&
       !isnothing(ic["xinit_vel"]) &&
       !isnothing(ic["xfinal_vel"]) &&
       !isnothing(ic["given_time"])

        answers["acceleration"] = round(find_acceleration_with_vel(ic), digits=4)
    end

    if isnothing(ic["xavg_vel"]) &&
        !isnothing(ic["xinit_pos"]) &&
        !isnothing(ic["xfinal_pos"]) &&
        !isnothing(ic["given_time"])

        answers["average_velocity"] = round(find_average_velocity(ic), digits=4)
    end

    if !isnothing(ic["xavg_vel"]) && !isnothing(ic["given_time"])
        answers["distance"] = round(find_distance_wth_avg_velocity(ic), digits=4)
    end

    if isnothing(ic["given_time"]) &&
        !isnothing(ic["xavg_vel"]) &&
        !isnothing(ic["xinit_pos"]) &&
        !isnothing(ic["xfinal_pos"])

        answers["time"] = round(find_time_with_avg_vel(ic), digits=4)
    end

    if isnothing(ic["xfinal_vel"]) &&
        !isnothing(ic["xinit_vel"]) &&
        !isnothing(ic["acceleration"]) &&
        !isnothing(ic["given_time"])

        answers["final_x_velocity"] = round(find_final_velocity(ic), digits=4)
    end

    if isnothing(ic["given_time"]) &&
        !isnothing(ic["acceleration"]) &&
        !isnothing(ic["xfinal_vel"]) &&
        !isnothing(ic["xinit_vel"])

        answers["time"] = round(find_time_to_final_vel(ic), digits=4)
    end

    return answers
end

function find_average_velocity(ic)
    return ((ic["xfinal_pos"] - ic["xinit_pos"])) / ic["given_time"]
end

function find_distance_wth_avg_velocity(ic)
    return (ic["xavg_vel"] * ic["given_time"]) / 2
end

function find_time_with_avg_vel(ic)
    return (ic["xfinal_pos"] - ic["xinit_pos"]) / ic["xavg_vel"]
end

function find_acceleration_with_vel(ic)
    return (ic["xfinal_vel"] - ic["xinit_vel"]) / ic["given_time"]
end

function find_final_velocity(ic)
    return ic["xinit_vel"] + ic["acceleration"] * ic["given_time"]
end

function find_time_to_final_vel(ic)
    return (ic["xfinal_vel"] - ic["xinit_vel"]) / ic["acceleration"]
end

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

    given = Dict(
        "xinit_pos" => xinit_pos,
        "xfinal_pos" => xfinal_pos,
        "xinit_vel" => xinit_vel,
        "xavg_vel" => xavg_vel,
        "xfinal_vel" => xfinal_vel,
        # "yinit_pos" => yinit_pos,
        # "yinit_vel" => yinit_vel,
        # "yfinal_vel" => yfinal_vel,
        "given_time" => time,
        "acceleration" => acceleration,
    )

    solutions = solve(given)

    conditions = ""
    for (key, value) in given
        conditions *= "
        $key:\t$value
        "
    end

    results = ""
    for (key, value) in solutions
        results *= "
        $key:\t$value
        "
    end
    if results == ""
        results *= "Not enough information to solve."
    end

    return "
    ### Initial Conditions Given -
    $conditions

    ### Solutions -
    $results
    "
end

run_server(app, "0.0.0.0", debug = true)

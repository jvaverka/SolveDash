using Dash, DashHtmlComponents, DashCoreComponents

# include("solver/Solver.jl")
include("experiment/MyConditions.jl")
include("experiment/MyFields.jl")
include("experiment/MySolutions.jl")
include("experiment/MySolver.jl")

include("tabs/common/CommonUnits.jl")
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
                    html_h1("Solutions -"),
                    html_h3(id = "output-solution"),
                ],
            ),
            dcc_tab(
                label = "1D Kinematics",
                children =[
                    KinematicsOneD.kinematics_oned_layout(),
                    html_button(
                        id = "solve-k1d-button-state",
                        children = "solve",
                        n_clicks = 0,
                    ),
                    dcc_markdown(id = "output-k1d-solution"),
                ],
            ),
            dcc_tab(
                label = "2D Kinematics",
                children = [
                    KinematicsTwoD.kinematics_twod_layout(),
                    html_button(
                        id = "solve-k2d-button-state",
                        children = "solve",
                        n_clicks = 0,
                    ),
                    dcc_markdown(id = "output-k2d-solution"),
                ],
            ),
        ],
    )
end

callback!(
    app,
    Output("output-solution", "children"),
    Input("solve-button-state", "n_clicks"),
    # x₀
    State("input-basic-pos-init", "value"),
    State("input-basic-pos-init-udist", "value"),
    State("input-basic-pos-init-find", "value"),
    # x
    State("input-basic-pos-final", "value"),
    State("input-basic-pos-final-udist", "value"),
    State("input-basic-pos-find", "value"),
    # v₀
    State("input-basic-velocity-init", "value"),
    State("input-basic-velocity-init-udist", "value"),
    State("input-basic-velocity-init-utime", "value"),
    State("input-basic-velocity-init-find", "value"),
    # v
    State("input-basic-velocity-final", "value"),
    State("input-basic-velocity-final-udist", "value"),
    State("input-basic-velocity-final-utime", "value"),
    State("input-basic-velocity-final-find", "value"),
    # v̄
    State("input-basic-velocity-avg", "value"),
    State("input-basic-velocity-avg-udist", "value"),
    State("input-basic-velocity-avg-utime", "value"),
    State("input-basic-velocity-avg-find", "value"),
    # t
    State("input-basic-time", "value"),
    State("input-basic-time-utime", "value"),
    State("input-basic-time-find", "value"),
    # a
    State("input-basic-acceleration", "value"),
    State("input-basic-acceleration-udist", "value"),
    State("input-basic-acceleration-utime", "value"),
    State("input-basic-acceleration-find", "value"),
) do clicks,
init_pos, init_pos_udist, init_pos_find,
final_pos, final_pos_udist, final_pos_find,
init_vel, init_vel_udist, init_vel_utime, init_vel_find,
final_vel, final_vel_udist, final_vel_utime, final_vel_find,
avg_vel, avg_vel_udist, avg_vel_utime, avg_vel_find,
time, time_utime, time_find,
acc, acc_udist, acc_utime, acc_find

    # dictionary to hold given |initial_conditions|
    initial_conditions = MyConditions.BaseConditions(
        MyFields.PositionField(
            init_pos,
            CommonUnits.length_units[Symbol(init_pos_udist)],
            init_pos_find == ["find"] ? true : false
        ),
        MyFields.PositionField(
            final_pos,
            CommonUnits.length_units[Symbol(final_pos_udist)],
            final_pos_find == ["find"] ? true : false
        ),
        MyFields.VelocityField(
            init_vel,
            CommonUnits.length_units[Symbol(init_vel_udist)]/CommonUnits.time_units[Symbol(init_vel_utime)],
            CommonUnits.length_units[Symbol(init_vel_udist)],
            CommonUnits.time_units[Symbol(init_vel_utime)],
            init_vel_find == ["find"] ? true : false,
        ),
        MyFields.VelocityField(
            final_vel,
            CommonUnits.length_units[Symbol(final_vel_udist)]/CommonUnits.time_units[Symbol(final_vel_utime)],
            CommonUnits.length_units[Symbol(final_vel_udist)],
            CommonUnits.time_units[Symbol(final_vel_utime)],
            final_vel_find == ["find"] ? true : false,
        ),
        MyFields.VelocityField(
            avg_vel,
            CommonUnits.length_units[Symbol(avg_vel_udist)]/CommonUnits.time_units[Symbol(avg_vel_utime)],
            CommonUnits.length_units[Symbol(avg_vel_udist)],
            CommonUnits.time_units[Symbol(avg_vel_utime)],
            avg_vel_find == ["find"] ? true : false
        ),
        MyFields.TimeField(
            time,
            CommonUnits.time_units[Symbol(time_utime)],
            time_find == ["find"] ? true : false,
        ),
        MyFields.AccelerationField(
            acc,
            CommonUnits.length_units[Symbol(acc_udist)]/CommonUnits.time_squared_units[Symbol(acc_utime)],
            CommonUnits.length_units[Symbol(acc_udist)],
            CommonUnits.time_squared_units[Symbol(acc_utime)],
            acc_find == ["find"] ? true : false,
        )
    )

    solutions = MySolver.mysolve(initial_conditions)

    result = ""

    if initial_conditions.x₀.find
        result *= "x₀ ⇒ $(solutions.x₀)\n"
    end
    if initial_conditions.x.find
        result *= "x ⇒ $(solutions.x)\n"
    end
    if initial_conditions.v₀.find
        result *= "v₀ ⇒ $(solutions.v₀)\n"
    end
    if initial_conditions.v.find
        result *= "v ⇒ $(solutions.v)\n"
    end
    if initial_conditions.v̄.find
        result *= "v̄ ⇒ $(solutions.v̄)\n"
    end
    if initial_conditions.t.find
        result *= "t ⇒ $(solutions.t)\n"
    end
    if initial_conditions.a.find
        result *= "a ⇒ $(solutions.a)\n"
    end

    return result
end

run_server(app, "0.0.0.0", debug = true)

mutable struct Parameters

    value::Float64
    lb::Float64
    ub::Float64
    to_fit::Bool

end

function dataframe_to_dict(parameters)

    dict = Dictionary{String, Parameters}()
    for i in 1:nrow(parameters)
        insert!(dict,
                parameters.parameter_name[i],
                Parameters(parameters.parameter_value[i], 0.0, 0.0, false))
    end

    dict

end

function loading_bar(start, finish, current)

    n = 40
    proportion_done = (current - start) / (finish - start)
    done_display = floor(n * proportion_done)
    percentage = floor((done_display/n) * 100)

    to_display = ""
    for i in 1:n 
        if (i <= done_display) 
            to_display = to_display * "="
        else
            to_display = to_display * " "
        end
    end

    to_display = "[" * to_display * "] " * string(percentage) * "%"

    # print status
    print('\r',to_display)
    if percentage >= 100
        println("")
    end

    nothing

end

function get_data(data, metric)

    n_items = 6
    n_trials = maximum(data.trial)

    observed = [Vector{Int64}() for _ in 1:n_trials]
    condition = Vector{String}(undef, n_trials)
    sim_X = Dict()
    for i in 1:n_trials
        current_trial = filter(:trial => x -> x == i, data)
        observed[i] = current_trial.responses
        condition[i] = current_trial.condition[1]
        sim_X[i] = build_matrix(current_trial[!,metric][1])
    end

    Data(n_trials, observed, condition, sim_X)

end

function build_matrix(s)

    v = parse.(Float64, split(s, ','))
    n = Int64(sqrt(length(v)))
    reshape(v, n, n)

end

laplace(d, b) = exp(-b * d)
eye!(m) = map(i -> m[i,i] = 1.0, 1:size(m,1))

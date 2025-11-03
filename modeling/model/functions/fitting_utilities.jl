function fitting_fct(parameters, data)

    # generate parameter values for the model
    single = gen_single()
    single.fitting = true
    free = gen_free(parameters)

    # pre-allocate matrices
    matrices = gen_matrices(single.n_items)

    # accumulates log likelihood across all trials
    log_L = 0.0
    for i in 1:data.n_trials
        # get the observed responses, which are the responses produced by participants
        matrices.observed = data.observed[i]
        # matrices.sim_X = data.sim_X[i] .^ free.b
        matrices.sim_X[1:single.n_items,1:single.n_items] = laplace.(1.0 .- data.sim_X[i], free.b)
        # launch the core function and get an input-output matrix
        log_L += core(single, free, matrices)
    end

    deviance = -2.0 * log_L

    # if there are impossible values, we want to know it
    if isnan(deviance) || any(deviance .== [-Inf, Inf])
        print("Inf values produced")
        return Inf
    end

    deviance

end

function generate_initial_parameters()

    dictionary([
        "alpha" => Parameters(1.0, 0.0, 6.0, true),
        "gamma" => Parameters(0.0, 0.001, 1.0, true),
        "delta" => Parameters(0.0, 0.001, 1.0, true),
        "overlap" => Parameters(0.0, 0.001, 1.0, true),
        "sigma" => Parameters(0.1, 0.01, 1.0, true),
        "tau" => Parameters(0.0, 0.0, 10.0, true),
        "b" => Parameters(1, 0.0, 100.0, true),
        "base" => Parameters(1.0, 0.0, 6.0, true),
        "theta" => Parameters(0.0, 0.0, 2.0, true),
        "sim_ELI" => Parameters(0.0, 0.0, 1.0, true),
    ])

end

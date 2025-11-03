function run_task(parameters, data)

    # generate our data structures to avoid passing too many arguments
    single = gen_single()
    single.fitting = false

    free = gen_free(parameters)
    matrices = gen_matrices(single.n_items)

    results = DataFrame()
    for i in 1:data.n_trials

        matrices.observed = data.observed[i]
        matrices.sim_X[1:single.n_items,1:single.n_items] = laplace.(1.0 .- data.sim_X[i], free.b)

        # launch the core model
        IOX = core(single, free, matrices)

        temp = analysis(single.n_items, IOX)
        temp.condition .= data.condition[i]

        # analyze the results and append them in the dataframe
        append!(results, temp)

    end

    results

end

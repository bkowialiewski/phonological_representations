function fitting(metric)

    println("\n" * metric)

    n_epoch = 2_500
    function_name = "fitting_fct"

    # generate an initial set of parameters
    initial_parameters = generate_initial_parameters()

    # get input-output matrix
    file_name = "../../experiments/grouped_phon/results/long.csv"
    all_data = CSV.read(file_name, DataFrame)

    n_subjects = length(levels(all_data.ID))

    df = DataFrame()
    for epoch in levels(all_data.ID)

        print(" " * string(epoch) * "/" * string(n_subjects))

        # get current data from the dataframe
        # transform it in a more efficient data format than a dataframe
        current_data = get_data(filter(:ID => x -> x == epoch, all_data), metric)

        # put those in a wrapper for the fitting function
        wrapper = Wrapper(n_epoch, function_name, initial_parameters, current_data)
        error, sd, best_parameters = differential_evolution(wrapper, true)

        for (key, parameter) in pairs(best_parameters)
            append!(df, DataFrame(:parameter_name => key,
                                  :parameter_value => parameter.value,
                                  :error => error,
                                  :metric => metric,
                                  :ID => epoch))
        end

    end

    df

end

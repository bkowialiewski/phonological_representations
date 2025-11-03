function simulate(metric)

    println("\n" * metric)

    # import parameters from text file
    file_name = "results/fitting.csv"
    all_parameters = CSV.read(file_name, DataFrame)
    all_parameters = all_parameters[all_parameters.metric .== metric,:]

    file_name = "../../experiments/grouped_phon/results/long.csv"
    all_data = CSV.read(file_name, DataFrame)

    df = DataFrame()
    for epoch in levels(all_parameters.ID)

        current_parameters = dataframe_to_dict(
            filter(:ID => x -> x == epoch, all_parameters)
        )
        current_data = get_data(filter(:ID => x -> x == epoch, all_data), metric)

        results = run_task(current_parameters, current_data)
        results.ID .= epoch
        results.metric .= metric

        # then launch this function, which ouputs a dataframe
        append!(df, results)

    end

    df

end

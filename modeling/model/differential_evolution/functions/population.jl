function initialize_population(single, initial_parameters)

    # pre-allocate population
    population = Vector{Dictionary{String, Parameters}}(undef, single.population_size)
    # iterate over it and fill it with random individuals
    for i in 1:single.population_size
        population[i] = generate_individual(initial_parameters)
    end

    population

end

function generate_individual(initial_parameters)

    # pre-allocate current individual
    individual = Dictionary{String, Parameters}()
    # iterate over keys
    for key in eachindex(initial_parameters)
        current = initial_parameters[key]
        # insert standard individual
        insert!(individual, key, Parameters(current.value, current.lb, current.ub, current.to_fit))
        # define the range of values for the default
        if current.to_fit
            # generate random default - within bound
            individual[key].value = current.lb + (current.ub - current.lb) * rand()
        end
    end

    individual

end

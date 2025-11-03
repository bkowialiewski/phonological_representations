function mutate_population(single, vectors, f, initial_parameters, data)

    # iterate over the population
    for i in 1:single.population_size

        # new candidate is built out of the initial one
        new_candidate = generate_individual(initial_parameters)

        # continue proposing a candidate...
        while true

            # until all parameters are within bound
            within_bound = true

            # select three candidates randomly
            vectors.candidates = pick_agents(single.population_size, i)
            # random index - part of the algorithm
            random_index = sample(1:single.n_parameters)

            # for each parameter
            # evaluate if we select the new value
            for (j, key) in enumerate(keys(vectors.population[i]))

                # if we don't fit this parameter, just skip it
                if !vectors.population[i][key].to_fit
                    continue
                end

                if rand() < single.crossover_probability || j == random_index

                    proposed_value = crossover(single.differential_weight, vectors, key)

                    if proposed_value >= vectors.population[i][key].lb && proposed_value <= vectors.population[i][key].ub
                        new_candidate[key].value = proposed_value
                        within_bound = within_bound && true
                    else
                        within_bound = within_bound && false
                    end

                else
                    new_candidate[key].value = vectors.population[i][key].value
                end

            end

            # if that's true
            # it means we generated a good candidate
            if within_bound
                break
            end

        end

        # if this new individual minimizes the objective function
        # replace the current individual by the new one
        if f(new_candidate, data) < vectors.fitness[i]
            vectors.population[i] = new_candidate
        end

    end

    nothing

end

function crossover(differential_weight, vectors, key)

    a, b, c = vectors.candidates

    new_value = vectors.population[a][key].value + differential_weight * (vectors.population[b][key].value - vectors.population[c][key].value)

    new_value

end

function pick_agents(population_size, current)

    ind = (1:population_size)[(1:population_size) .!= current]

    sample(ind, 3, replace = false)

end

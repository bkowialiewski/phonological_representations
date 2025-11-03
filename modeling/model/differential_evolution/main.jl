using Dictionaries, StatsBase, Random

include("functions/structs.jl")
include("functions/population.jl")
include("functions/mutations.jl")

function differential_evolution(wrapper, loading_bar_activated)

    Random.seed!(1234)

    # get generic function
    f = getfield(Main, Symbol(wrapper.function_name))

    # first generate structs and vectors
    single, vectors = generate_structs(wrapper.n_epoch, wrapper.initial_parameters)
    # generate first population
    vectors.population = initialize_population(single, wrapper.initial_parameters)
    # evaluate its fitness
    evaluate_fitness(vectors, f, wrapper.data)

    initial_standard_deviation = standard_deviation(single, vectors)

    # iterate over number of epoch
    for epoch in 1:single.n_epoch

        # generate a new population from the initial one
        mutate_population(single, vectors, f, wrapper.initial_parameters, wrapper.data)
        # and evaluate the new fitness
        evaluate_fitness(vectors, f, wrapper.data)

        current_standard_deviation = standard_deviation(single, vectors)

        best_individual = argmin(vectors.fitness)
        if isnan(vectors.fitness[best_individual])
            # println()
            println(epoch)
            display(vectors.population[best_individual])
            println(vectors.fitness[best_individual])
            throw("NaN value produced")
        end

        if loading_bar_activated
            # loading_bar(1, single.n_epoch, epoch)
            loading_bar(log(initial_standard_deviation), log(single.m), log(current_standard_deviation))
            print(" ")
            print(round(vectors.fitness[best_individual], digits = 2))
            print(" ")
        end

        # stopping criterion
        if current_standard_deviation < single.m
            break
        end

    end

    idx_best = argmin(vectors.fitness)
    sd = standard_deviation(single, vectors)
    
    output = (vectors.fitness[idx_best],
              sd,
              vectors.population[idx_best])

    output

end

function evaluate_fitness(vectors, f, data)

    for i in eachindex(vectors.population)
        vectors.fitness[i] = f(vectors.population[i], data)
    end

    nothing

end

function standard_deviation(single, vectors)

    radius = zeros(single.population_size)
    for i in 1:single.population_size
        for key in keys(vectors.population[i])
            if !vectors.population[i][key].to_fit
                continue
            end
            radius[i] += vectors.population[i][key].value^2.0
        end
        radius[i] = sqrt(radius[i])
    end

    average_radius = mean(radius)

    sum((radius .- average_radius) .^ 2.0) / (single.population_size - 1)

end

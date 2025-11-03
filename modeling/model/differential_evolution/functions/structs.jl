mutable struct Parameters

    value::Float64
    lb::Float64
    ub::Float64
    to_fit::Bool

end

mutable struct Wrapper

    n_epoch::Int64
    function_name::String
    initial_parameters::Dictionary{String, Parameters}
    data::Data

end


mutable struct SingleValues

    n_epoch::Int64
    n_parameters::Int64
    population_size::Int64
    crossover_probability::Float64
    differential_weight::Float64
    m::Float64

end

mutable struct Vectors

    population::Array{Dictionary{String, Parameters}, 1}
    parameter_names::Array{String, 1}
    fitness::Array{Float64, 1}
    candidates::Array{Int64, 1}

end

function generate_structs(n_epoch::Int64, initial_parameters::Dictionary{String, Parameters})

    n_parameters = 0
    for key in eachindex(initial_parameters)
        n_parameters += initial_parameters[key].to_fit
    end

    single = SingleValues(
                    n_epoch,
                    n_parameters,
                    10*n_parameters,
                    0.9,
                    0.8,
                    10^-4
                   )

    vectors = Vectors(
                      Array{Dictionary{String, Parameters}, 1}(),
                      collect(keys(initial_parameters)),
                      zeros(Float64, single.population_size),
                      [0, 0, 0]
                     )

    single, vectors

end

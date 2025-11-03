function gen_single()

    n_items = 6
    fitting = false
    log_L = 0.0

    Single(n_items, fitting, log_L)

end

function gen_free(parameters)

    alpha = parameters["alpha"].value
    gamma = parameters["gamma"].value
    delta = parameters["delta"].value
    overlap = parameters["overlap"].value
    sigma = parameters["sigma"].value
    temperature = sqrt(6.0) * sigma / pi
    tau = parameters["tau"].value
    b = parameters["b"].value
    base = parameters["base"].value
    theta = parameters["theta"].value
    sim_ELI = parameters["sim_ELI"].value

    Free(alpha, gamma, delta, overlap, sigma, temperature, tau, b, base, theta, sim_ELI)

end

function gen_matrices(n_items)

    positions = zeros(n_items+1, n_items+1)
    sim_X = zeros(n_items+1, n_items+1)
    activation = zeros(n_items+2)
    suppression = zeros(n_items+2)
    eye!(sim_X)

    observed = Vector{Int64}()
    IOX = zeros(n_items+2, n_items)

    Matrices(positions, sim_X, activation, suppression, observed, IOX)

end

mutable struct Single

    n_items::Int64
    fitting::Bool
    log_L::Float64

end

mutable struct Free

    alpha::Float64
    gamma::Float64
    delta::Float64
    overlap::Float64
    sigma::Float64
    temperature::Float64
    tau::Float64
    b::Float64
    base::Float64
    theta::Float64
    sim_ELI::Float64

end

mutable struct Matrices

    positions::Array{Float64, 2}
    sim_X::Array{Float64, 2}
    activation::Array{Float64, 1}
    suppression::Array{Float64, 1}
    observed::Array{Int64, 1}
    IOX::Array{Float64, 2}

end

mutable struct Data

    n_trials::Int64
    observed::Vector{Vector{Int64}}
    condition::Vector{String}
    sim_X::Dict

end

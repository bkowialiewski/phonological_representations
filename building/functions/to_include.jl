using CSV, DataFrames, StatsPlots, StatsBase, NamedArrays, JLD2

include("../../metrics/similarity_metrics.jl")
include("../../metrics/utilities.jl")

file_names = ["generate_vectors", "utilities"]
include.(file_names .* ".jl")

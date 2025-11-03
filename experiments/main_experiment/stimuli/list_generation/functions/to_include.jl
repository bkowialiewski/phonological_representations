using DataFrames, CSV, JLD2, NamedArrays, StatsBase, StatsPlots

include("../../../../../metrics/similarity_metrics.jl")
include("../../../../../metrics/utilities.jl")

file_names = ["get_triplets", "get_all_sim", "pair_triplets", "generate_similar", "generate_dissimilar"]
include.(file_names .* ".jl")



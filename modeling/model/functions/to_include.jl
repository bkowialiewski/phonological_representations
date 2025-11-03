using StatsBase, StatsPlots, BenchmarkTools, CSV, DataFrames, Dictionaries

file_names = ["structs", "fitting", "simulate", "core", "encoding", "retrieval", "utilities", "fitting_utilities", "run_task", "analysis"]
include.(file_names .* ".jl")

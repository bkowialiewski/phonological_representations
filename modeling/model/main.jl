include("functions/to_include.jl")
include("differential_evolution/main.jl")

function main()

    # available:
    # fitting
    # simulate

    type = "fitting"
    f = getfield(Main, Symbol(type))

    metrics = vcat(["slot_coding", "levenshtein", "syllable", "closed_biphone"], "open_biphone_" .* string.(1:5))

    df = DataFrame()
    map(m ->  append!(df, f(m)), metrics)

    file_name = "results/" * type * ".csv"
    CSV.write(file_name, df)

    nothing

end

main()

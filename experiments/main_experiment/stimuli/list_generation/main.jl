include("functions/to_include.jl")

function main()

    all_metrics = ["slot_coding", "levenshtein", "syllable", "closed_biphone", "open_biphone_1"]

    df = DataFrame()
    for m in all_metrics

        println("Generating dissimilar")
        dissimilar = generate_dissimilar(100_000, m, all_metrics)
        println("Generating similar")
        similar = generate_similar(50_000, m, all_metrics)

        rename!(similar, "item_" .* string.(1:ncol(similar)))
        rename!(dissimilar, "item_" .* string.(1:ncol(dissimilar)))

        similar.condition .= "similar"
        dissimilar.condition .= "dissimilar"

        similar.metric .= m
        dissimilar.metric .= m

        append!(df, similar, dissimilar)
        println(m)

    end

    file_name = "results/lists.csv"
    CSV.write(file_name, df)

    nothing

end

main()

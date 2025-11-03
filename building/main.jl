include("functions/to_include.jl")

function main()

    file_name = "../databases/results/lexique_reduced.csv"
    corpus = CSV.read(file_name, DataFrame)

    metrics = vcat(["slot_coding", "closed_biphone", "levenshtein", "syllable"], "open_biphone_" .* string.(1:5))

    @time for metric in metrics

        println(metric)

        if metric == "syllable"
            # ind = findall(.!isequal.(corpus.syllable_phon[1:end], missing))
            syll = String.(corpus.syll)
            phon = String.(corpus.phon)
            m = pairwise_similarity(syll, metric)
        else
            phon = String.(corpus.phon)
            m = pairwise_similarity(phon, metric)
        end

        setnames!(m, phon, 1)
        setnames!(m, phon, 2)

        file_name = "results/" * metric * ".jld2"
        @save file_name m
        
    end

    nothing

end

main()

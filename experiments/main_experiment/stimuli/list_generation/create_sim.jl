include("functions/to_include.jl")

# this function computes the summed similarity between all triplets
# and export it - more convenient because we have to run this script only once
function create_sim()

    all_metrics = ["slot_coding", "closed_biphone", "open_biphone_1", "levenshtein", "syllable"]

    n_items = 3

    file_name = "../../../../databases/results/lexique_reduced.csv"
    corpus = CSV.read(file_name, DataFrame)

    for m in all_metrics

        println(m)

        file_name = "../triplet_generation/results/" * m * ".csv"
        df = CSV.read(file_name, DataFrame)
        n_triplets = length(levels(df.triplet_number))

        triplets_ortho, triplets_phon = get_triplets(df, corpus, n_triplets, n_items)

        all_sim = get_all_sim(n_triplets, triplets_phon)

        file_name = "results/all_sim_" * m * ".csv"
        CSV.write(file_name, all_sim)

        file_name = "results/triplets_ortho_" * m * ".jld2"
        @save file_name triplets_ortho

    end

    nothing

end

create_sim()

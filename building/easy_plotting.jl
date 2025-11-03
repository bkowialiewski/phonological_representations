include("functions/to_include.jl")

function plotting()

    all_models = ["slot_coding", "levenshtein", "syllable", "closed_biphone", "open_biphone_1"]
    all_labels = ["Slot coding", "Levenshtein", "Syllable", "Closed biphone", "Open biphone 1"]

    limit = 500

    n = length(all_models)

    df = DataFrame()
    for i in 1:(n-1)
        println(i)
        for j in (i+1):n

            current_label = all_labels[i] * " vs. " * all_labels[j]

            println(current_label)

            m1 = all_models[i]
            m2 = all_models[j]

            matrices = Dict()
            file_name = "results/" * m1 * ".jld2"
            matrices["m1"] = load(file_name)["m"]
            map(i -> matrices["m1"][i,i] = 0.0, 1:size(matrices["m1"], 1))

            file_name = "results/" * m2 * ".jld2"
            matrices["m2"] = load(file_name)["m"]
            map(i -> matrices["m2"][i,i] = 0.0, 1:size(matrices["m2"], 1))

            labels = intersect(names(matrices["m1"])[1], names(matrices["m2"])[1])

            matrices["m1"] = matrices["m1"][labels, labels]
            matrices["m2"] = matrices["m2"][labels, labels]

            for i in 1:(limit-1)
                for j in (i+1):limit
                    append!(df, DataFrame(m1 = matrices["m1"][i,j],
                                          m2 = matrices["m2"][i,j],
                                          label = current_label))
                end
            end
        end
    end

    CSV.write("results/all_correlations.csv", df)

    nothing

end

plotting()

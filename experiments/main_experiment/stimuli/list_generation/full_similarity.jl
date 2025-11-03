include("functions/to_include.jl")

function full_similarity()

    n_items = 6

    all_metrics = ["slot_coding", "levenshtein", "syllable", "closed_biphone", "open_biphone_1"]

    file_name = "../../../../databases/results/lexique_reduced.csv"
    lexicon = CSV.read(file_name, DataFrame)

    all_matrices = Dict()
    for m in all_metrics
        file_name = "../../../../building/results/" * m * ".jld2"
        all_matrices[m] = load(file_name)["m"]
    end

    lists = CSV.read("results/lists.csv", DataFrame)
    df = DataFrame()
    for i in 1:nrow(lists)

        temp = DataFrame()
        for m in all_metrics
            current_list = string.(collect(lists[i,1:6]))
            current_condition = string(lists[i,"condition"])

            if current_condition == "similar"
                temp[!,m] = vcat(get_pairs(current_list[1:3], all_matrices[m], lexicon),
                                 get_pairs(current_list[4:6], all_matrices[m], lexicon))
            else
                temp[!,m] = get_pairs(current_condition, current_list, all_matrices[m], lexicon)
            end
        end
        temp[!,"condition"] .= lists[i,"condition"]
        temp[!,"metric"] .= lists[i,"metric"]

        append!(df, temp)

    end

    file_name = "results/similarity_values.csv"
    CSV.write(file_name, df)

end

function get_pairs(list, matrix, lexicon)

    n = length(list)

    list_phon = copy(list)
    for i in 1:n
        ind = findall(lexicon.ortho .== list[i])[1]
        list_phon[i] = lexicon.phon[ind]
    end

    pairs = zeros(triang(n))
    cnt = 0
    for i in 1:(n-1)
        for j in (i+1):n
            cnt += 1
            pairs[cnt] = matrix[String(list_phon[i]), String(list_phon[j])]
        end
    end

    pairs

end

triang(n) = div((n*(n-1)), 2)

full_similarity()

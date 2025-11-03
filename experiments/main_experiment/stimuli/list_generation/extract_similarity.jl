include("functions/to_include.jl")

function extract_similarity()

    all_metrics = ["slot_coding", "levenshtein", "syllable", "closed_biphone", "open_biphone_1"]

    file_name = "../../../../databases/results/lexique_reduced.csv"
    lexicon = CSV.read(file_name, DataFrame)

    all_matrices = Dict()
    for m in all_metrics
        file_name = "../../../../building/results/" * m * ".jld2"
        all_matrices[m] = load(file_name)["m"]
    end

    lists = CSV.read("results/lists.csv", DataFrame)
    for m in all_metrics

        lists[!,m] .= 0.0

        for i in 1:nrow(lists)

            current_list = string.(collect(lists[i,1:6]))
            condition = lists[i,"condition"]

            if condition == "similar"
                lists[i,m] = mean([
                    extract_values(current_list[1:3], lexicon, all_matrices[m]),
                    extract_values(current_list[4:6], lexicon, all_matrices[m])
                ])
            elseif condition == "dissimilar"
                lists[i,m] = extract_values(current_list, lexicon, all_matrices[m])
            else
                throw("Wrong condition definition")
            end

        end

    end

    df = DataFrame()
    for m in all_metrics

        temp = DataFrame()

        temp[!,"similarity_condition"] = ["similar", "dissimilar"]
        temp[!,"metric_condition"] .= m

        for m_sub in all_metrics

            ind_similar = lists.condition .== "similar" .&& lists.metric .== m
            ind_dissimilar = lists.condition .== "dissimilar" .&& lists.metric .== m

            temp[!,m_sub] .= [
                round(mean(lists[:,m_sub][ind_similar]), digits = 3);
                round(mean(lists[:,m_sub][ind_dissimilar]), digits = 3)]

        end

        append!(df, temp)

    end

    file_name = "results/similarity_values.csv"
    CSV.write(file_name, df)

    nothing

end

function extract_values(list, lexicon, matrix)

    n = length(list)

    list_phon = copy(list)
    for i in 1:n
        ind = findall(lexicon.ortho .== list[i])[1]
        list_phon[i] = lexicon.phon[ind]
    end

    sum = 0.0
    cnt = 0
    for i in 1:n
        for j in 1:n
            if i != j
                similarities[cnt]
                sum += matrix[String(list_phon[i]), String(list_phon[j])]
                cnt += 1
            end
        end
    end

    sum/cnt

end

extract_similarity()

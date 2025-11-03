function get_all_sim(n_triplets, triplets_phon)

    all_sim = DataFrame()
    for i in 1:(n_triplets-1)
        for j in (i+1):n_triplets
            append!(all_sim, DataFrame(
                item1 = i,
                item2 = j,
                slot_coding = get_sim(triplets_phon[i,:], triplets_phon[j,:], "slot_coding"),
                closed_biphone = get_sim(triplets_phon[i,:], triplets_phon[j,:], "closed_biphone"),
                open_biphone_1 = get_sim(triplets_phon[i,:], triplets_phon[j,:], "open_biphone_1"),
                levenshtein = get_sim(triplets_phon[i,:], triplets_phon[j,:], "levenshtein"),
                syllable = get_sim(triplets_phon[i,:], triplets_phon[j,:], "syllable")
            ))
        end
    end

    all_sim

end

function get_sim(triplet_1, triplet_2, metric)

    file_name = "../../../../building/results/" * metric * ".jld2"
    matrix = load(file_name)["m"]

    sum = 0.0
    for i in 1:length(triplet_1)
        for j in 1:length(triplet_2)
            sum += matrix[triplet_1[i], triplet_2[j]]
        end
    end

    sum

end

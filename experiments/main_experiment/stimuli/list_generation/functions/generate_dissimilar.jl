function generate_dissimilar(n_sim, current_metric, all_metrics)

    file_name = "results/triplets_ortho_" * current_metric * ".jld2"
    triplets_ortho = load(file_name)["triplets_ortho"]
    triplets_phon = to_phon(triplets_ortho)

    all_matrices = Dict()
    for m in all_metrics
        file_name = "../../../../building/results/" * m * ".jld2"
        all_matrices[m] = load(file_name)["m"]
    end

    # here we first run a simulation to know what kind of summed similarity across all list
    # we can expect to obtain
    min_val = get_minimum_dissimilar(n_sim, triplets_ortho, triplets_phon, all_matrices)
    ortho = generate_low_dissimilar(min_val, triplets_ortho, triplets_phon, all_matrices)

    DataFrame(ortho, :auto)

end

function to_phon(triplets_ortho)

    triplets_phon = copy(triplets_ortho)

    file_name = "../../../../databases/results/lexique_reduced.csv"
    lexicon = CSV.read(file_name, DataFrame)

    for i in 1:size(triplets_phon,1)
        for j in 1:size(triplets_phon,2)
            ind = findall(lexicon.ortho .== triplets_ortho[i,j])[1]
            triplets_phon[i,j] = string(lexicon.phon[ind])
        end
    end

    triplets_phon

end

function generate_low_dissimilar(threshold, triplets_ortho, triplets_phon, all_matrices)

    n = length(triplets_ortho)
    while true

        ind = sample(1:n, n)
        trial_phon = reshape(triplets_phon[ind], Int(n/6), 6)
        trial_ortho = reshape(triplets_ortho[ind], Int(n/6), 6)

        sim = 0.0
        for m in keys(all_matrices)
            sim += get_phon_random(trial_phon, all_matrices[m])
        end

        if sim < threshold
            return trial_ortho
        end

    end

end

function get_phon_random(trial, matrix)
    
    n_items = size(trial,2)
    sim_X = zeros(n_items, n_items)
    for i in 1:size(trial,1)
        for j in 1:(n_items-1)
            for k in (j+1):n_items
                sim_X[j,k] += matrix[trial[i,j], trial[i,k]]
            end
        end
    end

    sum(sim_X)

end

function get_minimum_dissimilar(n_sim, triplets_ortho, triplets_phon, all_matrices)

    n = length(triplets_ortho)
    all_sim = zeros(n_sim)
    for epoch in 1:n_sim

        ind = sample(1:n, n)
        trial = reshape(triplets_phon[ind], Int(n/6), 6)

        for m in keys(all_matrices)
            all_sim[epoch] += get_phon_random(trial, all_matrices[m])
        end

    end

    minimum(all_sim)

end


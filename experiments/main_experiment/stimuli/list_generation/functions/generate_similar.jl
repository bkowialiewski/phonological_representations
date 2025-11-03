function generate_similar(n_sim, current_metric, all_metrics)

    file_name = "results/triplets_ortho_" * current_metric * ".jld2"
    triplets_ortho = load(file_name)["triplets_ortho"]

    # here we first run a simulation to know what kind of summed similarity across all list
    # we can expect to obtain
    min_val = get_minimum_similar(n_sim, triplets_ortho, current_metric, all_metrics)
    # then, we generate a candidate matching for which the summed of the similarity across all lists
    # is under the minimum value as computed above
    # this is just convenient to minimize similarity
    df = generate_low_similar(min_val, triplets_ortho, current_metric, all_metrics)

    lists = fill("", nrow(df), 6)
    for i in 1:nrow(df)
        triplet_1 = triplets_ortho[df.item1[i],:]
        triplet_2 = triplets_ortho[df.item2[i],:]
        lists[i,:] = [triplet_1; triplet_2]
    end

    DataFrame(lists, :auto)

end

function generate_low_similar(min_val, triplets_ortho, current_metric, all_metrics)

    df = DataFrame()
    while true
        df = pair_triplets(triplets_ortho, current_metric, all_metrics)
        if sum(df.sim) <= min_val
            break
        end
    end

    df

end

function get_minimum_similar(n_sim, triplets_ortho, current_metric, all_metrics)

    values = map(i -> sum(pair_triplets(triplets_ortho, current_metric, all_metrics).sim), 1:n_sim)

    minimum(values)

end

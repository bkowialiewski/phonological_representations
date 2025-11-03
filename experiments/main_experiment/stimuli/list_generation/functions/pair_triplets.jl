function pair_triplets(triplets_ortho, current_metric, all_metrics)

    # import the sum of all triplets
    file_name = "results/all_sim_" * current_metric * ".csv"
    all_sim = CSV.read(file_name, DataFrame)

    matching = DataFrame()
    while nrow(all_sim) > 0

        current = sample(all_sim.item1, 1)

        ind = (all_sim.item1 .== current .|| all_sim.item2 .== current) 
        temp = all_sim[ind,:]

        all_sum = sum.(eachrow(temp[:,all_metrics]))
        selected = argmin(all_sum)

        append!(matching, DataFrame(item1 = temp.item1[selected],
                                    item2 = temp.item2[selected],
                                    sim = all_sum[selected]))

        ind = all_sim[:,["item1", "item2"]] .== temp.item1[selected] .|| 
              all_sim[:,["item1", "item2"]] .== temp.item2[selected]

        to_keep = sum.(eachrow(ind)) .< 1
        all_sim = all_sim[to_keep,:]

    end

    matching

end

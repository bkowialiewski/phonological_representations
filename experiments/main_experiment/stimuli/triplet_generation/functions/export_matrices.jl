function export_matrices(n_items, all_lists, current_model, all_models)

    n = length(all_lists["phon"])

    df = DataFrame()
    for epoch in 1:n

        for i in 1:(n_items-1)
            for j in (i+1):n_items

                temp = DataFrame(item1 = all_lists["ortho"][epoch][i],
                                 item2 = all_lists["ortho"][epoch][j],
                                 triplet_number = epoch)

                for k in 1:length(all_models)
                    word1 = all_lists["phon"][epoch][i]
                    word2 = all_lists["phon"][epoch][j]
                    temp[!, all_models[k]] .= get_sim(all_models[k], word1, word2)
                end

                append!(df, temp)

            end
        end

    end

    file_name = "results/" * current_model * ".csv"
    CSV.write(file_name, df)

    nothing

end

function generate_lists(df, n_items)

    items = String[]
    list = Matrix{String}(undef, n_items-1, 2)

    for i in 1:(n_items-1)

        if i == 1
            items = [df.ortho_1[1], df.ortho_2[1]]
            list[i,:] = items
        end

        pivot = items[2]
        to_exclude = items[1]

        to_delete = findall((df.ortho_1 .== to_exclude) .| (df.ortho_2 .== to_exclude))
        delete!(df, to_delete)

        ind = findall((df.ortho_1 .== pivot) .| (df.ortho_2 .== pivot))
        temp = sort(df[ind,:], :difference, rev = false)

        if pivot == temp.ortho_1[1]
            items = [temp.ortho_1[1], temp.ortho_2[1]]
        else
            items = [temp.ortho_2[1], temp.ortho_1[1]]
        end

        list[i,:] = items

    end

    list

end

include("functions/to_include.jl")

function main()

    # number of items per triplet
    n_items = 3
    # how many triplets per metric do we wish to create?
    n_lists = 16

    all_models = ["open_biphone_1", "closed_biphone", "slot_coding", "levenshtein", "syllable"]
    criteria = [0.35, 0.4, 0.5, 0.5, 0.6]
    # criteria = [0.3, 0.3, 0.3, 0.3, 0.3]

    # remove all csv files beforehand - cleaner
    foreach(rm, filter(endswith(".csv"), readdir("results/",join=true)))

    # import corpus - important for the phon to orth translation
    file_name = "../../../../../databases/results/lexique_reduced.csv"
    corpus = CSV.read(file_name, DataFrame)

    # import the big similarity matrices
    matrices = get_matrices(all_models)

    for epoch in 1:length(all_models)

        current_model = all_models[epoch]
        other_models = all_models[all_models .!= current_model]

        # store all lists in a dict
        all_lists = Dict("phon" => [],
                         "ortho" => [])

        # create lists one by one
        for i in 1:n_lists

            # build the phonological lists
            current_list = build_list(current_model, other_models, matrices, n_items, criteria[epoch])
            # and retrieve the orthographic lists on the fly
            push!(all_lists["phon"], current_list)
            push!(all_lists["ortho"], phon_to_ortho(all_lists["phon"][i], corpus))

            # remove all items which have already been used from our big matrices
            keep = .!(names(matrices[current_model], 1) .∈ Ref(all_lists["phon"][i]))
            for (key, value) in pairs(matrices)
                matrices[key] = matrices[key][keep, keep]
            end

            loading_bar(1, n_lists, i)

        end

        export_matrices(n_items, all_lists, current_model, all_models)

    end

    nothing

end

function average_sim(m)

    cnt = 0
    sum = 0
    for i in 1:(size(m,1)-1)
        for j in (i+1):size(m,2)
            cnt += 1
            sum += m[i,j]
        end
    end

    sum/cnt

end

function phon_to_ortho(list_phon, corpus)

    list_ortho = String[]
    for item in list_phon
        push!(list_ortho, corpus.ortho[corpus.phon .== item][1])
    end

    list_ortho

end

main()

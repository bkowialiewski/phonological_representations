function get_matrices(models)

    matrices = Dict()
    labels = []
    for i in 1:length(models)

        # import the big similarity matrices
        file_name = "../../../../../building/results/" * models[i] * ".jld2"
        matrices[models[i]] = load(file_name)["m"]
        map(j -> matrices[models[i]][j,j] = 0.0, 1:size(matrices[models[i]], 1))

        append!(labels, names(matrices[models[i]])[1])

    end

    # we want to keep only the items common across matrices
    syllable_labels = names(matrices["syllable"])[1]
    labels = intersect(labels, syllable_labels)

    for i in 1:length(models)
        matrices[models[i]] = matrices[models[i]][labels, labels]
    end

    matrices

end

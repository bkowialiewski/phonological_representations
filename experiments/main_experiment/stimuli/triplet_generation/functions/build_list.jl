function build_list(current_model, other_models, matrices, n_items, criterion)

    # get all items
    labels = names(matrices[current_model])[1]

    # delta between all models and current model - we want to minimize it
    delta = matrices[current_model] * 0.0
    for i in 1:length(other_models)
        delta += matrices[other_models[i]] - matrices[current_model]
    end

    # identify all pairs of items which are above the criterion
    # also, acceptable pairs in current model must have a similarity value equals or superior to other models
    ind_first = findall(get_threshold(current_model, other_models, matrices, criterion))

    positive = zeros(length(ind_first))
    negative = zeros(length(ind_first))

    # we will test all possible lists
    all_lists = fill("", length(ind_first), n_items)

    for epoch in 1:length(ind_first)

        # create first proposal
        list = [labels[ind_first[epoch][1]], labels[ind_first[epoch][2]]]
        while true

            # isolate similarity values for current list
            new_threshold = matrices[current_model][:,list]

            # create a new matrix
            thresholded = new_threshold .> -999
            # identify which among those are superior or equal to other models
            for i in 1:length(other_models)
                thresholded = thresholded .&& new_threshold .>= matrices[other_models[i]][:,list] 
            end

            # the new item must have a similarity value above the criterion with all other list items
            new_threshold = sum(new_threshold .> criterion, dims = 2) .> 1
            # but also correspond to the criterion defined above
            new_threshold = new_threshold .&& sum(thresholded, dims = 2) .> 1
            new_threshold = findall(new_threshold[:,1])

            # do the sum of delta for current list
            current_delta = sum(delta[:,list], dims = 2)
            # discard items from current list
            current_delta[list,:] .= 999.0
            # isolate those corresponding to current criteria
            current_delta = current_delta[new_threshold,:]

            if size(current_delta, 1) == 0
                positive[epoch] = NaN
                negative[epoch] = NaN
                break
            end

            # take the item that minimizes the delta and add it
            ind = argmin(current_delta)[1]
            new_item = names(current_delta[:,1])[1][ind]
            push!(list, new_item)

            if length(list) == n_items
                for i in 1:(n_items-1)
                    for j in (i+1):n_items
                        positive[epoch] += matrices[current_model][list[i],list[j]]
                        negative[epoch] += delta[list[i],list[j]]
                    end
                end
                all_lists[epoch,:] = list
                break
            end

        end

    end

    valid_indices = findall(!isnan, negative)

    negative = negative[valid_indices]
    all_lists = all_lists[valid_indices,:]

    ind = argmin(negative)

    all_lists[ind,:]

end

function get_threshold(current_model, other_models, matrices, criterion)

    thresholded = matrices[current_model] .> criterion
    for i in 1:length(other_models)
        thresholded = thresholded .&& matrices[current_model] .>= matrices[other_models[i]]
    end

    thresholded

end

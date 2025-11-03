function retrieval!(single, free, matrices)

    matrices.suppression .= 0.0

    # iterate over retrieval attempts
    for i in 1:single.n_items

        # cue current item with its position - generates an activation pattern
        matrices.activation[1:(single.n_items+1)] .= matrices.sim_X * matrices.positions[:,i]
        # add base activation level
        matrices.activation[1:single.n_items] .+= free.base
        # apply response suppression
        matrices.activation .-= matrices.suppression
        matrices.activation[end] = free.theta

        # compute probability to retrieve all retrieval candidates from the activation pattern
        probability = choice_rule(matrices.activation, free.temperature)

        if single.fitting
            # add observed likelihood
            single.log_L += log(probability[matrices.observed[i]])
        else
            # store those probabilities
            matrices.IOX[:,i] = probability
        end

        # update the response suppression vector
        if matrices.observed[i] <= single.n_items
            matrices.suppression[matrices.observed[i]] = free.tau
        end

    end

    nothing

end 

# probabilistic choice, scaled by standard deviation
choice_rule(v, sigma) = exp.(v ./ sigma) ./ sum(exp.(v ./ sigma))

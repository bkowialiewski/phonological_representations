function encoding!(n_items, free, matrices)

    # generate a primacy gradient of activation
    primacy_gradient = gen_primacy(free.alpha, free.gamma, 1:n_items) .+ 1.0
    # do the same for delta updating
    delta_updating = gen_delta_updating(free.delta, n_items, 1:n_items)
    # final encoding strength
    encoding_strength = primacy_gradient .* delta_updating

    # compute positional overlap for each item
    # scaled by the encoding strength - that's our output
    for i in 1:n_items
        matrices.positions[i,1:n_items] = gen_overlap(free.overlap, 1:n_items, i) .* encoding_strength
    end

    matrices.sim_X[:,end] .= free.sim_ELI
    matrices.sim_X[end,:] .= free.sim_ELI
    matrices.sim_X[end,end] = 1.0

    nothing

end

gen_primacy(alpha, gamma, i) = @. alpha * (1.0 - gamma) ^ (i - 1.0)
gen_delta_updating(delta, n, i) = @. (1.0 - delta) ^ (n - i)
gen_overlap(overlap, i, j) = @. overlap ^ abs(i - j)

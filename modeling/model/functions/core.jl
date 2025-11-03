function core(single, free, matrices)

    single.log_L = 0.0
    matrices.IOX .*= 0.0

    # encode items
    encoding!(single.n_items, free, matrices)
    # retrieve items - updates the input-output matrix
    retrieval!(single, free, matrices)

    if single.fitting
        return single.log_L
    else
        return matrices.IOX
    end

end

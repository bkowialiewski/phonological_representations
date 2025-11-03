function pairwise_similarity(phon, metric)

    n = length(phon)
    f = getfield(Main, Symbol(metric))

    m = NamedArray(zeros(n, n), (phon, phon))
    eye!(m)

    for i in 1:(n-1)
        for j in (i+1):n
            m[i,j] = f(phon[i], phon[j])
            m[j,i] = m[i,j]
        end
    end

    m

end

function pair_items(items)

    n = length(items)

    m = String[]
    for i in 1:(n-1)
        for j in (i+1):n
            push!(m, items[i] * " " * items[j])
        end
        loading_bar(1, n-1, i)
    end

    m

end

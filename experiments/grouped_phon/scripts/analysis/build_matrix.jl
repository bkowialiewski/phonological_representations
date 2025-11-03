function pairwise_similarity(phon, metric)

    n = length(phon)
    f = getfield(Main, Symbol(metric))

    m = zeros(n, n)
    eye!(m)

    for i in 1:(n-1)
        for j in (i+1):n
            m[i,j] = f(phon[i], phon[j])
            m[j,i] = m[i,j]
        end
    end

    m

end

function get_phonology(list, corpus, metric)

    if any(list .== "pèste")
        list[list.=="pèste"] .= "peste"
    end

    if any(list .== "châlet")
        list[list.=="châlet"] .= "chalet"
    end

    if any(list .== "jacquette")
        list[list.=="jacquette"] .= "jaquette"
    end

    n = length(list)

    phon = String[]
    for i in 1:n
        ind = findall(list[i] .== corpus.ortho)[1]
        if metric == "syllable"
            push!(phon, corpus.syll[ind])
        else
            push!(phon, corpus.phon[ind])
        end
    end

    phon

end

eye!(M) = map(i -> M[i,i] = 1.0, 1:size(M,2))

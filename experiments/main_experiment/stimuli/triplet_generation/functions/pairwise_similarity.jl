function pairwise_similarity(phon, metric)

    file_name = "../../../../../building/results/" * metric * ".jld2"
    matrix = load(file_name)["m"]
    map(i -> matrix[i,i] = 0.0, 1:size(matrix, 1))

    n = length(phon)
    f = getfield(Main, Symbol(metric))

    m = NamedArray(zeros(n, n), (phon, phon))
    eye!(m)

    for i in 1:(n-1)
        for j in (i+1):n
            m[i,j] = matrix[phon[i], phon[j]]
            m[j,i] = m[i,j]
        end
    end

    m

end

function get_sim(metric, word1, word2)

    file_name = "../../../../../building/results/" * metric * ".jld2"
    matrix = load(file_name)["m"]
    map(i -> matrix[i,i] = 0.0, 1:size(matrix, 1))

    matrix[word1, word2]

end

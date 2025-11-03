include("to_include.jl")

function extraction()

    metrics = vcat(["slot_coding", "closed_biphone", "levenshtein", "syllable"], "open_biphone_" .* string.(1:5))

    # import lexique database
    file_name = "../../databases/results/lexique_all.csv"
    corpus = CSV.read(file_name, DataFrame)

    files = readdir("data/")
    n_items = 6
    n_rows = 120
    n_trials = 60

    labels = "Item" .* string.(1:n_items)

    df = DataFrame()
    for epoch in 1:length(files)

        file_name = "data/" * files[epoch]
        data = DataFrame(XLSX.readtable(file_name, "Cotation"))
        foreach(col -> replace!(col, "" => missing), [df[!, c] for c in names(df) if eltype(df[!, c]) <: AbstractString])

        ind = 1:2:n_rows
        conditions = data.Condition[ind]
        encoding = data[ind, labels]
        responses = data[ind .+ 1, labels]
        responses = coalesce.(responses, "")

        for i in 1:n_trials

            responses_model = zeros(n_items)

            for j in 1:n_items

                if any(responses[i,j] .== Vector(encoding[i,:]))
                    responses_model[j] = findall(responses[i,j] .== Vector(encoding[i,:]))[1]
                else
                    if responses[i,j] == ""
                        responses_model[j] = n_items+2
                    else
                        responses_model[j] = n_items+1
                    end
                end

            end

            strict = scoring(Vector(encoding[i,:]), Vector(responses[i,:]), "", "strict")
            item = scoring(Vector(encoding[i,:]), Vector(responses[i,:]), "", "item")
            order = scoring(Vector(encoding[i,:]), Vector(responses[i,:]), "", "order")
            omissions = scoring(Vector(encoding[i,:]), Vector(responses[i,:]), "", "omissions")
            extra_list = scoring(Vector(encoding[i,:]), Vector(responses[i,:]), "", "extra_list")

            current = DataFrame(encoding = 1:n_items,
                                positions = 1:n_items,
                                condition = conditions[i],
                                responses = responses_model,
                                strict = strict,              
                                item = item,                  
                                order = order,                
                                omissions = omissions,        
                                extra_list = extra_list,      
                                trial = i,                    
                                ID = epoch)

            # building similarity matrices
            for m in metrics
                phon = get_phonology(Vector(encoding[i,:]), corpus, m)
                sim_X = pairwise_similarity(phon, m)
                sim_X = join(string.(vec(sim_X)), ",")
                current[:,m] .= sim_X
            end

            append!(df, current, promote = true)

        end

    end

    file_name = "results/long.csv"
    CSV.write(file_name, df)

    nothing

end

extraction()

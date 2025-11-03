include("functions/to_include.jl")

function plotting()

    # available models:
    # slot_coding
    # closed_biphone
    # open_biphone
    # levenshtein
    # syllable

    # defining similarity models
    m1 = "levenshtein"
    m2 = "syllable"

    limit = 1_000

    # import the big similarity matrices
    matrices = Dict()
    file_name = "results/" * m1 * ".jld2"
    matrices["m1"] = load(file_name)["m"]
    map(i -> matrices["m1"][i,i] = 0.0, 1:size(matrices["m1"], 1))

    file_name = "results/" * m2 * ".jld2"
    matrices["m2"] = load(file_name)["m"]
    map(i -> matrices["m2"][i,i] = 0.0, 1:size(matrices["m2"], 1))

    labels = intersect(names(matrices["m1"])[1], names(matrices["m2"])[1])

    matrices["m1"] = matrices["m1"][labels, labels]
    matrices["m2"] = matrices["m2"][labels, labels]

    df = DataFrame()
    # for i in 1:(size(matrices["m1"], 1)-1)
    for i in 1:(limit-1)
        for j in (i+1):limit
        # for j in (i+1):size(matrices["m2"], 1)
            append!(df, DataFrame(m1 = matrices["m1"][i,j], m2 = matrices["m2"][i,j]))
        end
    end

    display(df)
    throw("test")

    p = @df df scatter(:m1, :m2, xlab = m1, ylab = m2, legend = false, xlims = [0, 1], ylims = [0, 1])

    file_name = "plots/" * m1 * "_" * m2 * ".png"
    savefig(p, file_name)

    nothing

end

plotting()

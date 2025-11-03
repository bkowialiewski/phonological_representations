function scoring(encoding, recall, pattern, type)

    f = getfield(Main, Symbol(type))
    if type in ["omissions", "extra_list"]
        return f(encoding, recall, pattern)
    else
        return f(encoding, recall)
    end

end

strict(encoding, recall) = Float64.(encoding .== recall)
item(encoding, recall) = Float64.(map(x -> x in encoding, recall))
order(encoding, recall) = [e in recall ? Int(e == r) : NaN for (e, r) in zip(encoding, recall)]
omissions(encoding, recall, pattern) = [Int(r == pattern && !(r in encoding)) for r in recall]
extra_list(encoding, recall, pattern = "") = [Int(r != pattern && !(r in encoding)) for r in recall]

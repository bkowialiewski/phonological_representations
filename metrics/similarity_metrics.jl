using StringDistances

include("syllable.jl")

slot_coding(s1, s2) = slot(collect(s1), collect(s2))
closed_biphone(s1, s2) = normalize(cb(s1), cb(s2))
open_biphone_1(s1, s2) = normalize(ob(s1, 1), ob(s2, 1))
open_biphone_2(s1, s2) = normalize(ob(s1, 2), ob(s2, 2))
open_biphone_3(s1, s2) = normalize(ob(s1, 3), ob(s2, 3))
open_biphone_4(s1, s2) = normalize(ob(s1, 4), ob(s2, 4))
open_biphone_5(s1, s2) = normalize(ob(s1, 5), ob(s2, 5))
levenshtein(s1, s2) = 1 - Levenshtein()(s1, s2)/longest_length(s1, s2)
syllable(s1, s2) = 1 - syl(s1, s2)

function slot(s1, s2)
    l = shortest_length(s1, s2)
    sum(s1[1:l] .== s2[1:l])/longest_length(s1, s2)
end

function cb(s)

    s = collect(s)

    n = length(s)
    b = String[]

    push!(b, string("_", s[1]))  # First biphones
    for i in 2:n
        push!(b, string(s[i-1], s[i]))  # Middle biphones
    end
    push!(b, string(s[n], '_'))  # Last biphones

    unique(b)

end

function ob(s, o)

    s = collect(s)

    n = length(s)
    b = String[]

    push!(b, string("_", s[1]))  # First biphones
    for i in 1:(n-1)
        for j in (i+1):n
            push!(b, string(s[i], s[j]))  # Middle biphones
            if (j - i) > o
                break
            end
        end
    end
    push!(b, string(s[n], "_"))  # Last biphones

    unique(b)

end

normalize(s1, s2) = length(intersect(s1, s2))/longest_length(s1, s2)
shortest_length(s1, s2) = min(length(s1), length(s2))
longest_length(s1, s2) = max(length(s1), length(s2))

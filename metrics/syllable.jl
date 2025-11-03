function syl(s1, s2)

    s1 = split(s1, "-")
    s2 = split(s2, "-")

    l1 = length(s1)
    l2 = length(s2)

    if l1 < l2 || l1 > l2
        n_min = minimum([l1, l2])
        n_max = maximum([l1, l2])
    end
    expand!(s1, s2, "")

    if l1 != l2

        all_dist = zeros(abs(n_min - n_max)+1)
        for i in 0:(abs(n_min - n_max))
            if l1 < l2
                temp = repeat([""], n_max)
                temp[(1+i):(n_min+i)] = s1[1:n_min]
                all_dist[i+1] = decompose(temp, s2)
            else
                temp = repeat([""], n_max)
                temp[(1+i):(n_min+i)] = s2[1:n_min]
                all_dist[i+1] = decompose(s1, temp)
            end
        end

        return minimum(all_dist)

    else
        return decompose(s1, s2)
    end

    nothing

end

function decompose(s1, s2)

    d = 0
    l = 0
    for i in 1:length(s1)

        if any(s1[i] == "" || s2[i] == "")

            m = maximum([length(s1[i]), length(s2[i])])
            l += m
            d += m
            continue

        end

        syl1 = decompose_syllable(s1[i])
        syl2 = decompose_syllable(s2[i])

        map(type -> expand!(syl1[type], syl2[type], ' '), ["onset", "nucleus", "coda"])

        l += sum(map(k -> length(syl1[k]), collect(keys(syl1))))
        d += compare_syllables(syl1, syl2)

    end

    d/l

end

compare_syllables(s1, s2) = sum(map(type -> sum(s1[type] .!= s2[type]), ["onset", "nucleus", "coda"]))

function decompose_syllable(s)

    syl = Dict()

    if length(s) == 0

        syl["onset"] = [' ']
        syl["nucleus"] = [' ']
        syl["coda"] = [' ']

    else

        structure = get_structure(s)
        ind_vowel = findall(collect(structure) .== 'V')

        syl["onset"] = collect(s)[1:(ind_vowel[1]-1)]
        syl["nucleus"] = collect(s)[ind_vowel]
        syl["coda"] = collect(s)[(ind_vowel[end]+1):end]

    end

    syl

end

function get_structure(s)

    structure = collect(repeat("C", length(collect(s))))
    structure[isvowel.(collect(s))] .= 'V'
    join(structure)

end

function expand!(s1, s2, c)

    n1 = length(s1)
    n2 = length(s2)

    if n1 < n2
        map(i -> push!(s1, c), 1:abs(n1-n2))
    elseif n1 > n2
        map(i -> push!(s2, c), 1:abs(n1-n2))
    end

    nothing

end

# isvowel(c) = lowercase(c) in ['a', 'ɪ', 'ə', 'ɔ', 'æ', 'ᵊ', 'i', 'ɒ', 'ʊ', 'u', 'ʌ', 'ɛ', 'ɑ', 'e', 'ɜ']
isvowel(c) = c in ['a', '§', '@', 'i', '°', 'y', 'u', 'o', 'e', '1', '2', '8']
isconsonant(c) = !isvowel(c)

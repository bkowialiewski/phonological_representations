using CSV, DataFrames

function main()

    # import database
    file_name = "lexique.csv"
    database = CSV.read(file_name, DataFrame)

    # we start by replacing redundant phonemes
    # those are too subtle for people to make the distinction
    for i in 1:nrow(database)

        if occursin("O", database.phon[i])
            database.phon[i] = replace(database.phon[i], "O" => "o")
            database.syll[i] = replace(database.syll[i], "O" => "o")
        end

        if occursin("E", database.phon[i])
            database.phon[i] = replace(database.phon[i], "E" => "e")
            database.syll[i] = replace(database.syll[i], "E" => "e")
        end

        if occursin("5", database.phon[i])
            database.phon[i] = replace(database.phon[i], "5" => "1")
            database.syll[i] = replace(database.syll[i], "5" => "1")
        end

        if occursin("9", database.phon[i])
            database.phon[i] = replace(database.phon[i], "9" => "2")
            database.syll[i] = replace(database.syll[i], "9" => "2")
        end

    end

    file_name = "results/lexique_all.csv"
    CSV.write(file_name, database)

    # first replace missing values by something unimportant
    database.cgram = coalesce.(database.cgram, "unknown")
    database.nombre = coalesce.(database.nombre, "unknown")
    database.islem = coalesce.(database.islem, 0)

    # we want to keep only singular nouns being lemmas with more than two phonemes
    ind = database.cgram .== "NOM" .&&
        database.nombre .== "s" .&&
        database.islem .== 1 .&&
        length.(database.phon) .> 2
    database = database[ind,:]
    database = unique(database, :phon)

    # get the log of the frequency and fort dataframe on that basis
    database.logfreq = log.(database.freqlemfilms2 .+ 0.0001)
    sort!(database, [:logfreq], rev = true)

    # get the N most frequent entries
    database = database[1:3_000,:]
    file_name = "results/lexique_reduced.csv"
    CSV.write(file_name, database)

    nothing

end

main()

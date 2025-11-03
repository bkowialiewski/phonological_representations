function get_triplets(df, corpus, n_triplets, n_items)

    triplets_ortho = fill("", n_triplets, n_items)
    triplets_phon = fill("", n_triplets, n_items)
    for i in 1:length(levels(df.triplet_number))
        temp = df[df.triplet_number .== i,:]
        triplets_ortho[i,:] = unique([temp.item1; temp.item2])
        for j in 1:n_items
            triplets_phon[i,j] = corpus.phon[findall(triplets_ortho[i,j] .== corpus.ortho)[1]]
        end
    end

    triplets_ortho, triplets_phon

end

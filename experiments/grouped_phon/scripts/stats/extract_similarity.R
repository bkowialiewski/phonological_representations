extract_similarity = function() {

    n_items = 6

    file_name = file.path("results", "long.csv")
    df = read.csv(file_name)

    models = c("slot_coding", "levenshtein", "syllable", "closed_biphone", paste0("open_biphone_", 1:5))

    all_values = data.frame()
    for (m in models) {

        print(m)

        temp = data.frame()

        all_sim = 0
        n_trials = length(levels(as.factor(df$trial)))
        for (i in 1:n_trials) {

            current_trial = df[df$trial == i,]
            current_trial = current_trial[1,]

            condition = current_trial$condition
            current = to_matrix(current_trial[[m]], n_items)
            
            if (condition == "grouped") {
                ind_1 = 1:3
                ind_2 = 4:6
            } else if (condition == "interleaved") {
                ind_1 = seq(1, n_items, 2)
                ind_2 = seq(2, n_items, 2)
            } else if (condition == "different") {
                ind = 1:n_items
            }

            if (condition == "different") {
                sim = get_sim(current, ind)
            } else {
                sim = mean(c(get_sim(current, ind_1), get_sim(current, ind_2)))
            }

            temp = rbind(temp, data.frame(metric = m, value = sim, condition = condition))

        }

        different = round(mean(temp$value[temp$condition == "different"]), digits = 3)
        grouped = round(mean(temp$value[temp$condition == "grouped"]), digits = 3)
        interleaved = round(mean(temp$value[temp$condition == "interleaved"]), digits = 3)

        all_values = rbind(all_values,
                           data.frame(Metric = m,
                                      Dissimilar = different,
                                      Grouped = grouped,
                                      Interleaved = interleaved))

    }

    file_name = file.path("results", "similarity_values.csv")
    write.csv(all_values, file_name, row.names = FALSE, quote = FALSE)

}

to_matrix = function(s, n) {
    matrix(as.numeric(strsplit(s, ',')[[1]]), n, n)
}

get_sim = function(m, ind) {
    sum = 0
    cnt = 0
    for (i in ind) {
        for (j in ind) {
            if (i != j) {
                sum = sum + m[i,j]
                cnt = cnt + 1
            }
        }
    }
    return(sum/cnt)
}

extract_similarity()

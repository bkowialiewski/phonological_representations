plot_similarity = function() {

    require("ggplot2")
    require("ggthemes")

    n_items = 6

    file_name = file.path("results", "long.csv")
    df = read.csv(file_name)

    reference = "syllable"

    models = c("slot_coding", "levenshtein", "syllable", "closed_biphone", "open_biphone_1")
    labels = c("Slot coding", "Levenshtein", "Syllable", "Closed biphone", "Open biphone 1")

    n_subjects = length(levels(as.factor(df[["ID"]])))

    final = data.frame()
    for (i in 1:nrow(df)) {

        if (df[["positions"]][i] != 1) {
            next
        }

        temp = data.frame(matrix(nrow = triang(n_items), ncol = 0))
        for (m in models) {
            current_matrix = to_matrix(df[[m]][i], n_items)
            temp[[m]] = get_pairs(current_matrix, n_items)
        }

        if (df[["condition"]][i] == "interleaved" || df[["condition"]][i] == "grouped") {
            temp[["condition"]] = "similar"
        } else {
            temp[["condition"]] = "dissimilar"
        }

        final = rbind(final, temp)

    }

    differences = data.frame()
    for (m in models) {
        differences = rbind(differences, data.frame(score = final[[reference]] - final[[m]],
                                                    condition = final[["condition"]],
                                                    model = m))
    }

    differences[["model"]] = as.factor(differences[["model"]])
    differences[["model"]] = factor(differences[["model"]], levels = models)

    g = ggplot(differences, aes(x = score))
    g = g + geom_histogram()
    g = g + facet_wrap(. ~ model,
                       labeller = labeller(model = as_labeller(c("slot_coding" = labels[1],
                                                                     "levenshtein" = labels[2],
                                                                     "syllable" = labels[3],
                                                                     "closed_biphone" = labels[4],
                                                                     "open_biphone_1" = labels[5]
                                                                     ))))
    g = g + xlab("Differences") + ylab("count")
    g = g + guides(x = guide_axis(cap = "both"),
                   y = guide_axis(cap = "both"))
    g = g + theme(axis.ticks.length=unit(5, "pt"))
    g = g + theme_few()

    file_name = file.path("plots", "difference_metrics.svg")
    ggsave(file_name, g, width = 6.5, height = 4)

    print(g)

}

to_matrix = function(s, n) {
    matrix(as.numeric(strsplit(s, ',')[[1]]), n, n)
}

triang = function(n) {
    return((n*(n-1))/2)
}

get_pairs = function(m, n) {

    pairs = NULL
    for (i in 1:(n-1)) {
        for (j in (i+1):n) {
            pairs = c(pairs, m[i,j])
        }
    }

    return(pairs)

}

plot_similarity()

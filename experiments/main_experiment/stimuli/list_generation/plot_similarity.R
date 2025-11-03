plot_similarity = function() {

    require("ggplot2")
    require("ggthemes")

    file_name = file.path("results", "similarity_values.csv")
    df = read.csv(file_name)

    models = c("slot_coding", "levenshtein", "syllable", "closed_biphone", "open_biphone_1")
    labels = c("Slot coding", "Levenshtein", "Syllable", "Closed biphone", "Open biphone 1")

    reference = "syllable"

    differences = data.frame()
    n = length(models)
    comparison_labels = NULL
    for (i in 1:(n-1)) {
        for (j in (i+1):n) {
            current_comparison = paste0(labels[i], " vs. \n", labels[j])
            differences = rbind(differences, data.frame(score = df[[models[i]]] - df[[models[j]]],
                                                        condition = df[["condition"]],
                                                        comparison = current_comparison))
            comparison_labels = c(comparison_labels, current_comparison)
        }
    }

    differences[["comparison"]] = as.factor(differences[["comparison"]])
    differences[["comparison"]] = factor(differences[["comparison"]], levels = comparison_labels)

    g = ggplot(differences, aes(x = score))
    g = g + geom_histogram()
    g = g + facet_wrap(. ~ comparison,
                       labeller = labeller(comparison = as_labeller(c("slot_coding" = labels[1],
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
    ggsave(file_name, g, width = 8, height = 6.5)

}

plot_similarity()

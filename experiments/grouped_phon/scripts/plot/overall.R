overall = function() {

    require("ggplot2")
    require("papaja")
    require("ggthemes")

    scores = c("item", "order")

    file_name = file.path("results", "long.csv")
    df = read.csv(file_name)

    merged = data.frame()
    for (i in 1:length(scores)) {
        merged = rbind(merged, summarize_data(scores[i], df))
    }

    g = generate_plot(merged)

    file_name = file.path("plots", "overall.svg")
    ggsave(file_name, g, width = 5, height = 3)

}

generate_plot = function(df) {

    g = ggplot(df, aes(x = condition, y = score, group = 1))
    g = g + geom_line(linewidth = 1) + geom_point(size = 2.0)
    g = g + geom_errorbar(aes(ymin = score - CI, ymax = score + CI), width = 0.15)
    g = g + facet_grid(. ~ criterion,
                       labeller = labeller(criterion = as_labeller(c("item" = "Item recall",
                                                                     "order" = "Order recall"))))
    g = g + guides(x = guide_axis(cap = "both"),
                   y = guide_axis(cap = "both"))
    g = g + scale_y_continuous(limits = c(0.5, 1.0),
                               breaks = seq(0.5, 1.0, 0.1),
                               expand = expansion(mult = c(0.05, 0.1)))
    g = g + coord_cartesian(ylim = c(0.5, 1))
    g = g + xlab("Similarity condition") + ylab("p(correct)")
    g = g + theme_few()
    g = g + labs(color="Condition")
    g = g + theme(axis.ticks.length=unit(5, "pt"))
    g = g + scale_x_discrete(labels = c("Dissimilar", "Grouped", "Interleaved"))

    return(g)

}

summarize_data = function(score, df) {

    df[["score"]] = df[[score]]

    formula = score ~ condition + ID
    temp = aggregate(formula, df, FUN = mean)

    CI = wsci(temp, "ID", c("condition"), "score", level = 0.95, method = "Morey")
    formula = score ~ condition
    agg = aggregate(df, formula, FUN = mean)
    agg[["CI"]] = CI[["score"]]
    agg[["criterion"]] = score

    return(agg)

}

overall()

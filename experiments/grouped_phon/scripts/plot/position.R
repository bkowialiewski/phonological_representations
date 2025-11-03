position = function() {

    require("ggplot2")
    require("papaja")

    score = "order"

    file_name = file.path("results", "long.csv")
    data = read.csv(file_name)
    data[["score"]] = data[[score]]

    formula = score ~ condition + positions + ID
    df = aggregate(formula, data, FUN = mean)

    CI = wsci(df, "ID", c("condition", "positions"), "score", level = 0.95, method = "Morey")
    formula = score ~ condition + positions
    agg = aggregate(data, formula, FUN = mean)
    agg[["CI"]] = CI[["score"]]

    print(agg)
    stop()

    g = ggplot(data = agg, aes(x = condition, y = order, group = 1))
    g = g + geom_line(linewidth = 1) + geom_point(size = 2.0)
    g = g + geom_errorbar(aes(ymin = order - CI, ymax = order + CI), width = 0.15)
    g = g + guides(x = guide_axis(cap = "both"),
                   y = guide_axis(cap = "both"))
    g = g + scale_y_continuous(limits = c(0.5, 1.0),
                               breaks = seq(0.5, 1.0, 0.1),
                               expand = expansion(mult = c(0.05, 0.1)))
    g = g + coord_cartesian(ylim = c(0.5, 1))
    g = g + xlab("Similarity condition") + ylab("p(correct)")
    g = g + theme_classic()
    g = g + labs(color="Condition")
    g = g + theme(axis.ticks.length=unit(5, "pt"))
    g = g + scale_x_discrete(labels = c("Dissimilar", "Grouped", "Interleaved"))

    file_name = file.path("plots", "overal.svg")
    ggsave(file_name, g, width = 3, height = 3)
    print(g)

}

position()

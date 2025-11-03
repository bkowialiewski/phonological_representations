plot_position = function() {

    require("ggplot2")
    require("ggthemes")

    types = c("item", "order")
    labels = c("Item recall", "Order recall")

    for (i in 1:length(types)) {

        df = summarize_data(types[i])
        g = generate_plot(df, labels[i])

        file_name = file.path("plots", paste0("position_", types[i], ".svg"))
        ggsave(file_name, g, width = 7, height = 4)

    }

}

summarize_data = function(type) {

    file_name = file.path("model", "results", "simulate.csv")
    model = read.csv(file_name)
    model[["score"]] = model[[type]]

    file_name = file.path("..", "experiments", "grouped_phon", "results", "long.csv")
    empirical = read.csv(file_name)
    empirical[["score"]] = empirical[[type]]

    formula = score ~ condition + positions
    agg_model = aggregate(formula, model, FUN = mean)
    agg_model$type = "Model"

    formula = score ~ condition + positions
    agg_empirical = aggregate(formula, empirical, FUN = mean)
    agg_empirical$type = "Data"

    return(rbind(agg_model, agg_empirical))

}

generate_plot = function(df, title) {

    n_items = max(df[["positions"]])

    g = ggplot(df, aes(x = positions, y = score, linetype = type, color = condition))
    g = g + geom_line(linewidth = 1) + geom_point(size = 2.0)
    g = g + guides(x = guide_axis(cap = "both"),
                   y = guide_axis(cap = "both"))
    g = g + scale_x_continuous(limits = c(1,n_items),
                               breaks = seq(1, n_items, 1))
    g = g + scale_y_continuous(limits = c(0.0, 1.0),
                               breaks = seq(0.0, 1.0, 0.1),
                               expand = expansion(mult = c(0.05, 0.1)))
    g = g + geom_line(linewidth = 1.0)
    g = g + theme(axis.ticks.length=unit(5, "pt"))
    g = g + theme_few()
    g = g + facet_grid(. ~ type)
    g = g + scale_color_manual(values=c("#8da0cb", "#fc8d62", "#66c2a5"), labels = c("Dissimilar", "Grouped", "Interleaved"))
    g = g + labs(x = "Serial position", y = "p(correct)", color = "Similarity condition", linetype = "Type")
    g = g + ggtitle(title) + theme(plot.title = element_text(hjust = 0.5))

}

plot_position()

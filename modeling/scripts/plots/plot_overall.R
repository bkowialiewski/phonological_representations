plot_overall = function() {

    require("ggplot2")
    require("ggthemes")

    types = c("item", "order")
    labels = c("Item recall", "Order recall")

    for (i in 1:length(types)) {

        df = summarize_data(types[i])
        g = generate_plot(df, labels[i])

        file_name = file.path("plots", paste0("overall_", types[i], ".svg"))
        ggsave(file_name, g, width = 8, height = 7)

    }

}

summarize_data = function(type) {

    file_name = file.path("model", "results", "model_comparison.csv")
    AIC = read.csv(file_name)
    AIC = AIC[order(AIC$AIC),]
    all_metrics = AIC$metric

    all_metrics = list()
    all_metrics[["syllable"]] = "Syllable"
    all_metrics[["levenshtein"]] = "Levenshtein"
    all_metrics[["slot_coding"]] = "Slot coding"
    all_metrics[["closed_biphone"]] = "Closed biphone"
    all_metrics[["open_biphone_1"]] = "Open biphone 1"
    all_metrics[["open_biphone_2"]] = "Open biphone 2"
    all_metrics[["open_biphone_3"]] = "Open biphone 3"
    all_metrics[["open_biphone_4"]] = "Open biphone 4"
    all_metrics[["open_biphone_5"]] = "Open biphone 5"

    file_name = file.path("model", "results", "simulate.csv")
    model = read.csv(file_name)
    model[["score"]] = model[[type]]

    file_name = file.path("..", "experiments", "grouped_phon", "results", "long.csv")
    empirical = read.csv(file_name)
    empirical[["score"]] = empirical[[type]]

    formula = score ~ condition + metric
    agg_model = aggregate(formula, model, FUN = mean)
    agg_model$type = "Model"

    formula = score ~ condition
    agg_empirical = aggregate(formula, empirical, FUN = mean)
    agg_empirical$type = "Data"
    agg_empirical$metric = ""

    df = data.frame()
    for (m in names(all_metrics)) {
        temp = rbind(agg_model[agg_model$metric == m,], agg_empirical)
        temp$metric = all_metrics[[m]]
        df = rbind(df, temp)
    }

    df$metric = factor(df$metric, levels = unlist(all_metrics))

    return(df)

}

generate_plot = function(df, title) {

    g = ggplot(df, aes(x = condition, y = score, linetype = type, group = type))
    g = g + geom_line(linewidth = 1) + geom_point(size = 2.0)
    g = g + guides(x = guide_axis(cap = "both"),
                   y = guide_axis(cap = "both"))
    g = g + scale_y_continuous(limits = c(0.5, 1.0),
                               breaks = seq(0.5, 1.0, 0.1),
                               expand = expansion(mult = c(0.05, 0.1)))
    g = g + geom_line(linewidth = 1.0)
    g = g + theme(axis.ticks.length=unit(5, "pt"))
    g = g + theme_few()
    g = g + facet_wrap(. ~ metric)
    g = g + scale_x_discrete(labels = c("Dissimilar", "Grouped", "Interleaved"))
    g = g + labs(x = "Condition", linetype = "Type")
    g = g + ggtitle(title) + theme(plot.title = element_text(hjust = 0.5))

    return(g)

}

plot_overall()

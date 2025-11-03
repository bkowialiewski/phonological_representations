plot_individual = function() {

    require("ggplot2")
    require("RColorBrewer")

    file_name = file.path("results", "model_comparison.csv")
    AIC = read.csv(file_name)
    AIC = AIC[order(AIC$AIC),]
    all_metrics = AIC$metric

    file_name = file.path("results", "simulate.csv")
    model = read.csv(file_name)

    file_name = file.path("..", "experiments", "grouped_phon", "results", "long.csv")
    empirical = read.csv(file_name)

    formula = order ~ condition + metric + ID
    agg_model = aggregate(formula, model, FUN = mean)
    agg_model$type = "model"

    formula = order ~ condition + ID
    agg_empirical = aggregate(formula, empirical, FUN = mean)
    agg_empirical$type = "empirical"
    agg_empirical$metric = ""

    df = data.frame()
    for (i in 1:length(all_metrics)) {
        df = rbind(df, data.frame(empirical = agg_empirical$order,
                                  model = agg_model[agg_model$metric == all_metrics[i],]$order,
                                  condition = agg_empirical$condition,
                                  metric = all_metrics[i],
                                  ID = agg_empirical$ID))
    }

    df$metric = factor(df$metric, levels = all_metrics)

    g = ggplot(df, aes(x = model, y = empirical, color = condition, group = condition))
    g = g + geom_point(size = 1)
    g = g + guides(x = guide_axis(cap = "both"),
                   y = guide_axis(cap = "both"))
    g = g + scale_y_continuous(limits = c(0.0, 1.0),
                               breaks = seq(0.0, 1.0, 0.2),
                               expand = expansion(mult = c(0.05, 0.1)))
    g = g + scale_x_continuous(limits = c(0.0, 1.0),
                               breaks = seq(0.0, 1.0, 0.2),
                               expand = expansion(mult = c(0.05, 0.1)))
    # g = g + theme_classic()
    g = g + theme(axis.ticks.length=unit(5, "pt"))
    g = g + labs(color="Condition")
    g = g + facet_wrap(. ~ metric)
    g = g + geom_smooth(method = "lm", se = TRUE)
    g = g + scale_color_manual(values=c("#8da0cb", "#fc8d62", "#66c2a5"))
    g = g + theme(legend.position = c(0.8,0.225),
                  legend.key = element_blank(),
                  legend.background = element_blank())

    file_name = file.path("plots", "correlation.svg")
    ggsave(file_name, width = 8, height = 6)

    print(g)

}

plot_individual()

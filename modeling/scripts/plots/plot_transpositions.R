plot_transpositions = function() {

    require("ggplot2")
    require("gridExtra")

    file_name = file.path("results", "model_comparison.csv")
    AIC = read.csv(file_name)
    AIC = AIC[order(AIC$AIC),]
    all_metrics = AIC$metric

    file_name = file.path("results", "simulate.csv")
    model = read.csv(file_name)

    file_name = file.path("..", "experiments", "grouped_phon", "results", "long.csv")
    empirical = read.csv(file_name)

    formula = cbind(within_grouped, within_interleaved) ~ condition + metric + ID
    agg_model = aggregate(formula, data = model, FUN = mean)
    agg_model$type = "model"

    agg_empirical = analyze_within(empirical)
    agg_empirical$type = "empirical"
    agg_empirical$metric = ""

    df = data.frame()
    for (i in 1:length(all_metrics)) {
        temp = rbind(agg_model[agg_model$metric == all_metrics[i],], agg_empirical)
        temp$metric = all_metrics[i]
        df = rbind(df, temp)
    }

    df$metric = factor(df$metric, levels = all_metrics)

    formula = cbind(within_grouped, within_interleaved) ~ condition + metric + type
    df = aggregate(formula, df, FUN = mean)

    df_grouped = df[df$condition %in% c("different", "grouped"),]
    df_interleaved = df[df$condition %in% c("different", "interleaved"),]

    for (i in 1:2) {

        if (i == 1) {
            g = ggplot(df_grouped, aes(x = condition, y = within_grouped, linetype = type, group = type))
        } else {
            g = ggplot(df_interleaved, aes(x = condition, y = within_interleaved, linetype = type, group = type))
        }

        g = g + geom_point(size = 2.5)
        g = g + guides(x = guide_axis(cap = "both"),
                       y = guide_axis(cap = "both"))
        g = g + scale_y_continuous(limits = c(0.0, 1.0),
                                   breaks = seq(0.0, 1.0, 0.2),
                                   expand = expansion(mult = c(0.05, 0.1)))
        g = g + geom_line(linewidth = 1.0)
        g = g + theme(axis.ticks.length=unit(5, "pt"))
        g = g + labs(color="Condition")
        g = g + facet_wrap(. ~ metric)
        g = g + theme(legend.position = c(0.8,0.225),
                      legend.key = element_blank(),
                      legend.background = element_blank())

        if (i == 1) {
        g = g + ggtitle("AAABBB")
        } else {
        g = g + ggtitle("ABABAB")
        }

        assign(paste0("g",i), g)

    }

    g = grid.arrange(g1, g2, nrow = 1)
    file_name = file.path("plots", "within.svg")
    ggsave(file_name, g, width = 11, height = 6)

    print(g)

}

analyze_within = function(df) {

    to_keep = c("encoding", "positions", "condition", "responses", "trial", "ID")
    conditions = c("different", "grouped", "interleaved")

    df = df[,to_keep]

    df$ID = as.factor(df$ID)
    df$trial = as.factor(df$trial)

    n_items = max(df$positions)
    n_subjects = length(levels(df$ID))

    df_within = data.frame()
    for (i in 1:n_subjects) {

        current_subject = df[df$ID == i,]
        n_trials = length(levels(current_subject$trial))

        IOX = list()
        for (c in conditions) {
            IOX[[c]] = matrix(0.0, n_items+2, n_items)
        }

        for (j in 1:n_trials) {
            current_trial = current_subject[current_subject$trial == j,]
            current_condition = current_trial$condition[1]
            IOX[[current_condition]] = IOX[[current_condition]] + get_IOX(n_items, current_trial)
        }

        for (c in conditions) {
            df_within = rbind(df_within, data.frame(within_grouped = get_within(IOX[[c]], "AAABBB"),
                                                    within_interleaved = get_within(IOX[[c]], "ABABAB"),
                                                    condition = c,
                                                    ID = i))
        }

    }

    df_within

}

get_IOX = function(n_items, df) {

    IOX = matrix(0.0, n_items+2, n_items)
    for (i in 1:n_items) {
        IOX[df$responses[i],i] = IOX[df$responses[i],i] + 1
    }

    return(IOX)

}

get_within = function(IOX, pattern) {

    n_items = ncol(IOX)

    if (pattern == "AAABBB") {
        ind_1 = 1:(n_items/2)
        ind_2 = ind_1 + (n_items/2)
    } else if (pattern == "ABABAB") {
        ind_1 = seq(1, n_items, 2)
        ind_2 = ind_1 + 1
    }

    diag(IOX) = 0.0
    (sum(IOX[ind_1,ind_1]) + sum(IOX[ind_2, ind_2])) / sum(IOX[1:n_items, 1:n_items])

}

plot_transpositions()

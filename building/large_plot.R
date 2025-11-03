large_plot = function() {

    require("ggplot2")
    require("ggthemes")

    file_name = file.path("results", "all_correlations.csv")
    df = read.csv(file_name)

    g = ggplot(df, aes(x = m1, y = m2))
    g = g + geom_point(size = 1) + xlim(c(0,1)) + ylim(c(0,1))
    g = g + xlab("Model 1") + ylab("Model 2")
    g = g + facet_wrap(. ~ label, nrow = 4)
    g = g + theme_few()


    file_name = "plots/all_models.png"
    ggsave(file_name, width = 8, height = 9)

}

large_plot()

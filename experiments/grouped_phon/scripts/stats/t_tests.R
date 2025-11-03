t_tests = function() {

    require("BayesFactor")

    criterion = "order"
    conditions = c("different", "interleaved", "grouped")

    file_name = file.path("results", "long.csv")
    df = read.csv(file_name, sep = ',', dec = '.')
    df[["score"]] = df[[criterion]]

    formula = score ~ condition + ID
    agg = aggregate(formula, df, FUN = mean)

    n = length(conditions)
    for (i in 1:(n-1)) {
        for (j in (i+1):n) {
            x = agg[["score"]][agg[["condition"]] == conditions[i]]
            y = agg[["score"]][agg[["condition"]] == conditions[j]]
            difference = x - y
            bf = exp(ttestBF(difference)@bayesFactor$bf)
            print(paste0(conditions[i], " vs. ", conditions[j], " = ", round(bf, digits = 3)))
        }
    }

}

t_tests()

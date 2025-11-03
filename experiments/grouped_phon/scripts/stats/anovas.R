anovas = function() {

    require("brms")

    score = "order" # item, order
    type = "compare" # fitting, compare

    file_name = file.path("results", "long.csv")
    df = read.csv(file_name, sep = ',', dec = '.')
    df[["score"]] = df[[score]]

    if (type == "fitting") {
        fit_models(df, score)
    } else if (type == "compare") {
        compare_models(score)
    }

}

compare_models = function(score) {

    m1 = readRDS(file = file.path("results", "anovas", paste0("m1_", score, ".rds")))
    m2 = readRDS(file = file.path("results", "anovas", paste0("m2_", score, ".rds")))

    bf12 = bayes_factor(m1, m2, log = FALSE)[["bf"]]

    print(paste0("m1 vs. m2: ", bf12, "; ", 1/bf12))

}

fit_models = function(df, score) {

    # full model
    formula = score ~ condition + (1 + condition | ID)
    m1 = launch_model(df, formula)
    saveRDS(m1, file = file.path("results", "anovas", paste0("m1_", score, ".rds")))

    # without the main effect of condition
    formula = score ~ (1 + condition | ID)
    m2 = launch_model(df, formula)
    saveRDS(m2, file = file.path("results", "anovas", paste0("m2_", score, ".rds")))

}

launch_model = function(data, formula) {

    return(brm(formula,
               family = bernoulli(link = "logit"),
               data = data,
               save_all_pars = TRUE,
               iter = 10^4,
               cores = 8,
               control = list(adapt_delta = 0.95))
    )

}

anovas()

regression = function() {

    require("lme4")
    require("MuMIn")

    file_name = file.path("results", "long.csv")
    df = read.csv(file_name)


    all_models = c("slot_coding", "levenshtein", "syllable", "closed_biphone", paste0("open_biphone_", 1:5))
    for (m in all_models) {
        current = paste0(m, "_avg")
        df[[current]] = 0.0
        for (i in 1:nrow(df)) {
            current_position = df[i,"positions"]
            sim_X = to_matrix(df[i,m])
            df[i,current] = mean(sim_X[current_position,])
        }
    }

    df[["slot_coding_avg"]] = standardize(df[["slot_coding_avg"]])
    df[["levenshtein_avg"]] = standardize(df[["levenshtein_avg"]])
    df[["syllable_avg"]] = standardize(df[["syllable_avg"]])
    df[["closed_biphone_avg"]] = standardize(df[["closed_biphone_avg"]])
    df[["open_biphone_1_avg"]] = standardize(df[["open_biphone_1_avg"]])

    m1 = glmer(order ~ slot_coding_avg + (1 + slot_coding_avg | ID), data = df, family = binomial)
    m2 = glmer(order ~ levenshtein_avg + (1 + levenshtein_avg | ID), data = df, family = binomial)
    m3 = glmer(order ~ syllable_avg + (1 + syllable_avg | ID), data = df, family = binomial)
    m4 = glmer(order ~ closed_biphone_avg + (1 + closed_biphone_avg | ID), data = df, family = binomial)
    m5 = glmer(order ~ open_biphone_1_avg + (1 + open_biphone_1_avg | ID), data = df, family = binomial)

    print(r.squaredGLMM(m1))
    print(r.squaredGLMM(m2))
    print(r.squaredGLMM(m3))
    print(r.squaredGLMM(m4))
    print(r.squaredGLMM(m5))

    print(BIC(m1))
    print(BIC(m2))
    print(BIC(m3))
    print(BIC(m4))
    print(BIC(m5))

    return(NULL)

}

to_matrix = function(s) {
    v = as.numeric(strsplit(s, ',')[[1]])
    n = sqrt(length(v))
    return(matrix(v, ncol = n, nrow = n))
}

standardize = function(x) {
    return(difference(x)/sd(x))
}

difference = function(x) {
    return(x - mean(x))
}

regression()

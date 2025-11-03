include("functions/to_include.jl")

function model_comparison()

    file_name = "results/fitting.csv"
    data = CSV.read(file_name, DataFrame)

    free_parameters = length(levels(data.parameter_name))
    K = free_parameters * length(levels(data.ID))

    df = combine(groupby(data, [:metric, :ID]), :error => mean => :error)

    df = combine(groupby(df, :metric),
                 :error => (x -> round.(compute_AIC(x, K), digits = 3)) => :AIC)

    df.delta_AIC .= round.(df.AIC .- minimum(df.AIC), digits = 3)
    df.wAIC = compute_weight(df.delta_AIC)
    df.strength = maximum(df.wAIC) ./ df.wAIC

    file_name = "results/model_comparison.csv" 
    CSV.write(file_name, df)

    nothing

end

compute_AIC(x, K) = 2*K + sum(x)
compute_BIC(x, K) = K * log(length(x)) + sum(x)
compute_weight(delta) = exp.(-0.5*delta) ./ sum(exp.(-0.5*delta))
get_relative(m1, m2, df) = df.wAIC[df.metric .== m1][1] / df.wAIC[df.metric .== m2][1]
model_comparison()

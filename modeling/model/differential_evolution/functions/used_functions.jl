function hyperbol(parameters::Dictionary{String, Parameters})

    error = 0.0
    for key in keys(parameters)
        error += parameters[key].value^2.0
    end

    return error::Float64

end

function rastrigin(parameters::Dictionary{String, Parameters})

    error = 0.0
    for key in keys(parameters)
        error += (parameters[key].value ^ 2.0) - (10.0 * cos(2.0 * pi * parameters[key].value))
    end

    return (10.0 * length(parameters) + error)::Float64

end

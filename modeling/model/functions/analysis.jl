function analysis(n, IOX)

    strict = map(i -> IOX[i,i], 1:n)
    item = sum(IOX[1:n,:], dims = 1)[:]
    order = strict ./ item

    DataFrame(
        :strict => strict,
        :item => item,
        :order => order,
        :within_grouped => within_transpositions(IOX, "AAABBB", n),
        :within_interleaved => within_transpositions(IOX, "ABABAB", n),
        :positions => 1:n,
    )

end

function within_transpositions(IOX, pattern, n)

    IOX_temp = copy(IOX)
    map(i -> IOX_temp[i,i] = 0.0, 1:n)

    if pattern == "AAABBB"
        ind_1 = 1:Int64(n/2) 
        ind_2 = ind_1 .+ Int64(n/2)
    elseif pattern == "ABABAB"
        ind_1 = 1:2:n
        ind_2 = ind_1 .+ 1
    end

    (sum(IOX_temp[ind_1,ind_1]) .+ sum(IOX_temp[ind_2,ind_2])) / sum(IOX_temp)

end

function plotting(results)

    p = @df results plot(:condition, [:order],
                         group = :type,
                         ylims = [0.0, 1.0],
                         markershape = :circle,
                         lw = 2)
    display(p)

    nothing

end

# function plotting(results::DataFrame)
#
#     n_items = maximum(results.positions)
#
#     p = @df results plot(:positions, [:strict, :item, :order],
#                          xlabel = "Serial position", ylabel = "p(responses)",
#                          legend = :bottomright, lw = 2, markershape = :circle,
#                          label = ["Strict" "Item" "Order"],
#                          ylims = [0.0, 1.0],
#                          xlab = "Serial position",
#                          ylab = "p(correct)")
#
#     display(p)
#
#     nothing
#
# end

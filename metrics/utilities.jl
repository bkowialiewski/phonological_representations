eye!(M) = map(i -> M[i,i] = 1.0, 1:size(M,2))

function loading_bar(start::Number, finish::Number, current::Number)

    n = 40
    proportion_done = (current - start) / (finish - start)
    done_display = floor(n * proportion_done)
    percentage = floor((done_display/n) * 100)

    to_display = ""
    for i in 1:n 
        if (i <= done_display) 
            to_display = to_display * "="
        else
            to_display = to_display * " "
        end
    end

    to_display = "[" * to_display * "] " * string(percentage) * "%"

    # print status
    print('\r',to_display)
    if percentage >= 100
        println("")
    end

end


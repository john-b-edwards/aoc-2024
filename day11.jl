# input
include("Utils.jl")
using .Utils
input = get_input(2024,11)[1]
# part one
function process_loop(x)
    dig = length(digits(x))
    if x == 0
        return [1]
    elseif dig % 2 == 0
        return [Int(floor(x / 10 ^ (dig/2))), Int(x - floor(x / 10 ^ (dig/2)) * 10 ^ (dig/2))]
    else
        return [x * 2024]
    end
end
function my_loop(input, times)
    loop_counts = Dict(i => sum(input .== i) for i in unique(input))
    for n in 1:times
        new_dict = Dict()
        for x in keys(loop_counts)
            count = loop_counts[x]
            vals = process_loop(x)
            for val in vals
                new_dict[val] = get(new_dict, val, 0) + count
            end
        end
        loop_counts = new_dict
    end
    return sum([loop_counts[x] for x in keys(loop_counts)])
end
println(my_loop(input, 25))
# part two
println(my_loop(input, 75))

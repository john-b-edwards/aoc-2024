# input
include("Utils.jl")
using .Utils
input = get_input(2024,2)
# part one 
# this function tests that an input line is "safe"
# it uses a vector of differences between values
test(diffs) = (all(diffs .> 0) | all(diffs .< 0)) & all(abs.(diffs) .!= 0) & all(abs.(diffs) .< 4)
# apply to each line of the input and find how many inputs are safe
println(sum(test.(diff.(input))))
# part two
# for part two, go through all vector pairs
function parse_two(line)
    safe = test(diff(line))
    # if it's not safe, check for fallbacks
    if !safe
        # go through all unsafe lines and test if there's a removable value
        new_diffs = [diff(my_new_vec) for my_new_vec in [line[1:end .!= k] for k in eachindex(line)]]
        # retest all values if there's any removable
        safe = any(test.(new_diffs))
    end
    return safe
end
println(sum(parse_two.(input)))
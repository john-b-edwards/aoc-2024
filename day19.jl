# input
include("Utils.jl")
using .Utils
using ProgressBars
input = get_input(2024,19)
# part one
patterns = [string(x) for x in split(join(input[1]),",")]
designs = [x[1] for x in input[2:end]]
stored = Dict()
function is_valid(s)
    if s in keys(stored) return stored[s] end
    ans = 0
    if s == "" ans = 1 end
    for p in patterns
        if occursin(Regex("^" * p), s)
            ans = ans + is_valid(replace(s, p=>"",count=1))
        end
    end
    stored[s] = ans
    return ans
end
println(sum(is_valid.(designs) .> 0))
# part two 
println(sum(is_valid.(designs)))
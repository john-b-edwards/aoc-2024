# input
include("Utils.jl")
using .Utils
input = get_input(2024,19)
# part one
patterns = [string(x) for x in split(join(input[1]),",")]
designs = [x[1] for x in input[2:end]]
counter = 0
stored = Dict()
# h/t https://stackoverflow.com/questions/5996621/algorithm-for-checking-if-a-string-was-built-from-a-list-of-substrings
function is_valid(s, w)
    if s == "" return true
    elseif s in keys(stored) return stored[s]
    else 
        global stored[s] = false
        for n in w
            if (length(n) <= length(s)) &&
                (s[1:length(n)] == n) & is_valid(s[length(n)+1:end], w)
                global stored[s] = true
            end
        end
        return stored[s]
    end
end
println(sum(is_valid.(designs, [patterns])))
# part two
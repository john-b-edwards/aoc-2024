# input
include("Utils.jl")
using .Utils
input = get_input(2024,10,false)
input = split.(input,"")
input = [parse.(Int64, x) for x in input]
input = mapreduce(permutedims, vcat, input)
trailheads = findall(x->x == 0, input)
# part one
function find_path(trailhead, input, unique_paths)
    found, queue = [], [trailhead]
    while queue != []
        v = pop!(queue)
        if input[v] == 9
            push!(found, v)
        else
            for i in -1:1, j in -1:1
                if (abs(i) != abs(j)) && 
                    (v[1] + i > 0) & 
                    (v[1] + i <= size(input)[1]) & 
                    (v[2] + j > 0) & 
                    (v[2] + j <= size(input)[2]) && 
                    (input[v[1] + i, v[2] + j] == input[v] + 1)
                    push!(queue, CartesianIndex(v[1] + i, v[2] + j))
                end
            end
        end
    end
    return ifelse(unique_paths, length(unique(found)), length(found))
end
println(sum(find_path.(trailheads, [input], [true])))
# part two
println(sum(find_path.(trailheads, [input], [false])))
# input 
include("Utils.jl")
using .Utils
input = get_example(2024,16)
input = split.(input,"")
input = mapreduce(permutedims, vcat, input)
input = [string(i) for i in input]
directions = CartesianIndex.([(0,1),(-1,0),(0,-1),(1,0)])
# part one 
function _all_paths(input, u, d, visited, path)
    visited[u] = true
    append!(path, [u])
    if u == d
        println(path)
    else
        neighbors = [(u + j) for j in directions
            if (input[u + j] != "#") & in((u + j), keys(visited))
        ]
        for n in neighbors
            if !visited[n]
                _all_paths(input, n, d, visited, path)
            end
        end
    end
    x = pop!(path)
    visited[u] = false
end

function all_paths(input)
    start = findfirst(x->x=="S",input)
    dest = findfirst(x->x=="E",input)
    vertices = findall(x->x!="#",input)
    visited = Dict(v => false for v in vertices)
    return _all_paths(input, start, dest, visited, [])
end

all_paths(input)
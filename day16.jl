# input 
include("Utils.jl")
using .Utils
input = [string(i) for i in mapreduce(permutedims, vcat, split.(get_input(2024,16),""))]
# part one 
directions = [(0,1),(-1,0),(0,-1),(1,0)]
prev = Dict()
start, target_node = (Tuple(findfirst(x->x==y, input)) for y in ["S","E"])
vertices = Dict((x,y) => Inf for x in Tuple.(findall(x->x!="#", input)), y in directions)
vertices[(start,(0,1))] = 0
unvisited = copy(vertices)
while length(unvisited) > 0
    current_node, current_direction = findmin(unvisited)[2]
    neighbors = [(current_node .+ j,j) for j in directions
        if (input[current_node[1] + j[1], current_node[2] + j[2]] != "#") & 
            in((current_node .+ j,j), keys(unvisited))
    ]
    for n in neighbors
        old_dist = vertices[n]
        if current_direction == n[2]
            new_dist = vertices[(current_node, current_direction)] + 1
        else
            new_dist = vertices[(current_node, current_direction)] + 1001
        end
        if old_dist >= new_dist
            vertices[n], unvisited[n] = new_dist, new_dist
            if n in keys(prev)
                push!(prev[n], (current_node, current_direction))
            else
                prev[n] = [(current_node, current_direction)]
            end
        end
    end
    delete!(unvisited, (current_node, current_direction))
end
println(minimum([vertices[(target_node,x)] for x in directions]))
# part two
path = []
target_dir = directions[argmin([vertices[(target_node,x)] for x in directions])]
tocheck = [(target_node,target_dir)]
while tocheck != []
    u = pop!(tocheck)
    if in(u, keys(prev))
        push!(path, u)
        append!(tocheck, prev[u])
    end
end
println(length(unique([x[1] for x in path])) + 1)
# input 
include("Utils.jl")
using .Utils
input = get_example(2024,16)
input = split.(input,"")
input = mapreduce(permutedims, vcat, input)
input = [string(i) for i in input]
# part one 
start = Tuple(findfirst(x->x=="S", input))
target_node = Tuple(findfirst(x->x=="E", input))
directions = [(0,1),(-1,0),(0,-1),(1,0)]
vertices = Tuple.(findall(x->x!="#", input))
prev = Dict()
vertices = Dict((x,y) => Inf for x in vertices, y in directions)
vertices[(start,(0,1))] = 0
unvisited = copy(vertices)
while length(unvisited) > 0
    current_node, current_direction = findmin(unvisited)[2]
    neighbors = [(current_node .+ j,j) for j in directions
        if (input[current_node[1] + j[1], current_node[2] + j[2]] != "#") & in((current_node .+ j,j), keys(unvisited))
    ]
    for n in neighbors
        old_dist = vertices[n]
        if current_direction == n[2]
            new_dist = vertices[(current_node, current_direction)] + 1
        else
            new_dist = vertices[(current_node, current_direction)] + 1001
        end
        if old_dist > new_dist
            vertices[n] = new_dist
            unvisited[n] = new_dist
            if n in keys(prev)
                push!(prev[n], (current_node, current_direction))
                println(n)
                println(prev[n])
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
println(length(path))
# input
include("Utils.jl")
using .Utils
input = get_input(2024,20)
mat = [string(i) for i in mapreduce(permutedims, vcat, split.(input,""))]
# part one
DIRECTIONS = CartesianIndex.([(0,1),(-1,0),(0,-1),(1,0)])
inbounds(G, v) = (v[1] > 0) & (v[1] <= size(G)[1]) & (v[2] > 0) & (v[2] <= size(G)[2])
calc_dist(x, y) = abs(y[1]-x[1]) + abs(y[2]-x[2])
# start and ends of the maze
S = findfirst(x->x=="S",mat)
E = findfirst(x->x=="E",mat)
# dijkstra's to map distances between all nodes in maze
vertices = Dict(x => Inf for x in findall(x->x!="#", mat))
vertices[S] = 0
unvisited = copy(vertices)
while unvisited != Dict()
    u = findmin(unvisited)[2]
    delete!(unvisited, u)
    neighbors = [u + d for d in DIRECTIONS 
                 if inbounds(mat, u+d) && 
                 in(u+d, keys(unvisited)) & 
                 (mat[u + d] != "#")]
    for n in neighbors
        vertices[n] = minimum([1 + vertices[u], vertices[n]])
        unvisited[n] = minimum([1 + vertices[u], vertices[n]])
    end
end
# find the cheats if you can disable for n seconds
function find_cheats(max_length)
    cheats = Dict()
    possible_cheat_starts, possible_cheat_ends = keys(vertices), keys(vertices)
    for c in possible_cheat_starts
        cheat_ends = [i for i in possible_cheat_ends if 
                      (calc_dist(i, c) <= max_length) &&
                      ((vertices[i] - vertices[c] - calc_dist(i,c)) >= calc_dist(i,c))]
        for d in cheat_ends
            cheats[(c,d)] = vertices[d] - vertices[c] - calc_dist(d,c)
        end
    end
    return cheats
end
my_cheats = find_cheats(2)
println(length(filter(((k,v),) -> v >= 100, my_cheats)))
# part two
my_cheats = find_cheats(20)
println(length(filter(((k,v),) -> v >= 100, my_cheats)))
# input
include("Utils.jl")
using .Utils
input = get_input(2024,18)
input_parsed = [CartesianIndex(parse(Int64, x[2]) + 1, parse(Int64,x[1]) + 1) 
                for x in split.(input,",")]
DIMS = 71
S = CartesianIndex(1,1)
E = CartesianIndex(DIMS, DIMS)
DIRECTIONS = CartesianIndex.([(0,1),(-1,0),(0,-1),(1,0)])
# part one
inbounds(G, v) = (v[1] > 0) & (v[1] <= size(G)[1]) & (v[2] > 0) & (v[2] <= size(G)[2])
function plot_input(input, n_bytes)
    mat = fill(".",DIMS, DIMS)
    for x in input[1:minimum([n_bytes,length(input)])] mat[x] = "#" end
    return mat
end
function dist_to_exit(input, n)
    mat = plot_input(input, n)
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
    return vertices[E]
end
println(Int(dist_to_exit(input_parsed, 1024)))
# part two
global counter = 1024
while !isinf(dist_to_exit(input_parsed, counter)) counter = counter + 1 end
println(input[counter])
# input
include("Utils.jl")
using .Utils
using Graphs
input = get_example(2024,23)
input = split.(input,"-")
input_x = [i[1] for i in input]
input_y = [i[2] for i in input]
computers = unique(collect(Base.Iterators.flatten(input)))
lookup = Dict(computers[x] => x for x in eachindex(computers))
g = SimpleGraph(length(computers),0)
map((i) -> add_edge!(g, lookup[input_x[i]], 
                        lookup[input_y[i]]),
                     eachindex(input))
# part one
ts = [lookup[x] for x in computers[occursin.(r"^t", computers)]]
println(length(unique(vcat(vcat(
    [[[Set([t, n, x]) 
        for x in intersect(neighbors(g, t), neighbors(g, n))] 
        for n in neighbors(g, t)] 
        for t in ts]...)...)
)))
# part two
replace(join(sort(
    computers[argmax(length, maximal_cliques(g))]
) .* ","),r",$"=>"")
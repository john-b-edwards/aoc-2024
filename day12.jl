# input
include("Utils.jl")
using .Utils
input = get_input(2024,12)
input = split.(input,"")
input = mapreduce(permutedims, vcat, input)
input = [string(x) for x in input]
# part one
# test if point is inbounds
inbounds(G, v) = (v[1] > 0) & (v[1] <= size(G)[1]) & (v[2] > 0) & (v[2] <= size(G)[2])
# for a point, find all other points in its group
function find_all_in_group(G, root)
    Q = [root]
    explored = [root]
    valid = [root]
    while Q != []
        v = pop!(Q)
        for (i,j) in [(-1,0),(1,0),(0,-1,),(0,1)]
            if inbounds(G, (v[1] + i,v[2] + j)) && 
                G[CartesianIndex(v[1] + i, v[2] + j)] == G[root] && 
                !in(CartesianIndex(v[1] + i, v[2] + j), explored)
                push!.([Q,valid,explored], [CartesianIndex(v[1] + i, v[2] + j)])
            end
        end
    end
    return valid
end
# calculate the value for the number of perimeters for each square
function calc_value_1(group)
    return sum([(4 - sum(in.(CartesianIndex.(
            [(g[1] + 1, g[2]),(g[1] - 1, g[2]),(g[1], g[2] + 1),(g[1], g[2] - 1)]
        ),[group]))) for g in group]) * length(group)
end
# find the number of unique groups
groups = unique(collect(Iterators.flatten([[sort(find_all_in_group(input, CartesianIndex(i,j))) 
for i in 1:size(input)[1]] for j in 1:size(input)[2]])))
println(sum(calc_value_1.(groups)))
# part two
# expand the matrix a little bit
new_input = fill(" ", (size(input) .+ 2)...)
new_input[2:size(input)[1] + 1, 2:size(input)[2] + 1] = input
input = new_input
groups = unique(collect(Iterators.flatten([[sort(find_all_in_group(input, CartesianIndex(i,j))) 
for i in 1:size(input)[1]] for j in 1:size(input)[2]])))
# filter out the group w/ expanded space
groups = [group for group in groups if input[group[1]] != " "]
# calculate the number of corners (=the number of sides)
function calc_value_2(group)
    return length(group) * 
    sum(sum([[
        ifelse(sum(in.(CartesianIndex.([(i,j),(i,j+1),(i+1,j),(i+1,j+1)]), [group])) in [1,3],1,
        ifelse(((CartesianIndex(i,j) in group) & (CartesianIndex(i+1,j+1) in group) & !(CartesianIndex(i,j+1) in group) & !(CartesianIndex(i+1,j) in group)) | 
        ((CartesianIndex(i,j+1) in group) & (CartesianIndex(i+1,j) in group) & !(CartesianIndex(i+1,j+1) in group) & !(CartesianIndex(i,j) in group)),2,0)) 
        for i in 1:size(new_input)[1]-1] 
            for j in 1:size(new_input)[2]-1]))
end
sum(calc_value_2.(groups))
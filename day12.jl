# input
include("Utils.jl")
using .Utils
input = get_input(2024,12)
#= input = get_example(2024,12,override="AAAAAA
AAABBA
AAABBA
ABBAAA
ABBAAA
AAAAAA") =#
input = split.(input,"")
input = mapreduce(permutedims, vcat, input)
input = [string(x) for x in input]
# part one
# group and search
function find_all_in_group(G, root)
    Q = [root]
    explored = [root]
    valid = [root]
    while Q != []
        v = pop!(Q)
        for i in -1:1, j in -1:1
            if (abs(i) != abs(j)) && 
                (v[1] + i > 0) & 
                (v[1] + i <= size(G)[1]) & 
                (v[2] + j > 0) & 
                (v[2] + j <= size(G)[2])
                point = CartesianIndex(v[1] + i, v[2] + j)
                if G[point] == G[root] && !in(point, explored)
                    push!(Q, point)
                    push!(valid, point)
                    push!(explored, point)
                end
            end
        end
    end
    return valid
end

function calc_value(group)
    total_sides = 0
    for g in group
        sides = 4
        if CartesianIndex(g[1] + 1, g[2]) in group
            sides = sides - 1
        end
        if CartesianIndex(g[1] - 1, g[2]) in group
            sides = sides - 1
        end
        if CartesianIndex(g[1], g[2] + 1) in group
            sides = sides - 1
        end
        if CartesianIndex(g[1], g[2] - 1) in group
            sides = sides - 1
        end
        total_sides = total_sides + sides
    end
    return total_sides * length(group)
end

groups = unique(collect(Iterators.flatten([[sort(find_all_in_group(input, CartesianIndex(i,j))) 
for i in 1:size(input)[1]] 
    for j in 1:size(input)[2]])))

sum(calc_value.(groups))
# part two
# expand the matrix a little bit
new_input = fill(" ", (size(input) .+ 2)...)
new_input[2:size(input)[1] + 1, 2:size(input)[2] + 1] = input
input = new_input
groups = unique(collect(Iterators.flatten([[sort(find_all_in_group(input, CartesianIndex(i,j))) 
for i in 1:size(input)[1]] 
    for j in 1:size(input)[2]])))
groups = [group for group in groups if input[group[1]] != " "]
function calc_value_2(group)
    corners = 0
    for i in 1:size(new_input)[1]-1
        for j in 1:size(new_input)[2]-1
            window = collect(Iterators.flatten([[CartesianIndex(x,y) for x in i:i+1] for y in j:j+1]))
            if sum(in.(window, [group])) in [1,3]
                corners = corners + 1
            elseif (window[1] in group) & (window[4] in group) & !(window[2] in group) & !(window[3] in group)
                corners = corners + 2
            elseif (window[2] in group) & (window[3] in group) & !(window[4] in group) & !(window[1] in group)
                corners = corners + 2
            end
        end
    end
    return corners * length(group)
end
sum(calc_value_2.(groups))
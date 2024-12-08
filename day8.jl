# input
include("Utils.jl")
using .Utils
input = get_input(2024,8)
input = split.(input,"")
input = mapreduce(permutedims, vcat, input)
# part one
inbounds_test(node, rows, cols) = (node[1] <= rows) & (node[1] > 0) & (node[2] <= cols) & (node[2] > 0)
chars = [string(char) for char in unique(Iterators.flatten(input)) if char != '.']
rows,cols = size(input)
refmat = fill(".",(rows,cols))
for char in chars
    for pair in Iterators.product(findall(x->x == char, input),findall(x->x == char, input))
        if pair[1] != pair[2]
            antinode_one, antinode_two = pair[1] + (pair[1] - pair[2]), pair[2] + (pair[2] - pair[1])
            if inbounds_test(antinode_one, rows, cols) refmat[antinode_one] = "#" end
            if inbounds_test(antinode_two, rows, cols) refmat[antinode_two] = "#" end
        end
    end
end
println(length(findall(x->x == "#", refmat)))
# part two
refmat = fill(".",(rows,cols))
for char in chars
    for pair in Iterators.product(findall(x->x == char, input),findall(x->x == char, input))
        if pair[1] != pair[2]
            antinode_one, antinode_two = pair[1] + (pair[1] - pair[2]), pair[2] + (pair[2] - pair[1])
            inbounds_one, inbounds_two = true, true
            while inbounds_one
                if inbounds_test(antinode_one, rows, cols) 
                    refmat[antinode_one] = "#" 
                    antinode_one = antinode_one + (pair[1] - pair[2])
                else
                    inbounds_one = false
                end
            end
            while inbounds_two
                if inbounds_test(antinode_two, rows, cols) 
                    refmat[antinode_two] = "#" 
                    antinode_two = antinode_two + (pair[2] - pair[1])
                else
                    inbounds_two = false
                end
            end
        end
    end
end
println(length(unique(cat(findall(x->x != ".", refmat),findall(x->x != ".",input),dims=1))))
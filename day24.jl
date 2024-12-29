# input
include("Utils.jl")
using .Utils
using Graphs
# using BenchmarkTools
input = get_input(2024,24)
input_1 = [x for x in input if length(x) == 2]
initial_keys = Dict(replace(i[1],":"=>"") => parse(Int64, i[2]) for i in input_1)
input_2 = [x for x in input if length(x) != 2]
all_ins = collect(Base.Iterators.flatten([(x[1], x[3], x[5]) for x in input_2]))
z_sorted = [i for i in input_2 if occursin(r"^z",i[5])][sortperm([i[5] for i in input_2 if occursin(r"^z",i[5])],rev=true)]
# part one
function parse_input_2(i)
    if !in(i[1], keys(values))
        if i[1] in keys(initial_keys)
            values[i[1]] = initial_keys[i[1]]
        else
            new_line = [j for j in input_2 if j[5] == i[1]][1]
            values[i[1]] = parse_input_2(new_line)
        end
    end
    if !in(i[3], keys(values))
        if i[3] in keys(initial_keys)
            values[i[3]] = initial_keys[i[3]]
        else
            new_line = [j for j in input_2 if j[5] == i[3]][1]
            values[i[3]] = parse_input_2(new_line)
        end
    end
    if i[2] == "AND"
        values[i[5]] = values[i[1]] & values[i[3]]
    elseif i[2] == "OR"
        values[i[5]] = values[i[1]] | values[i[3]]
    elseif i[2] == "XOR"
        values[i[5]] = values[i[1]] ⊻ values[i[3]]
    end
end
values = Dict()
println(parse(Int64, join(parse_input_2.(z_sorted)), base=2))
# part two
my_vec = ['x','y','z']
println(join(sort(unique([i[5] for i in input_2 if 
    (
        (i[2] == "XOR") & 
        !in(i[1][1],my_vec) & 
        !in(i[3][1],my_vec) & 
        !in(i[5][1],my_vec)
    ) |
    (
        (i[2] == "XOR") && 
            length([j for j in input_2 if (i[5] in [j[1],j[3]]) & 
                    (j[2] == "OR")]) > 0
    ) |
    (
        (i[2] == "AND") & 
        !in("x00",[i[1],i[3]]) && 
            length([j for j in input_2 if (i[5] in [j[1],j[3]]) & 
                    (j[2] != "OR")]) > 0
    ) |
    (
        (i[5][1] == 'z') & 
        (i[2] != "XOR") & 
        (i[5] != "z45")
    )
])) .* ",")[1:end-1])

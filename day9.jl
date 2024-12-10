# input
include("Utils.jl")
using .Utils
using ProgressBars
input = get_example()
input = split(string(input[1]),"")
calc_checksum(my_vec) = sum([(x-1) * my_vec[x] for x in eachindex(my_vec) if my_vec[x] != "."])
# part one
my_vec = collect(Base.Iterators.flatten([ifelse(i % 2 == 1,
collect(Base.Iterators.repeated(floor(i / 2), parse(Int64, input[i]))),
repeat(["."], parse(Int64, input[i])))
for i in eachindex(input)
]))
empty = findall(x -> x == ".",my_vec)
full = findall(x -> x!= ".",my_vec)
my_vec[empty] = reverse(my_vec[full])[1:length(empty)]
my_vec = my_vec[1:length(full)]
println(Int(calc_checksum(my_vec)))
# part two
my_vec = collect(Base.Iterators.flatten([ifelse(i % 2 == 1,
collect(Base.Iterators.repeated(floor(i / 2), parse(Int64, input[i]))),
repeat(["."], parse(Int64, input[i])))
for i in eachindex(input)
]))
file_types = reverse([file for file in unique(my_vec) if (file != ".") & (file != 0)])
for file_type in tqdm(file_types)
    file_loc = findall(x->x == file_type,my_vec)
    n_blocks = length(file_loc)
    for j in 1:file_loc[1]
        if all(my_vec[j:(j + n_blocks-1)] .== ".")
            my_vec[j:(j + n_blocks-1)] = my_vec[file_loc]
            my_vec[file_loc] .= "."
            break
        end
    end
end
println(my_vec)
global my_sum = 0
for x in tqdm(1:length(my_vec))
    if my_vec[x] != "."
        global my_sum = my_sum + (x-1) * my_vec[x]
    end
end
println(my_sum)


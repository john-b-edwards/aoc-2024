# input
include("Utils.jl")
using .Utils
input = get_input(2024,25)
input = [string(i) for i in mapreduce(permutedims, vcat, split.(input,""))]
keys_and_locks = [input[i:i+6,:] for i in 1:7:size(input)[1]]
my_keys = [x for x in keys_and_locks if all(x[1:1,1:5] .== "#")]
my_locks = [x for x in keys_and_locks if all(x[7:7,1:5] .== "#")]
function test_fit(my_key, my_lock)
    key_heights = [sum(my_key[2:7,i] .== "#") for i in 1:5]
    lock_heights = [sum(my_lock[1:6,i] .== "#") for i in 1:5]
    return all((key_heights .+ lock_heights) .<= 5)
end
counter = 0
for my_key in my_keys
    for my_lock in my_locks
        if test_fit(my_key, my_lock)
            global counter = counter + 1
        end
    end
end
println(counter)
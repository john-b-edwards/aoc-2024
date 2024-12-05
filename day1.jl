# input
include("Utils.jl")
using .Utils
input = get_input(2024,1)
lhs = [i[1] for i in input] # grab the values and split them into two vectors
rhs = [i[2] for i in input]
# part one
sort!(lhs) # sort them independenlty
sort!(rhs) # data science trick, sort your x and y independently to get awesome Rsq values
println(sum(abs.(lhs .- rhs))) # find the total difference between each value
# part two
# for each value in the lhs, multiply it by how often it appears in the rhs and sum
println(sum([i * sum(i .== rhs) for i in lhs])) 
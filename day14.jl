# input
include("Utils.jl")
using .Utils
using Statistics
input = get_input(2024,14)
dims = (103,101)
input = [Dict("p" => reverse(parse.(Int64,split(split(i[1],"=")[2],","))),
              "v" => reverse(parse.(Int64,split(split(i[2],"=")[2],","))))
        for i in input]
# part one
function plot_grid(dims, steps, input)
    grid = zeros(dims...)
    for robot in input
        new_cords = [(1 + robot["p"][x] + robot["v"][x] * steps) % dims[x] for x in 1:2]
        if (new_cords[1] < 1) new_cords[1] = dims[1] + new_cords[1] end
        if (new_cords[2] < 1) new_cords[2] = dims[2] + new_cords[2] end
        grid[new_cords...] = grid[new_cords...] + 1
    end
    return grid
end
p1_grid = plot_grid(dims, 100, input)
println(Int(
    sum(p1_grid[Int.(1:median(1:dims[1])-1), Int.(1:median(1:dims[2])-1)]) *
    sum(p1_grid[Int.(median(1:dims[1])+1:dims[1]), Int.(1:median(1:dims[2])-1)]) *
    sum(p1_grid[Int.(1:median(1:dims[1])-1), Int.(median(1:dims[2])+1:dims[2])]) *
    sum(p1_grid[Int.(median(1:dims[1])+1:dims[1]), Int.(median(1:dims[2])+1:dims[2])])
))
# part two
global counter = 1
while any(plot_grid(dims, counter, input) .> 1)
    global counter = counter + 1
end
println(counter)
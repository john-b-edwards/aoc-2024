# input
include("Utils.jl")
using .Utils
using CategoricalArrays
input = get_input(2024,5)
# part one
find_sum_med(vec) = sum(parse.(Int64,getindex.(vec,Int.(floor.(length.(vec) ./ 2) .+ 1))))
rules = split.(input[occursin.("|",input)],"|")
orders = split.(input[occursin.(",",input)],",")
correct_orders = [order for order in orders 
                    if !any([(rule[1] in order) & (rule[2] in order) && 
                        findfirst(x -> x == rule[1],order) > findfirst(x -> x == rule[2],order) 
                            for rule in rules])]
println(find_sum_med(correct_orders))
# part two
wrong_orders = orders[.!in.(orders,[correct_orders])]
for order in wrong_orders, i in 1:length(order)-1, j in 2:length(order)
    if !in([order[j-1],order[j]],rules)
        tmp = order[j-1]
        order[j-1] = order[j]
        order[j] = tmp
    end
end
println(find_sum_med(wrong_orders))
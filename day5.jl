# input
include("Utils.jl")
using .Utils
using CategoricalArrays
input = get_input(2024,5)
# part one
find_sum_med(vec) = sum(parse.(Int64,getindex.(vec,Int.(floor.(length.(vec) ./ 2) .+ 1))))
orders = split.(input[1:1176],"|")
pages = split.(input[1177:end],",")
correct_pages = [page for page in pages 
                    if !any([(order[1] in page) & (order[2] in page) && 
                        findfirst(x -> x == order[1],page) > findfirst(x -> x == order[2],page) 
                            for order in orders])]
println(find_sum_med(correct_pages))
# part two
wrong_pages = pages[.!in.(pages,[correct_pages])]
for page in wrong_pages
    n_pages = length(page)
        for i = 1:n_pages-1
            for j = 2:n_pages
                if !in([page[j-1],page[j]],orders)
                    tmp = page[j-1]
                    page[j-1] = page[j]
                    page[j] = tmp
                end
            end
        end
end
println(find_sum_med(wrong_pages))
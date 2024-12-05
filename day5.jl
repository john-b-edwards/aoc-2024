# input
include("Utils.jl")
using .Utils
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
    out_of_order = true
        while out_of_order
            swaps = 0
            for order in orders
                if (order[1] in page) & (order[2] in page)
                    if findfirst(x -> x == order[1],page) > findfirst(x -> x == order[2],page)
                        page[findfirst(x -> x == order[1],page)] = order[2]
                        page[findfirst(x -> x == order[2],page)] = order[1]
                        swaps = swaps + 1
                    end
                end
            end
            if swaps == 0
                out_of_order = false
            end
        end
end
println(find_sum_med(wrong_pages))
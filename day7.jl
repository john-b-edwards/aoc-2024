# input
include("Utils.jl")
using .Utils
input = get_input(2024,7)
# part one
function test_line(i, ops)
    test = parse(Int64, replace(i[1], r":"=>""))
    is_correct = false
    for op in Base.Iterators.product(Base.Iterators.repeated(ops, length(i)-2)...)
        test_num = parse(Int64, i[2])
        for k in 3:length(i)
            if test_num > test_num
                break
            elseif op[k-2] == "+"
                test_num = test_num + parse(Int64, i[k])
            elseif op[k-2] == "*"
                test_num = test_num * parse(Int64, i[k])
            else
                test_num = parse(Int64, string(test_num) * i[k])
            end
            if test == test_num
                is_correct = true
                break
            end
        end
        if is_correct
            break
        end
    end
    return ifelse(is_correct, test, 0)
end
println(sum(test_line.(input, [["+","*"]])))
# part two
println(sum(test_line.(input, [["+","*","||"]])))
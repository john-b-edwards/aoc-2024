# input
include("Utils.jl")
using .Utils
using JuMP
using COPT
input = get_input(2024,13)
# part one
input = [Dict("button_a" => (parse(Int64,input[x-2][3][2:end-1]),parse(Int64,input[x-2][4][2:end])),
              "button_b" => (parse(Int64,input[x-1][3][2:end-1]),parse(Int64,input[x-1][4][2:end])),
              "prize" => (parse(Int64,input[x][2][3:end-1]),parse(Int64,input[x][3][3:end]))) 
        for x in 3:3:length(input)]
function solve_machine(machine, upper_bound = 100, value_offset = 0)
    model = Model(COPT.Optimizer)
    if !ismissing(upper_bound)
        @variable(model, upper_bound >= A >= 0, Int)
        @variable(model, upper_bound >= B >= 0, Int)
    else
        @variable(model, A >= 0, Int)
        @variable(model, B >= 0, Int)
    end
    @objective(model, Min, 3A + B)
    @constraint(model, A * machine["button_a"][1] + 
                       B * machine["button_b"][1] == BigInt(machine["prize"][1] + value_offset))
    @constraint(model, A * machine["button_a"][2] + 
                       B * machine["button_b"][2] == BigInt(machine["prize"][2] + value_offset))
    optimize!(model);
    return ifelse(!is_solved_and_feasible(model), 0, 3 * Int(value(A)) + Int(value(B)))
end
Int(sum(solve_machine.(input)))
# part two
Int(sum(solve_machine.(input, missing, 10000000000000)))
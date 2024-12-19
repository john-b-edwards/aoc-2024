# input 
include("Utils.jl")
using .Utils
input = get_input(2024,17)
A = parse(Int64, input[1][3])
B = parse(Int64, input[2][3])
C = parse(Int64, input[3][3])
prog = parse.(Int64, split(input[4][2],","))
# part one
function computer(A, prog)
    combo = Dict(0=>0,1=>1,2=>2,3=>3,4=>A,5=>B,6=>C)
    pointer = 0
    vals = []
    while true
        if pointer + 1 > length(prog) break end
        jump_pointer = true
        opcode,operand = prog[pointer+1:pointer+2]
        if opcode == 0 combo[4] = Int(floor(combo[4] / 2 ^ combo[operand]))
        elseif opcode == 1 combo[5] = combo[5] ⊻ operand
        elseif opcode == 2 combo[5] = combo[operand] % 8
        elseif (opcode == 3) && (combo[4] != 0)
            pointer = operand
            jump_pointer = false
        elseif opcode == 4 combo[5] = combo[5] ⊻ combo[6]
        elseif opcode == 5 append!(vals,combo[operand] % 8)
        elseif opcode == 6 combo[5] = Int(floor(combo[4] / 2 ^ combo[operand]))
        elseif opcode == 7 combo[6] = Int(floor(combo[4] / 2 ^ combo[operand])) end
        pointer = pointer + 2 * jump_pointer
    end
    return vals
end
println(computer(A, prog))
# part two
function find_quine(prog)
    combo = Dict(0=>0,1=>1,2=>2,3=>3,4=>A,5=>B,6=>C)
    adv_ndx = findfirst(x->(prog[x]==0) & (x % 2 == 1), eachindex(prog))
    multiplier = 2 ^ combo[prog[adv_ndx + 1]]
    counter, prog_counter = 0,0
    while prog_counter < length(prog)
        if computer(counter, prog) == prog break
        elseif computer(counter, prog) == prog[end-prog_counter:end]
            counter = counter * multiplier
            prog_counter = prog_counter + 1
        else counter = counter + 1 end
    end
    return counter
end
println(find_quine(prog))
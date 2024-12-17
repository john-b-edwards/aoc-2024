# input 
include("Utils.jl")
using .Utils
# input = get_example(2024,17)
# part one
function computer(A::Int, prog::Vector{Int})
    reg = Dict("A" => A,"B" => 0,"C" => 0)
    combo = Dict(0=>0,1=>1,2=>2,3=>3,4=>reg["A"],5=>reg["B"],6=>reg["C"])
    pointer = 0
    vals = []
    while true
        println(pointer)
        println(reg)
        if pointer + 1 > length(prog)
            break
        end
        jump_pointer = true
        opcode = prog[pointer+1]
        operand = prog[pointer+2]
        if opcode == 0
            reg["A"] = Int(floor(reg["A"] / 2 ^ combo[operand]))
        elseif opcode == 1
            reg["B"] = reg["B"] ⊻ operand
        elseif opcode == 2
            reg["B"] = combo[operand] % 8
        elseif (opcode == 3) && (reg["A"] != 0)
            pointer = operand
            jump_pointer = false
        elseif opcode == 4
            reg["B"] = reg["B"] ⊻ reg["C"]
        elseif opcode == 5
            append!(vals,combo[operand] % 8)
        elseif opcode == 6
            reg["B"] = Int(floor(reg["A"] / 2 ^ combo[operand]))
        elseif opcode == 7
            reg["C"] = Int(floor(reg["A"] / 2 ^ combo[operand]))
        end
        combo = Dict(0=>0,1=>1,2=>2,3=>3,4=>reg["A"],5=>reg["B"],6=>reg["C"])
        if jump_pointer
            pointer = pointer + 2
        end
    end
    return vals
end
computer(117440, [0,3,5,4,3,0])
# part two
function inverse_computer(prog)
    pointer = length(prog)
    prev_pointer = length(prog)
    reg = Dict("A" => 0,"B" => 0,"C" => 0)
    combo = Dict(0=>0,1=>1,2=>2,3=>3,4=>reg["A"],5=>reg["B"],6=>reg["C"])
    while true
        pointer = pointer - 2
end
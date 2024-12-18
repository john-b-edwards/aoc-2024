# input 
include("Utils.jl")
using .Utils
# part one
function computer(A::Int, prog::Vector{Int})
    reg = Dict("A" => A,"B" => 0,"C" => 0)
    combo = Dict(0=>0,1=>1,2=>2,3=>3,4=>reg["A"],5=>reg["B"],6=>reg["C"])
    pointer = 0
    vals = []
    while true
        if pointer + 1 > length(prog)
            break
        end
        jump_pointer = true
        opcode = prog[pointer+1]
        operand = prog[pointer+2]
        println(pointer)
        println(reg)
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
    combo = Dict(0=>0,1=>1,2=>2,3=>3,4=>missing,5=>missing,6=>missing)
    operator_ndx = findfirst(x->(prog[x] == 5) & (x % 2 == 1),[i for i in eachindex(prog)]) - 2
    y = length(prog)
    while y > 0
        p = prog[y]
        if (operator_ndx < 1) && (y != 1) & (reg["A"] != 0)
            operator_ndx = findfirst(x->(prog[x] == 3) & (x % 2 == 1),[i for i in eachindex(prog)])
            operator_ndx = operator_ndx - 2
        end
        if operator_ndx >= 1
            opcode = prog[operator_ndx]
            operand = prog[operator_ndx + 1]
            if opcode == 5
                combo[operand] = p
                reg = Dict("A"=>combo[4],"B"=>combo[5],"C"=>combo[6])
                y = y - 1
                operator_ndx = findfirst(x->(prog[x] == 5) & (x % 2 == 1),[i for i in eachindex(prog)]) - 2
            elseif opcode == 0
                reg["A"] = reg["A"] * 2 * combo[operand]
                combo[4] = reg["A"]
                operator_ndx = operator_ndx - 2
            end
        end
    end
end
# input
include("Utils.jl")
using .Utils
input = join(get_input(2024,3))
# part one 
# find all 
function parse_input(input)
    val = sum([prod([parse(Int64,y.match) for y in eachmatch(r"[0-9]*",x.match) if y.match != ""]) 
                    for x in eachmatch(r"mul\([0-9]*,[0-9]*\)",input)])
    return val
end
println(parse_input(input))
# part two
function clean_input(input)
    return replace(input, r"don't\(\)((.|\n)*?)(do\(\)|$)" => "")
end
println(parse_input(clean_input(input)))
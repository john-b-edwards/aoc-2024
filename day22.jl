# input
include("Utils.jl")
using .Utils
using ProgressBars
input = get_input(2024,22)
# part one 
function sim_secret(val, n)
    for i in 1:n
        val = ((val * 64) ⊻ val) % 16777216
        val = (Int(floor(val / 32)) ⊻ val) % 16777216
        val = ((val * 2048) ⊻ val) % 16777216
    end
    return val
end
println(sum(sim_secret.(input, [2000])))
# part two
changes = Dict()
for secret in tqdm(input)
    all_sequences, tmp_changes = [], []
    for j in 1:2000
        current_price = digits(secret)[1]
        secret = sim_secret(secret, 1)
        new_price = digits(secret)[1]
        change = new_price - current_price
        if j >= 4
            push!(tmp_changes, change)
            if !in(tmp_changes,all_sequences) && tmp_changes in keys(changes) 
                changes[tmp_changes] = changes[tmp_changes] + new_price
            elseif !in(tmp_changes,all_sequences)
                changes[tmp_changes] = new_price
            end
            push!(all_sequences, tmp_changes)
            tmp_changes = tmp_changes[2:end]
        else push!(tmp_changes, change) end
    end
end
println(findmax(changes)[1])
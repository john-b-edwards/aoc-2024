# global input = [8435, 234, 928434, 14, 0, 7, 92446, 8992692]
global input = [0]
global queue = []
using ProgressBars
for blink in 1:10
    while length(input) > 0
        x = pop!(input)
        dig = length(digits(x))
        if x == 0
            x = 1
            push!(queue, x)
        elseif dig % 2 == 0
            println(x)
            x1 = floor(x / 10 ^ (dig/2)) 
            x2 = x - x1 * 10 ^ (dig/2)
            push!(queue, Int(x1))
            push!(queue, Int(x2))
        else
            x = x * 2024
            push!(queue, x)
        end
    end
    global input = copy(queue)
    global queue = []
end
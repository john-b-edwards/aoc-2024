# input
include("Utils.jl")
using .Utils
using OrderedCollections
using ProgressBars
input = get_example(2024,6)
input = split.(input,"")
mat = mapreduce(permutedims, vcat, input)
# part one
MOVES = OrderedDict("^" => [-1,0],">" => [0,1],"v" => [1,0],"<" => [0,-1])
make_move(cord) = cord .+ MOVES[mat[cord...]]
is_inbounds(cord, rows, cols) = (cord[1] > rows) | (cord[1] < 1) | (cord[2] > cols) | (cord[2] < 1)
start = findall(x->x in ["^",">","v","<"],mat)
global cord = Tuple.(start)[1]
while is_inbounds(cord)
    new_cord = make_move(cord)
    if is_inbounds(new_cord)
        mat[cord...] = "X"
    elseif mat[new_cord...] == "#"
        mat[cord...] = String.(keys(MOVES))[mod(findall(x->x == mat[cord...],String.(keys(MOVES)))[1],4) + 1]
    else
        mat[new_cord...] = mat[cord...]
        mat[cord...] = "X"
        global cord = new_cord
    end
end
println(length(findall(x->x == "X",mat)))
# part two
ref_mat = copy(mat)
global counter = 0
mat = mapreduce(permutedims, vcat, input)
stored_mat = copy(mat)
for i in findall(x->x == "X",ref_mat)
    global mat = copy(stored_mat)
    if !(mat[i] in keys(MOVES)) & (mat[i] != "#")
        movement_mat = fill(".",size(mat))
        mat[i] = "#"
        local inbounds = true
        local cord = Tuple.(start)[1]
        while inbounds
            new_cord = make_move(cord)
            if (new_cord[1] > size(mat)[1]) | (new_cord[1] < 1) | (new_cord[2] > size(mat)[2]) | (new_cord[2] < 1)
                inbounds = false
            elseif mat[new_cord...] == "#"
                mat[cord...] = String.(keys(MOVES))[mod(findall(x->x == mat[cord...],String.(keys(MOVES)))[1],4) + 1]
            else
                mat[new_cord...] = mat[cord...]
                movement_mat[cord...] = mat[cord...]
                cord = new_cord
            end
            if inbounds && mat[cord...] == movement_mat[cord...]
                inbounds = false
                global counter += 1
            end
        end
    end
end
println(counter)